/**
 * theme.js — глобальные скрипты mytheme
 * PrestaShop 9.0 / Vanilla JS (без jQuery, без TypeScript)
 * Подключается с атрибутом defer — DOM гарантированно готов при выполнении
 *
 * СОДЕРЖАНИЕ:
 *  1. SmartSticky         — умная шапка: скрывается при скролле вниз,
 *                           появляется при скролле вверх (IntersectionObserver)
 *  2. CartOffcanvasMode   — переключение mini-cart между bottom/end в зависимости от viewport
 *  3. CartBadgeSync       — синхронизация счётчика корзины в мобильном nav bar
 *  4. MobileNavSpacer     — динамическое выравнивание высоты spacer под bottom nav
 *  5. FooterAccordion     — аккордеон колонок footer (дополнение к Bootstrap Collapse)
 *  6. SearchBarEnhance    — улучшение UX поля поиска (clear button, autofocus в offcanvas)
 *  7. Init                — инициализация всех модулей
 */

"use strict";

/* =============================================================================
 * 1. SMART STICKY HEADER
 *
 * Логика:
 *  — Sentinel-элемент (#header-sentinel) размещается над шапкой.
 *  — IntersectionObserver следит: когда sentinel уходит из viewport
 *    (пользователь проскроллил вниз) → шапка "прилипает" и получает .site-header--compact.
 *  — Отдельный listener на scroll определяет направление:
 *    scrollY увеличивается → скрываем (.site-header--hidden)
 *    scrollY уменьшается  → показываем
 *  — Announcement bar скрывается первым (чуть раньше шапки).
 * ============================================================================= */
const SmartSticky = (() => {
  const SCROLL_THRESHOLD = 10; // px — минимальное смещение для реакции
  const HIDE_DELAY_PX = 80; // px скролла вниз до скрытия шапки

  let header = null;
  let announcementBar = null;
  let lastScrollY = 0;
  let scrollDownTotal = 0;
  let ticking = false;
  let isHidden = false;

  /**
   * Создаём sentinel-элемент над шапкой для определения момента прилипания
   */
  function createSentinel() {
    const sentinel = document.createElement("div");
    sentinel.id = "header-sentinel";
    sentinel.style.cssText =
      "position:absolute;top:0;left:0;width:1px;height:1px;pointer-events:none;visibility:hidden;";
    document.body.insertBefore(sentinel, document.body.firstChild);
    return sentinel;
  }

  function onScroll() {
    if (ticking) return;
    ticking = true;

    requestAnimationFrame(() => {
      const currentScrollY = window.scrollY;
      const delta = currentScrollY - lastScrollY;

      // Игнорируем микродвижения
      if (Math.abs(delta) < SCROLL_THRESHOLD) {
        ticking = false;
        return;
      }

      if (delta > 0) {
        // Скролл ВНИЗ
        scrollDownTotal += delta;

        // Announcement bar скрывается раньше шапки
        if (currentScrollY > 40 && announcementBar) {
          announcementBar.classList.add("announcement-bar--hidden");
        }

        // Шапка скрывается после HIDE_DELAY_PX пикселей скролла вниз
        if (scrollDownTotal > HIDE_DELAY_PX && !isHidden) {
          header.classList.add("site-header--hidden");
          isHidden = true;
        }
      } else {
        // Скролл ВВЕРХ — любой
        scrollDownTotal = 0;

        // Возвращаем шапку целиком (включая announcement bar)
        if (isHidden) {
          header.classList.remove("site-header--hidden");
          isHidden = false;
        }

        // Announcement bar возвращается только у самого верха страницы
        if (currentScrollY < 40 && announcementBar) {
          announcementBar.classList.remove("announcement-bar--hidden");
        }
      }

      // Compact класс — есть когда страница проскроллена
      if (currentScrollY > 0) {
        header.classList.add("site-header--compact");
      } else {
        header.classList.remove("site-header--compact");
        header.classList.remove("site-header--hidden");
        if (announcementBar) {
          announcementBar.classList.remove("announcement-bar--hidden");
        }
        isHidden = false;
        scrollDownTotal = 0;
      }

      lastScrollY = currentScrollY;
      ticking = false;
    });
  }

  function init() {
    header = document.getElementById("site-header");
    if (!header) return; // Desktop header отсутствует (мобиле) — ничего не делаем

    announcementBar = document.querySelector(".announcement-bar");
    lastScrollY = window.scrollY;

    createSentinel();
    window.addEventListener("scroll", onScroll, { passive: true });
  }

  return { init };
})();

/* =============================================================================
 * 2. CART OFFCANVAS MODE
 *
 * Mini-cart offcanvas должен быть:
 *  — На мобиле (< lg):   placement: bottom (offcanvas-bottom)
 *  — На десктопе (≥ lg): placement: end    (offcanvas-end)
 *
 * Bootstrap 5 не поддерживает responsive placement из коробки.
 * Решение: при инициализации и при resize меняем класс на элементе.
 *
 * ⚠️  offcanvas должен быть закрыт в момент смены класса — иначе артефакты.
 * ============================================================================= */
const CartOffcanvasMode = (() => {
  const DESKTOP_BREAKPOINT = 992; // Bootstrap lg

  let cartOffcanvas = null;
  let bsCartInstance = null;
  let resizeTimer = null;

  function setPlacement() {
    if (!cartOffcanvas) return;

    // Не переключаем если offcanvas открыт
    if (cartOffcanvas.classList.contains("show")) return;

    const isDesktop = window.innerWidth >= DESKTOP_BREAKPOINT;

    if (isDesktop) {
      cartOffcanvas.classList.remove("offcanvas-bottom");
      cartOffcanvas.classList.add("offcanvas-end");
    } else {
      cartOffcanvas.classList.remove("offcanvas-end");
      cartOffcanvas.classList.add("offcanvas-bottom");
    }
  }

  function onResize() {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(setPlacement, 150);
  }

  function init() {
    cartOffcanvas = document.getElementById("offcanvasCart");
    if (!cartOffcanvas) return;

    setPlacement(); // Установить правильный режим при загрузке
    window.addEventListener("resize", onResize, { passive: true });
  }

  return { init };
})();

/* =============================================================================
 * 3. CART BADGE SYNC
 *
 * PrestaShop обновляет количество товаров в корзине через AJAX.
 * ps_shoppingcart использует событие 'updateCart' или меняет DOM.
 * Мы слушаем кастомное событие PS и синхронизируем badge в mobile bottom nav.
 *
 * PS9 генерирует событие: document.dispatchEvent(new CustomEvent('updateCart', ...))
 * Данные в event.detail.resp.cart.products_count (или аналог — зависит от версии PS).
 * ============================================================================= */
const CartBadgeSync = (() => {
  function updateBadge(count) {
    const badges = document.querySelectorAll(
      ".cart-count, .mobile-bottom-nav__badge",
    );
    badges.forEach((badge) => {
      if (count > 0) {
        badge.textContent = count > 99 ? "99+" : String(count);
        badge.removeAttribute("hidden");
      } else {
        badge.textContent = "";
      }
    });
  }

  function readInitialCount() {
    // Читаем из PrestaShop переменной prestashop.cart (доступна глобально)
    if (window.prestashop && window.prestashop.cart) {
      const count = window.prestashop.cart.products_count || 0;
      updateBadge(count);
    }
  }

  function init() {
    readInitialCount();

    // Слушаем событие обновления корзины от PrestaShop
    document.addEventListener("updateCart", (e) => {
      const count =
        e.detail?.resp?.cart?.products_count ??
        e.detail?.cart?.products_count ??
        0;
      updateBadge(count);
    });

    // Fallback: слушаем мутации DOM счётчика корзины от ps_shoppingcart
    const psCartCount = document.querySelector(
      ".cart-products-count, #header .cart-count",
    );
    if (psCartCount) {
      const observer = new MutationObserver(() => {
        const text = psCartCount.textContent.trim().replace(/\D/g, "");
        updateBadge(parseInt(text, 10) || 0);
      });
      observer.observe(psCartCount, {
        childList: true,
        subtree: true,
        characterData: true,
      });
    }
  }

  return { init };
})();

/* =============================================================================
 * 4. MOBILE NAV SPACER — динамическое выравнивание высоты
 *
 * Высота .mobile-bottom-nav-spacer должна точно совпадать с реальной
 * высотой .mobile-bottom-nav включая safe-area-inset-bottom (iPhone notch).
 *
 * CSS переменная --mobile-bottom-nav-height задаёт базовую высоту.
 * Но env(safe-area-inset-bottom) может меняться — поэтому JS пересчитывает
 * реальную высоту и выставляет spacer точно в соответствие.
 * ============================================================================= */
const MobileNavSpacer = (() => {
  let bottomNav = null;
  let spacer = null;
  let resizeTimer = null;

  function syncHeight() {
    if (!bottomNav || !spacer) return;

    // Только на мобиле
    if (window.innerWidth >= 992) {
      spacer.style.height = "0";
      return;
    }

    const navHeight = bottomNav.getBoundingClientRect().height;
    spacer.style.height = `${navHeight}px`;
  }

  function onResize() {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(syncHeight, 100);
  }

  function init() {
    bottomNav = document.querySelector(".mobile-bottom-nav");
    spacer = document.querySelector(".mobile-bottom-nav-spacer");

    if (!bottomNav || !spacer) return;

    syncHeight();
    window.addEventListener("resize", onResize, { passive: true });

    // Пересчёт при изменении ориентации устройства
    window.addEventListener("orientationchange", () => {
      setTimeout(syncHeight, 300); // небольшая задержка после смены ориентации
    });
  }

  return { init };
})();

/* =============================================================================
 * 5. FOOTER ACCORDION — дополнительная UX логика
 *
 * Bootstrap Collapse уже работает через data-атрибуты без JS.
 * Здесь добавляем:
 *  — Закрытие других аккордеон-секций при открытии новой (accordion поведение)
 *  — Плавный скролл к открытой секции на очень маленьких экранах
 * ============================================================================= */
const FooterAccordion = (() => {
  function init() {
    // Только на мобиле
    if (window.innerWidth >= 992) return;

    const collapseElements = document.querySelectorAll(".footer-col .collapse");
    if (!collapseElements.length) return;

    collapseElements.forEach((collapseEl) => {
      collapseEl.addEventListener("show.bs.collapse", () => {
        // Закрываем все остальные открытые секции footer
        collapseElements.forEach((other) => {
          if (other !== collapseEl && other.classList.contains("show")) {
            const bsCollapse = window.bootstrap?.Collapse?.getInstance(other);
            if (bsCollapse) bsCollapse.hide();
          }
        });
      });
    });
  }

  return { init };
})();

/* =============================================================================
 * 6. SEARCH BAR ENHANCE
 *
 * Улучшения UX поля поиска:
 *  — Кнопка очистки (×) появляется когда есть текст
 *  — Автофокус на поле в offcanvas мобильного меню при открытии
 *  — Предотвращение двойного submit
 * ============================================================================= */
const SearchBarEnhance = (() => {
  function addClearButton(input) {
    if (!input || input.dataset.clearAdded) return;
    input.dataset.clearAdded = "true";

    const wrapper = input.parentElement;
    if (!wrapper) return;

    // Создаём кнопку очистки
    const clearBtn = document.createElement("button");
    clearBtn.type = "button";
    clearBtn.className = "search-clear-btn";
    clearBtn.setAttribute("aria-label", "Clear search");
    /* clearBtn.innerHTML = '<i class="fa-solid fa-xmark" aria-hidden="true"></i>'; */
    /* clearBtn.style.cssText = `
      display: none;
      position: absolute;
      right: 40px;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      color: #757575;
      cursor: pointer;
      font-size: 0.875rem;
      padding: 4px 8px;
      z-index: 2;
    `; */

    // wrapper должен быть relative
    if (getComputedStyle(wrapper).position === "static") {
      wrapper.style.position = "relative";
    }
    wrapper.appendChild(clearBtn);

    // Показываем/скрываем кнопку при вводе
    input.addEventListener("input", () => {
      clearBtn.style.display = input.value.trim() ? "block" : "none";
    });

    // Очистка поля
    clearBtn.addEventListener("click", () => {
      input.value = "";
      input.focus();
      clearBtn.style.display = "none";
      // Триггерим событие для AJAX поиска PS
      input.dispatchEvent(new Event("input", { bubbles: true }));
    });
  }

  function enhanceSearchInputs() {
    document
      .querySelectorAll(
        'input[type="search"], .search-query, #search_query_top',
      )
      .forEach(addClearButton);
  }

  function initOffcanvasAutoFocus() {
    const mobileMenu = document.getElementById("offcanvasMobileMenu");
    if (!mobileMenu) return;

    mobileMenu.addEventListener("shown.bs.offcanvas", () => {
      const searchInput = mobileMenu.querySelector(
        'input[type="search"], .search-query',
      );
      if (searchInput) {
        // Небольшая задержка — offcanvas animation должна завершиться
        setTimeout(() => searchInput.focus(), 100);
      }
    });
  }

  function init() {
    enhanceSearchInputs();
    initOffcanvasAutoFocus();

    // Если поисковые поля добавились через AJAX — наблюдаем за DOM
    const observer = new MutationObserver(() => {
      enhanceSearchInputs();
    });
    observer.observe(document.body, { childList: true, subtree: true });
  }

  return { init };
})();

/* =============================================================================
 * 6б. LIVE SEARCH — живой поиск с дропдауном
 *
 * Fetch к контроллеру поиска PS9, рендеринг результатов в дропдаун.
 * Работает с id="search_query_top" — стандартный ID для ps_searchbar.
 * Keyboard nav: Arrow Up/Down, Enter, Escape.
 * ============================================================================= */
const LiveSearch = (() => {
  const MIN_CHARS = 2; // минимум символов для запроса
  const DEBOUNCE_MS = 280; // задержка после последнего нажатия
  const RESULTS_MAX = 8; // максимум результатов в дропдауне

  let inputs = []; // все поисковые поля на странице
  let timer = null;
  let activeIdx = -1; // для keyboard navigation

  /* --- Fetch результатов --- */
  async function fetchResults(query, searchUrl) {
    const sep = searchUrl.includes("?") ? "&" : "?";
    const url = `${searchUrl}${sep}s=${encodeURIComponent(query)}&resultsPerPage=${RESULTS_MAX}&ajax=true`;
    try {
      const resp = await fetch(url, {
        headers: {
          Accept: "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
      });
      if (!resp.ok) return null;

      const contentType = resp.headers.get("content-type") || "";
      if (contentType.includes("application/json")) {
        return { type: "json", data: await resp.json() };
      }
      return { type: "html", data: await resp.text() };
    } catch {
      return null;
    }
  }

  /* --- Рендер дропдауна --- */
  function renderDropdown(dropdown, result, query) {
    dropdown.innerHTML = "";
    activeIdx = -1;

    if (!result) {
      closeDropdown(dropdown);
      return;
    }

    let items = [];

    if (result.type === "json") {
      // PS9 AJAX JSON ответ
      const products = result.data.products || result.data || [];
      items = Array.isArray(products) ? products.slice(0, RESULTS_MAX) : [];

      if (!items.length) {
        dropdown.innerHTML = `<div class="search-dropdown__empty">${noResultsText(query)}</div>`;
        openDropdown(dropdown);
        return;
      }

      items.forEach((product, idx) => {
        const name = escHtml(product.name || "");
        const price = product.price || "";
        const img =
          product.cover?.bySize?.small_default?.url ||
          product.cover?.bySize?.cart_default?.url ||
          product.image_url ||
          "";
        const link = product.url || "#";

        const item = document.createElement("a");
        item.href = link;
        item.className = "search-dropdown__item";
        item.setAttribute("role", "option");
        item.setAttribute("data-idx", idx);
        item.innerHTML = `
          ${img ? `<img src="${escHtml(img)}" alt="${name}" class="search-dropdown__img" width="44" height="44" loading="lazy">` : ""}
          <span class="search-dropdown__name">${highlightQuery(name, query)}</span>
          ${price ? `<span class="search-dropdown__price">${escHtml(String(price))}</span>` : ""}
        `;
        dropdown.appendChild(item);
      });
    } else {
      // Fallback: HTML-ответ — парсим ссылки на товары
      const parser = new DOMParser();
      const doc = parser.parseFromString(result.data, "text/html");
      const links = doc.querySelectorAll(
        'a[href*="id_product"], .product-miniature a, h2 a, h3 a',
      );

      if (!links.length) {
        // Если ничего не распарсили — показываем ссылку "Показати всі результати"
        const all = document.createElement("a");
        all.className = "search-dropdown__all";
        all.href = `${dropdown.closest(".search-widget")?.dataset.searchControllerUrl || "#"}&s=${encodeURIComponent(query)}`;
        all.textContent = `Показати всі результати для «${query}»`;
        dropdown.appendChild(all);
        openDropdown(dropdown);
        return;
      }

      const seen = new Set();
      let count = 0;
      links.forEach((link) => {
        if (count >= RESULTS_MAX) return;
        const href = link.href;
        if (seen.has(href)) return;
        seen.add(href);
        count++;

        const item = document.createElement("a");
        item.href = href;
        item.className = "search-dropdown__item";
        item.setAttribute("role", "option");
        item.innerHTML = `<span class="search-dropdown__name">${highlightQuery(escHtml(link.textContent.trim()), query)}</span>`;
        dropdown.appendChild(item);
      });
    }

    // Ссылка «Показати всі результати»
    const searchWidget = dropdown.closest(".search-widget");
    const searchUrl2 = searchWidget?.dataset.searchControllerUrl || "";
    if (searchUrl2) {
      const all = document.createElement("a");
      all.className = "search-dropdown__all";
      all.href = `${searchUrl2}&s=${encodeURIComponent(query)}`;
      all.setAttribute("role", "option");
      all.innerHTML = `<i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i> Всі результати для «<strong>${escHtml(query)}</strong>»`;
      dropdown.appendChild(all);
    }

    openDropdown(dropdown);
  }

  /* --- Хелперы --- */
  function escHtml(str) {
    return str.replace(
      /[&<>"']/g,
      (c) =>
        ({
          "&": "&amp;",
          "<": "&lt;",
          ">": "&gt;",
          '"': "&quot;",
          "'": "&#39;",
        })[c],
    );
  }

  function highlightQuery(text, query) {
    if (!query) return text;
    const safe = query.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    return text.replace(new RegExp(`(${safe})`, "gi"), "<mark>$1</mark>");
  }

  function noResultsText(query) {
    return `Нічого не знайдено для «${escHtml(query)}»`;
  }

  function openDropdown(dropdown) {
    dropdown.removeAttribute("hidden");
    const input = dropdown
      .closest(".search-widget")
      ?.querySelector(".js-search-input");
    if (input) input.setAttribute("aria-expanded", "true");
  }

  function closeDropdown(dropdown) {
    dropdown.setAttribute("hidden", "");
    dropdown.innerHTML = "";
    activeIdx = -1;
    const input = dropdown
      .closest(".search-widget")
      ?.querySelector(".js-search-input");
    if (input) input.setAttribute("aria-expanded", "false");
  }

  /* --- Keyboard navigation --- */
  function handleKeydown(e, input, dropdown) {
    const items = dropdown.querySelectorAll(
      ".search-dropdown__item, .search-dropdown__all",
    );
    if (!items.length) return;

    if (e.key === "ArrowDown") {
      e.preventDefault();
      activeIdx = Math.min(activeIdx + 1, items.length - 1);
      updateActive(items);
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      activeIdx = Math.max(activeIdx - 1, -1);
      updateActive(items);
      if (activeIdx === -1) input.focus();
    } else if (e.key === "Enter" && activeIdx >= 0) {
      e.preventDefault();
      items[activeIdx].click();
    } else if (e.key === "Escape") {
      closeDropdown(dropdown);
      input.blur();
    }
  }

  function updateActive(items) {
    items.forEach((item, i) => {
      item.classList.toggle("search-dropdown__item--active", i === activeIdx);
      if (i === activeIdx) item.scrollIntoView({ block: "nearest" });
    });
  }

  /* --- Привязка к одному input --- */
  function bindInput(input) {
    const widget = input.closest(".search-widget");
    if (!widget) return;

    const dropdown = widget.querySelector(
      "#search-results-dropdown, .search-dropdown",
    );
    if (!dropdown) return;

    const searchUrl =
      input.dataset.searchUrl || widget.dataset.searchControllerUrl || "";
    if (!searchUrl) return;

    // Input → debounce → fetch
    input.addEventListener("input", () => {
      clearTimeout(timer);
      const query = input.value.trim();

      if (query.length < MIN_CHARS) {
        closeDropdown(dropdown);
        return;
      }

      // Показываем скелетон-лоудер
      dropdown.innerHTML =
        '<div class="search-dropdown__loading"><i class="fa-solid fa-circle-notch fa-spin" aria-hidden="true"></i></div>';
      openDropdown(dropdown);

      timer = setTimeout(async () => {
        const result = await fetchResults(query, searchUrl);
        renderDropdown(dropdown, result, query);
      }, DEBOUNCE_MS);
    });

    // Keyboard nav
    input.addEventListener("keydown", (e) => handleKeydown(e, input, dropdown));

    // Закрытие при клике вне поля
    document.addEventListener(
      "click",
      (e) => {
        if (!widget.contains(e.target)) closeDropdown(dropdown);
      },
      { passive: true },
    );

    // Открытие дропдауна при фокусе (если уже есть текст)
    input.addEventListener("focus", () => {
      if (input.value.trim().length >= MIN_CHARS) {
        input.dispatchEvent(new Event("input"));
      }
    });
  }

  function init() {
    inputs = document.querySelectorAll(".js-search-input");
    inputs.forEach(bindInput);
  }

  return { init };
})();

/* =============================================================================
 * 7. INIT — инициализация всех модулей
 *
 * defer гарантирует что DOM готов — DOMContentLoaded не нужен.
 * Порядок важен: Spacer до Sticky (spacer влияет на layout).
 * ============================================================================= */
function initTheme() {
  MobileNavSpacer.init();
  SmartSticky.init();
  CartOffcanvasMode.init();
  CartBadgeSync.init();
  FooterAccordion.init();
  SearchBarEnhance.init();
  LiveSearch.init();
}

// defer гарантирует выполнение после парсинга DOM
// Но на случай если скрипт всё же попал в <head> без defer — страховка:
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initTheme);
} else {
  initTheme();
}
