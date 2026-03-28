/**
 * theme.js — global scripts for mytheme
 * PrestaShop 9.0 / Vanilla JS (no jQuery, no TypeScript)
 * Loaded with defer attribute — DOM is guaranteed ready on execution
 *
 * CONTENTS:
 *  1. MegaMenu            — click open/close + dynamic top positioning on scroll
 *  2. SmartSticky         — compact header on scroll down, restore on scroll up
 *  3. MobileDrawer        — offcanvas mobile menu (custom, no Bootstrap backdrop)
 *  4. DrawerAccordion     — accordion inside mobile drawer (max-height transition)
 *  5. LangSwitcher        — UA / RU language toggle inside drawer
 *  6. CartOffcanvas       — offcanvas-end on desktop, offcanvas-bottom on mobile
 *  7. FooterAccordion     — footer columns accordion on mobile (max-height transition)
 *  8. FooterNewsletter    — newsletter form UX (ps_emailsubscription override hook)
 *  9. ResizeHandler       — consolidated window resize logic
 */

(function () {
  'use strict';

  /* ===========================================================================
   * 1. MEGA MENU — click open / close + dynamic top positioning
   *
   * Expects in HTML:
   *   <li class="has-megamenu">
   *     <a href="#">...</a>
   *     <div class="nav-megamenu">...</div>
   *   </li>
   *
   * Active state managed via .is-active on <li>.
   * Megamenu top is recalculated on scroll/resize so it always sits
   * exactly below #js-site-nav regardless of compact-header state.
   * =========================================================================*/
  const megaMenuItems = document.querySelectorAll('.has-megamenu');

  megaMenuItems.forEach(function (item) {
    const trigger = item.querySelector('a');

    trigger.addEventListener('click', function (e) {
      e.preventDefault();
      e.stopPropagation();

      const isActive = item.classList.contains('is-active');
      megaMenuItems.forEach(function (el) { el.classList.remove('is-active'); });

      if (!isActive) {
        item.classList.add('is-active');
      }
    });

    // Clicks inside the dropdown must not bubble up to the document close handler
    const dropdown = item.querySelector('.nav-megamenu');
    if (dropdown) {
      dropdown.addEventListener('click', function (e) { e.stopPropagation(); });
    }
  });

  // Close all menus on outside click
  document.addEventListener('click', function () {
    megaMenuItems.forEach(function (el) { el.classList.remove('is-active'); });
  });

  /* ===========================================================================
   * 2. SMART STICKY — compact header on scroll
   *
   * Behaviour:
   *  — Scroll down past TOP_ZONE  → add .site-header--compact
   *  — Scroll up                  → remove .site-header--compact
   *  — scrollY ≤ TOP_ZONE         → always expand (full reset)
   *  — Lock timers prevent rapid class-toggling flicker
   *
   * updateMegamenuTop() is called on every scroll frame so the absolute-
   * positioned megamenu dropdowns track the nav bar through the transition.
   * =========================================================================*/
  const siteHdr = document.getElementById('js-site-header');
  const siteNav = document.getElementById('js-site-nav');

  const LOCK_COLLAPSE = 1600; // ms — lock after going compact
  const LOCK_EXPAND = 1600; // ms — lock after expanding
  const LOCK_TOP_REENTRY = 1800; // ms — lock when returning to top zone
  const SCROLL_THRESHOLD = 1;    // px — ignore jitter below this
  const TOP_ZONE = 50;   // px — always expanded below this scrollY

  var lastScrollY = window.scrollY;
  var locked = false;
  var lockTimer = null;
  var initLocked = true;

  // Brief init lock prevents a false "scroll down" on DOMContentLoaded
  setTimeout(function () { initLocked = false; }, 400);

  function setCompact(compact) {
    var already = siteHdr.classList.contains('site-header--compact');
    if (compact === already || locked) return;

    locked = true;
    clearTimeout(lockTimer);
    lockTimer = setTimeout(function () { locked = false; },
      compact ? LOCK_COLLAPSE : LOCK_EXPAND);

    siteHdr.classList.toggle('site-header--compact', compact);
  }

  function updateMegamenuTop() {
    if (!siteNav) return;
    var bottom = siteNav.getBoundingClientRect().bottom;
    document.querySelectorAll('.nav-megamenu').forEach(function (m) {
      m.style.top = bottom + 'px';
    });
  }

  if (siteHdr && siteNav) {
    window.addEventListener('scroll', function () {
      if (initLocked) return;
      var y = window.scrollY;

      updateMegamenuTop();

      if (y <= TOP_ZONE) {
        var wasCompact = siteHdr.classList.contains('site-header--compact');
        siteHdr.classList.remove('site-header--compact');
        lastScrollY = y;
        if (wasCompact) {
          locked = true;
          clearTimeout(lockTimer);
          lockTimer = setTimeout(function () { locked = false; }, LOCK_TOP_REENTRY);
        }
        return;
      }

      if (Math.abs(y - lastScrollY) < SCROLL_THRESHOLD) return;
      setCompact(y > lastScrollY);
      lastScrollY = y;
    }, { passive: true });

    updateMegamenuTop();
    window.addEventListener('resize', updateMegamenuTop);
  }

  /* ===========================================================================
   * 3. MOBILE DRAWER — custom offcanvas (no Bootstrap backdrop)
   *
   * Required IDs in header.tpl:
   *   #offcanvasMobileMenu  — the drawer <div>
   *   #js-drawer-overlay    — full-screen overlay <div>
   *   #js-drawer-close      — close button inside drawer
   *   #js-hamburger-btn     — hamburger trigger (also catches data-bs-toggle buttons)
   *
   * Bootstrap data-bs-toggle attributes are removed from all matching triggers
   * so Bootstrap does not inject its own backdrop element.
   * =========================================================================*/
  (function () {
    var drawerEl = document.getElementById('offcanvasMobileMenu');
    var overlay = document.getElementById('js-drawer-overlay');
    var closeBtn = document.getElementById('js-drawer-close');

    if (!drawerEl || !overlay) return;

    function openDrawer() {
      drawerEl.classList.add('active');
      overlay.classList.add('active');
      document.body.style.overflow = 'hidden';
    }

    function closeDrawer() {
      drawerEl.classList.remove('active');
      document.body.style.overflow = '';
      // Delay overlay fade-out to match drawer slide-out transition (360ms)
      setTimeout(function () { overlay.classList.remove('active'); }, 360);
    }

    // Remove Bootstrap offcanvas attributes so it won't fight our custom logic
    document.querySelectorAll(
      '[data-bs-toggle="offcanvas"][data-bs-target="#offcanvasMobileMenu"],' +
      '[data-bs-toggle="offcanvas"][aria-controls="offcanvasMobileMenu"],' +
      '#js-hamburger-btn'
    ).forEach(function (btn) {
      btn.removeAttribute('data-bs-toggle');
      btn.removeAttribute('data-bs-target');
      btn.removeAttribute('aria-controls');
      btn.addEventListener('click', function (e) {
        e.preventDefault();
        openDrawer();
      });
    });

    if (closeBtn) {
      closeBtn.addEventListener('click', closeDrawer);
    }

    overlay.addEventListener('click', closeDrawer);

    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && drawerEl.classList.contains('active')) {
        closeDrawer();
      }
    });

    /* =========================================================================
     * 4. DRAWER ACCORDION
     *
     * Expects inside #offcanvasMobileMenu:
     *   <div class="mm-acc__item">
     *     <button class="mm-acc__head" aria-expanded="false">Category</button>
     *     <div class="mm-acc__body">...</div>
     *   </div>
     *
     * Uses max-height transition — no layout jump, no requestAnimationFrame needed.
     * Only one item open at a time.
     * =======================================================================*/
    var accItems = drawerEl.querySelectorAll('.mm-acc__item');

    accItems.forEach(function (item) {
      var head = item.querySelector('.mm-acc__head');
      var body = item.querySelector('.mm-acc__body');
      if (!head || !body) return;

      head.addEventListener('click', function () {
        var isOpen = item.classList.contains('is-open');

        // Close all
        accItems.forEach(function (i) {
          i.classList.remove('is-open');
          var b = i.querySelector('.mm-acc__body');
          var h = i.querySelector('.mm-acc__head');
          if (b) b.style.maxHeight = '0';
          if (h) h.setAttribute('aria-expanded', 'false');
        });

        // Open clicked if it was closed
        if (!isOpen) {
          item.classList.add('is-open');
          body.style.maxHeight = body.scrollHeight + 'px';
          head.setAttribute('aria-expanded', 'true');
        }
      });
    });

    /* =========================================================================
     * 5. LANGUAGE SWITCHER inside drawer (UA | RU)
     *
     * Expects: <div id="js-drawer-lang">
     *   <button class="lang-btn" data-lang="ua">UA</button>
     *   <button class="lang-btn" data-lang="ru">RU</button>
     * </div>
     *
     * NOTE: In PS9 multi-language setup replace this demo toggle with
     * ps_languageselector module override or a direct URL redirect.
     * =======================================================================*/
    var langBtns = document.querySelectorAll('#js-drawer-lang .lang-btn');
    var currentLang = 'ua';

    function setActiveLang(lang) {
      langBtns.forEach(function (btn) {
        btn.classList.toggle('active', btn.getAttribute('data-lang') === lang);
      });
      currentLang = lang;
    }

    langBtns.forEach(function (btn) {
      btn.addEventListener('click', function () {
        var lang = btn.getAttribute('data-lang');
        if (lang === currentLang) return;
        setActiveLang(lang);
        closeDrawer();
      });
    });

    // Expose closeDrawer so ResizeHandler (section 9) can call it
    window.__closeDrawer = closeDrawer;
  })();

  /* ===========================================================================
   * 6. CART OFFCANVAS DIRECTION
   *
   * PS9 mini-cart offcanvas: offcanvas-end on desktop (≥768px),
   * offcanvas-bottom on mobile. Recalculated on resize.
   *
   * Bootstrap does not support responsive placement natively — we swap classes
   * via JS; CSS handles the rest (no layout jump because offcanvas is hidden
   * while the swap happens during resize).
   * =========================================================================*/
  function updateCartDirection() {
    var cartEl = document.getElementById('offcanvasCart');
    if (!cartEl) return;
    if (window.innerWidth >= 768) {
      cartEl.classList.remove('offcanvas-bottom');
      cartEl.classList.add('offcanvas-end');
    } else {
      cartEl.classList.remove('offcanvas-end');
      cartEl.classList.add('offcanvas-bottom');
    }
  }

  updateCartDirection();

  /* ===========================================================================
   * 7. FOOTER ACCORDION
   *
   * Activates only on mobile (handled purely in CSS via media query for
   * the toggle button visibility). JS manages max-height and aria-expanded.
   *
   * Expects in footer.tpl:
   *   <button class="footer-col__toggle" aria-controls="footer-col-body-N"
   *           aria-expanded="false">
   *   <div id="footer-col-body-N" class="footer-col__body">...</div>
   *
   * Multiple items can be open simultaneously (independent behaviour).
   * To enforce single-open: uncomment the "close all" block inside click handler.
   * =========================================================================*/
  (function () {
    var toggles = document.querySelectorAll('.footer-col__toggle');

    toggles.forEach(function (btn) {
      var targetId = btn.getAttribute('aria-controls');
      var body = document.getElementById(targetId);
      if (!body) return;

      btn.addEventListener('click', function () {
        var isOpen = btn.getAttribute('aria-expanded') === 'true';

        // Uncomment to enforce single-open behaviour:
        // toggles.forEach(function (b) {
        //   b.setAttribute('aria-expanded', 'false');
        //   var el = document.getElementById(b.getAttribute('aria-controls'));
        //   if (el) el.classList.remove('is-open');
        // });

        btn.setAttribute('aria-expanded', isOpen ? 'false' : 'true');
        body.classList.toggle('is-open', !isOpen);
      });
    });
  })();

  /* ===========================================================================
   * 8. FOOTER NEWSLETTER — ps_emailsubscription UX enhancement
   *
   * This function enhances the submit button UX with a success animation.
   * It is designed to work alongside ps_emailsubscription module override.
   *
   * Usage in footer.tpl module override template:
   *   <button ... onclick="handleFooterSubscribe(this)">
   *
   * NOTE: Actual form submission is handled by ps_emailsubscription module.
   * Replace the success timeout block with a real AJAX response handler
   * when integrating with the module's JS endpoint.
   * =========================================================================*/
  window.handleFooterSubscribe = function (btn) {
    var field = btn.closest('.footer-newsletter__field');
    if (!field) return;
    var input = field.querySelector('input[type="email"]');
    if (!input) return;

    var email = input.value.trim();
    var emailValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

    if (!email || !emailValid) {
      field.style.borderColor = 'oklch(55% 0.20 25 / 0.7)';
      input.focus();
      setTimeout(function () { field.style.borderColor = ''; }, 1500);
      return;
    }

    // Optimistic success UI — replace with real AJAX callback when module is ready
    btn.innerHTML = '<i class="fa-solid fa-check"></i>';
    btn.style.backgroundColor = 'oklch(55% 0.15 145)';
    btn.disabled = true;
    input.value = '';
    input.placeholder = 'Дякуємо! 🎉';

    setTimeout(function () {
      btn.innerHTML = '<i class="fa-solid fa-arrow-right"></i>';
      btn.style.backgroundColor = '';
      btn.disabled = false;
      input.placeholder = 'your@email.com';
    }, 3000);
  };

  /* ===========================================================================
   * 9. RESIZE HANDLER — consolidated, single listener
   *
   * Combines all resize logic in one place to avoid multiple competing
   * window.addEventListener('resize', ...) calls.
   *
   * Responsibilities:
   *  — Auto-close mobile drawer when viewport expands to ≥768px
   *  — Recalculate cart offcanvas direction
   *  — Recalculate megamenu top position
   * =========================================================================*/
  window.addEventListener('resize', function () {
    // Close mobile drawer if viewport expands past mobile breakpoint
    var drawer = document.getElementById('offcanvasMobileMenu');
    var overlayEl = document.getElementById('js-drawer-overlay');

    if (drawer && window.innerWidth >= 768 && drawer.classList.contains('active')) {
      if (typeof window.__closeDrawer === 'function') {
        window.__closeDrawer();
      } else {
        drawer.classList.remove('active');
        document.body.style.overflow = '';
        if (overlayEl) overlayEl.classList.remove('active');
      }
    }

    updateCartDirection();
    updateMegamenuTop();
  });

})();