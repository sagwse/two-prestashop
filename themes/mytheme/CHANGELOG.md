# CHANGELOG — MyShop PrestaShop 9.0 Theme

> Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/)
> Версии следуют [Semantic Versioning](https://semver.org/lang/ru/): MAJOR.MINOR.PATCH
>
> **MAJOR** — кардинальные изменения структуры / несовместимые правки
> **MINOR** — новый функционал (новый шаблон, новая схема, новый модуль)
> **PATCH** — фиксы, правки стилей, мелкие улучшения

---

## Типы изменений

- `Добавлено` — новые файлы, шаблоны, функционал
- `Изменено` — правки существующих файлов
- `Удалено` — удалённые файлы или функционал
- `Исправлено` — баги и ошибки
- `Безопасность` — уязвимости
- `Заметки` — решения, договорённости, важные наблюдения

---

## [Unreleased]
> Здесь накапливаются изменения до следующего релиза.

### Добавлено
-

### Изменено
-

### Исправлено
-

---

## [0.7.2] — 2026-03-19 — Карточка товара: product.css + product.js

### Добавлено
- `assets/css/pages/product.css` — полный CSS карточки товара (~700 строк, 17 компонентов), включая двухколоночный layout, hover zoom, lightbox, sticky bar и аккордеоны.
- `assets/js/pages/product.js` — JS карточки товара (галерея, lightbox с навигацией, выбор вариантов PS9, qty stepper с валидацией, аккордеон, IntersectionObserver для sticky bar, Web Share API).

---

## [0.7.1] — 2026-03-19 — Заглушки (stubs) для установки темы в PS9

### Добавлено
- **~50 файлов-заглушек**, необходимых для установки новой темы в PS9 без ошибок "Отсутствует шаблон...".
- **Layouts**: `layout-right-column.tpl`, `layout-left-column.tpl`, `layout-both-columns.tpl`, `layout-content-only.tpl`, `layout-error.tpl`.
- **Checkout**: `cart.tpl`, `cart-empty.tpl`, `checkout.tpl` и партиалы.
- **Customer**: 18 шаблонов + `page.tpl` (login, registration, history, identity, discount, etc.).
- **CMS**: `page.tpl`, `category.tpl`, `sitemap.tpl`, `stores.tpl`.
- **Errors**: `404.tpl`, `not-found.tpl`, `maintenance.tpl`, `forbidden.tpl`, `restricted-country.tpl`.
- **Contact**: `contact.tpl`.
- Пустые файлы-заглушки для `checkout.css`, `home.css`, `cart.js`, `checkout.js`.

### Исправлено
- Ошибка `global_settings.image_types.cart_default` при установке темы: в `theme.yml` добавлен блок `image_types` со стандартными форматами PS (`cart_default`, `small_default`, `medium_default`, `large_default`, `home_default`, `category_default`, `stores_default`).

---

## [0.7.0] — 2026-03-19 — Карточка товара: product.tpl + 4 партиала

> Исследования, обоснования, спецификации по странице товара вынесены в отдельный документ:
> **`PRODUCT-0.7.0-recommendations.md`** — изучать перед правками любого файла страницы товара.

### Добавлено

**Основной шаблон:**

- `templates/catalog/product.tpl` — страница товара (карточка товара).
  Extends `layout-full-width.tpl`. Структура (13 блоков):
  1. Хлебные крошки — `_partials/breadcrumb.tpl` (условие: `links|@count > 1`)
  2. Flash-уведомления — `_partials/notifications.tpl`
  3. Двухколоночный layout `.product-layout` (≥992px: 55% галерея + 45% панель)
     3a. Галерея (sticky desktop) → `product-images.tpl`
     3b. Покупательская панель:
         H1, рейтинг (3 состояния), идентификация, цены, метки доверия,
         варианты, кнопка «До кошика», wishlist+share, доставка, гарантии
  4. Информационные секции `.product-info-sections` (collapsed sections, 8 секций):
     Опис, Склад, Спосіб застосування, Обов'язкові застереження (закон),
     Деталі та характеристики, Виробник, Сертифікати, FAQ
  5. Відгуки `#product-reviews` — `{hook h='displayProductTabContent'}` → ps_productcomments
  6. Схожі товари — `{hook h='displayFooterProduct'}`, scroll-snap
  7. JSON-LD: `schema-product.tpl` (v0.4.0) + `schema-faq.tpl` (v0.4.0)

  **Ключевые решения:**
  - Вертикально раскрытые секции (НЕ горизонтальные табы) — 27% пользователей
    пропускают контент в табах (Baymard, 2025). Desktop: раскрыты. Mobile: accordion.
  - `<button aria-expanded>` + `<div hidden>` — accordion без JS,
    JS (v0.14.0) добавит toggle-поведение и анимации.
  - Блок «Обов'язкові застереження» — обязательный по Закону № 4122-IX від 05.12.2024.
    Жёсткий текст через `{l}`, не зависит от наличия данных в BO.
  - Рейтинг: 3 состояния (аналогично product-miniature.tpl), ссылка на `#product-reviews`.
  - Features: «Спосіб застосування» и «Нотифікація ДПСС» выделены в отдельные блоки,
    исключены из общей таблицы характеристик для избежания дублирования.

**Партиалы страницы товара:**

- `templates/catalog/_partials/product-images.tpl` — галерея фото товара.
  Desktop: вертикальная колонка миниатюр слева (80px, 72×72) + главное фото (800×800,
  `aspect-ratio: 1/1`, `object-fit: contain`). Mobile: swipe + dots (CSS scroll-snap).
  Lightbox: нативный `<dialog>`, навигация prev/next, счётчик.
  LCP: главное фото `loading="eager"` + `fetchpriority="high"`.
  Клик по главному фото: `data-action="open-lightbox"` → JS (v0.14.0).

- `templates/catalog/_partials/product-prices.tpl` — блок цен товара.
  Текущая цена (крупный шрифт), старая цена (`<del>`), бейдж скидки (pill),
  цена за единицу (≈ X грн за капс.). Все CSS-переменные из `:root`.

- `templates/catalog/_partials/product-variants.tpl` — выбор вариантов (кнопки-пилюли).
  `$product.groups[]` → `<label>` с `<input type="radio">` внутри.
  `role="radiogroup"`, `aria-labelledby`. Три состояния: active, hover, unavailable.
  Лейбл группы с обновляемым выбранным значением `data-selected-value`.
  Ошибка `<p role="alert" hidden>` при попытке добавить без выбора варианта.

- `templates/catalog/_partials/product-add-to-cart.tpl` — кнопка + количество + sticky bar.
  Qty stepper: `[-] input [+]`, `type="number"`, `inputmode="numeric"`, min/max.
  Кнопка: `data-button-action="add-to-cart"` (PS9 стандарт), 3 состояния.
  Предупреждение «Залишилось кілька одиниць!» при `last_remaining_items`.
  Sticky bottom bar (mobile): `position: fixed`,
  `bottom: calc(var(--mobile-bottom-nav-height) + env(safe-area-inset-bottom))`,
  `z-index: 1025` — НАД контентом, НО ПОД mobile-bottom-nav (1030).
  Появление: JS class `.is-visible` через IntersectionObserver (v0.14.0).

### Заметки

**Принятые решения (финальные):**
- Layout страницы: двухколоночный (55/45%) + вертикально раскрытые секции (collapsed).
- Галерея: миниатюры слева (вертикальная колонка, desktop), swipe (mobile).
- Зум: lightbox через `<dialog>`, hover-зум — CSS `transform: scale()` (v0.14.0).
- Варианты: кнопки-пилюли (не dropdown) — все видны одновременно для 2–6 вариантов.
- Sticky bottom bar: bottom = mobile-bottom-nav height + safe-area, z-index 1025.
- Информационные секции: `aria-expanded` + `hidden`, JS toggle в v0.14.0.
- Юридические застереження: обязательны на каждой странице товара (Закон № 4122-IX).

**Зависимости v0.7.0 (все были готовы):**
```
layouts/layout-full-width.tpl        ✅ v0.5.0
_partials/breadcrumb.tpl             ✅ v0.5.1
_partials/notifications.tpl          ✅ v0.5.1
_partials/microdata/schema-product.tpl ✅ v0.4.0
_partials/microdata/schema-faq.tpl   ✅ v0.4.0
catalog/listing/_partials/rating-stars.tpl ✅ v0.6.0
catalog/listing/product-miniature.tpl ✅ v0.6.0
```

**Нюансы:**
- `product.description` и `product.description_short` выводятся через `nofilter` —
  BO может содержать HTML. Аналогично notifications.tpl и category.tpl.
- `rating-stars.tpl` переиспользуется из `catalog/listing/_partials/` — единый файл.
- `$product.features` используются для двух секций: «Спосіб застосування» (отдельная)
  и «Деталі та характеристики» (таблица). Дублирование исключено через фильтр по имени.
- Sticky bar `aria-hidden="true"` — дублирует основную кнопку, не должен мешать скринридерам.
- `<dialog>` lightbox: Esc закрывает нативно, backdrop через `::backdrop` (CSS).

---

## [0.6.1] — 2026-03-18 — theme.css: полный рефакторинг :root на OKLCH

### Изменено
- `assets/css/theme.css` — полностью переписана секция `00. CSS Variables` (`:root`).
  Все 18 секций ниже (`01. Reset & Base` … `19. Admin Bar fix`) — не тронуты.

  **Цветовая модель:** переход с HEX (`#FF5722`, `#212121`, `rgba()`) на OKLCH (CSS Color Level 4).
  Браузерная поддержка OKLCH на 2026 год: 97%+ (Chrome 111+, Firefox 113+, Safari 15.4+).

  **Корпоративные цвета G&G Vitamins UA:**
  - `#587459` → `oklch(47% 0.07 145)` — primary (тёмно-зелёный)
  - `#8CA68C` → `oklch(66% 0.07 145)` — primary-light (средне-зелёный)
  Все производные оттенки (dark, subtle, xsubtle) вычислены в том же hue 145 —
  гарантирует визуальное единство палитры.

  **Новые токены (отсутствовали ранее, нужны для category.css v0.6.0):**
  - `--color-card` — белый фон карточек (отдельно от `--color-surface`)
  - `--color-text-secondary` — вторичный текст, перечёркнутые цены
  - `--color-primary-subtle` — фон активных состояний, hover карточек
  - `--color-primary-xsubtle` — сверхлёгкий фон, benefits bar
  - `--color-border-hover` — hover-состояние рамок карточек
  - `--color-btn-cart`, `--color-btn-cart-hover`, `--color-btn-cart-text` — кнопка корзины
  - `--color-discount`, `--color-new`, `--color-sale`, `--color-rating` — функциональные цвета
  - `--color-discount-bg`, `--color-new-bg`, `--color-sale-bg` — фоны под функциональные бейджи
  - `--color-success/warning/error/info` + `-bg` пары — для notifications.tpl
  - `--font-size-*` шкала (xs → 2xl) — типографические токены
  - `--line-height-tight/base/relaxed` — токены межстрочия
  - `--radius-xl: 16px` — добавлен к существующим sm/base/lg/pill
  - `--header-height: 72px` — псевдоним, используется sticky offset каталога
  - `--font-base`, `--font-heading` — токены шрифтовых стеков

  **Изменены существующие токены:**
  - `--color-primary`: `#FF5722` → `oklch(47% 0.07 145)` (оранжевый → корпоративный зелёный)
  - `--color-primary-dark`: `#E64A19` → `oklch(35% 0.07 145)`
  - `--color-primary-light`: `#FFF3E0` → `oklch(66% 0.07 145)` (семантика изменена: было «светлый фон под orange», стало «средне-зелёный акцент»)
  - `--color-background`: `#F5F5F5` → `oklch(97% 0.008 145)` (чуть тёплый зеленоватый)
  - `--color-surface`: `#FFFFFF` → `oklch(99% 0.005 145)` (почти белый, лёгкий зелёный оттенок)
  - `--announcement-bg`: `#FF5722` → `oklch(47% 0.07 145)` (= primary)
  - `--top-bar-bg`: `#212121` → `oklch(22% 0.020 145)` (тёмный зелёный вместо нейтрального чёрного)
  - `--footer-bg`: `#1A1A1A` → `oklch(18% 0.015 145)` (не чёрный — тёмный зелёный)
  - `--subfooter-bg`: `#111111` → `oklch(13% 0.010 145)`
  - `--header-shadow`, `--nav-dropdown-shadow`, `--mobile-*-shadow`: `rgba()` → `oklch(/ alpha)`
  - `--color-link-hover`: `#FF5722` → `oklch(47% 0.07 145)` (= primary)

### Заметки
- **Правило `:root`:** ни одного `#hex` или `rgba()` внутри `:root` — только `oklch()`.
  Все тени и полупрозрачные значения: `oklch(L% C H / alpha)`.
- **Смена primary:** замена `#FF5722` (оранжевый) на корпоративный зелёный G&G
  затрагивает визуально header (announcement bar), footer (кнопки), benefits bar, кнопки форм.
  Все эти компоненты используют `var(--color-primary)` — перекраситься автоматически.
- **`--color-primary-light`** изменил семантику: было «светлый фон под оранжевый» (`#FFF3E0`),
  стало «средне-зелёный акцент» (`oklch(66% 0.07 145)`). Проверить все места использования
  в header.tpl, footer.tpl, theme.css секции 15–17 при следующем рефакторинге (v0.12.0).
- Типографическая шкала `--font-size-*` добавлена авансом под v0.7.0 (product.tpl).

---

## [0.6.0] — 2026-03-18 — Каталог: category.tpl, product-list.tpl, product-miniature.tpl + партиалы + category.css

> Исследования, обоснования, спецификации по каталогу вынесены в отдельный документ:
> **`CATALOG-0.6.0-recommendations.md`** — изучать перед правками любого файла каталога.

### Добавлено

**Основные шаблоны:**

- `templates/catalog/listing/category.tpl` — страница категории каталога.
  Extends `layout-full-width.tpl`. Структура (9 блоков):
  1. Хлебные крошки — `_partials/breadcrumb.tpl` (условие: `links|@count > 1`)
  2. Flash-уведомления — `_partials/notifications.tpl`
  3. JSON-LD — `{hook h='displaySchemaMarkup'}` → schema-category.tpl
  4. Category Hero — H1, `<details>/<summary>` описание, фото категории
  5. Плитки подкатегорий — если `$subcategories|@count > 0`
  6. Offcanvas фильтры — Bootstrap offcanvas, mobile/tablet (`d-lg-none`)
  7. Sticky Toolbar — фильтры (mobile) + сортировка + grid/list toggle + счётчик
  8. Catalog Layout — aside (ps_facetedsearch) + main (`#js-product-list`)
  9. Skeleton loader — `#js-catalog-loader`, скрыт через `hidden`

  **Ключевые решения:**
  - Описание категории в `<details>/<summary>` — текст в DOM (не `display:none`),
    Google и AI-агенты читают полный текст, пользователь видит свёрнутый вид.
  - `{assign var='has_left_column' value={hook h='displayLeftColumn'}}` — хук вызывается
    один раз, результат переиспользуется дважды. Двойного рендеринга фильтров нет.
  - `<meta name="robots" content="noindex, follow">` при `$listing.is_filtered` —
    предотвращает дублирование отфильтрованных страниц в индексе Google.
  - Offcanvas фильтров содержит тот же `{hook h='displayLeftColumn'}` что и aside —
    один источник правды для фильтров на всех breakpoint.

- `templates/catalog/listing/product-list.tpl` — сетка товаров.
  Подключается из category.tpl через `{include}`. Универсальный — пригоден для
  search.tpl, manufacturer.tpl и других листинговых страниц.

  Содержит:
  - Теги-пилюли активных фильтров — с кнопкой × и «Скинути всі». Расположены
    внутри AJAX-зоны (`#js-product-list`) — обновляются при каждой фильтрации.
  - Bootstrap row: `row row-cols-2 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-3 g-md-4`
  - `{foreach name='products_loop'}` — именованный цикл для доступа к `.index`
  - Передача `$is_above_fold` в product-miniature.tpl — первые 4 карточки `eager+high`
  - Два варианта пустого состояния — с фильтрами и без

  **Ключевое решение:** активные фильтры — внутри AJAX-зоны, а не в category.tpl снаружи.
  Перерисовываются при каждом AJAX-запросе автоматически.

- `templates/catalog/listing/product-miniature.tpl` — карточка товара в листинге.

  Структура: `<article>` (семантически верен) → media (фото + бейджи + wishlist) →
  body (рейтинг + название + артикул + цены + цена/единица) → footer (кнопка).

  **Реализованные детали:**
  - Бейджи: максимум 2, приоритет скидка→акция→новинка. `aria-hidden` + отдельный
    скрытый текст для скринридеров.
  - Wishlist через `{hook h='displayProductListFunctionalButtons' product=$product}`.
  - `<picture>` с `<source media="(max-width: 575px)">`:
    mobile → `home_default` (250×250), desktop → `medium_default` (452×452).
  - `aspect-ratio: 1/1` на обёртке фото → CLS = 0 (место резервируется до загрузки).
  - `object-fit: contain` + `padding: 8px` — упаковки БАДов не обрезаются.
  - `tabindex="-1"` на ссылке фото — фокус клавиатуры идёт сразу на название.
  - Рейтинг: 3 состояния (0 / 1–4 / 5+ отзывов). Нет пустых звёзд при 0 отзывах.
  - `$product.unit_price` — цена за единицу под ценой (если `unit_price_ratio > 0`).
  - Кнопка: 3 варианта — `out_of_stock` / `has_combinations` / простой товар.
  - `aria-label` кнопки содержит название товара — скринридер озвучивает что именно.

**Партиалы каталога:**

- `templates/catalog/listing/_partials/rating-stars.tpl` — переиспользуемые звёзды.
  Параметры: `$rating` (0–5, дробное), `$show_score` (bool), `$score` (число).
  Три состояния звезды: full / half-stroke / empty (regular).
  Порог полузвезды: `0.25` (честнее стандартного `0.5`).
  Нет собственного `aria-label` — его ставит вызывающий шаблон.
  Переиспользуется в product.tpl (v0.7.0).

- `templates/catalog/listing/_partials/empty-state.tpl` — пустой листинг.
  Два контекста: фильтры есть (показывает активные теги + кнопка сброса) /
  категория пуста (другой текст + CTA в каталог).
  В пустом состоянии с фильтрами показывает первые 3 активных тега +
  «+N» — пользователь видит что именно мешает найти товары (Baymard паттерн).
  `<p>` вместо `<h2>` — H1 занят названием категории.

- `templates/catalog/listing/_partials/products-top.tpl` — строка результатов
  внутри AJAX-зоны. Не дублирует Toolbar из category.tpl.
  Содержит: счётчик «Показано X–Y з Z» (с диапазоном страницы) +
  текущая сортировка (текстовый лейбл) + per-page переключатель (12/24/48).
  Per-page скрыт на mobile (`d-none d-md-flex`).
  Весь блок не рендерится если `$total_items == 0`.

**Стили:**

- `assets/css/pages/category.css` — полные стили каталога. 16 секций, ~600 строк.
  Подключается только на странице категории (контроллер `category`, priority 60).
  Охватывает все 6 шаблонов v0.6.0.

  **Ключевые CSS-решения:**
  - Все цвета через CSS-переменные из `:root` — никаких hex-литералов.
  - Тени и полупрозрачности: `oklch(L% C H / alpha)`.
  - `@media (prefers-reduced-motion: no-preference)` — все анимации внутри.
    Staggered fade-in: nth-child(1–5) задержки 0.05–0.25s, n+6 → 0.30s.
  - Wishlist desktop/touch разделены через `@media (hover: hover)` + `:focus-within`.
  - Skeleton shimmer: CSS-анимация без JS — `background: linear-gradient` + `animation`.
  - `#js-catalog-loader:not([hidden]) ~ #js-product-list { visibility: hidden }` —
    реальный список скрывается через CSS когда активен лоадер (без доп. JS).
  - List-режим карточки: горизонтальный layout через `.product-list--list .product-miniature`.
  - `@media print` — скрывает toolbar, фильтры, кнопки, печатает в 3 колонки.
  - ps_facetedsearch стили: `.faceted-search-block`, `.facet-label`, `.facet-count` и др.

### Заметки

**Принятые решения (финальные):**
- `layout-left-column` + aside 260px фильтров — обязательно для 300+ товаров.
- `ps_facetedsearch` — официальный модуль. Тема не знает о нём напрямую.
  Переопределение шаблонов модуля — v0.11.0.
- AJAX + History API — единственная правильная схема (SEO + кнопка Назад + прямые ссылки).
- Сравнение товаров (`ps_compareproducts`) — не добавлять.
- Рейтинг в карточке выводить сразу (3 состояния), не ждать отзывов.
- Сортировка по цене за единицу — v0.6.x (требует кастомный SortOrder).

**Зависимости v0.6.0 (все были готовы):**
```
_partials/breadcrumb.tpl         ✅ v0.5.1
_partials/notifications.tpl      ✅ v0.5.1
_partials/pagination.tpl         ✅ v0.5.1
microdata/schema-category.tpl    ✅ v0.4.0
layouts/layout-full-width.tpl    ✅ v0.5.0
```

**Нюансы:**
- `article` на карточке (не `div`) — семантически верен для самостоятельной единицы контента.
- `tabindex="-1"` на ссылке фото — устраняет «двойной фокус» клавиатуры (Baymard a11y).
- `{foreach name='products_loop'}` обязателен — только именованный цикл даёт `.index`.
- Wishlist-хук стилизуется через CSS-каскад `.product-miniature__wishlist .wishlist-button-add`
  без изменения шаблона модуля. Совместимо с переопределением в v0.11.0.

---

## [0.5.2] — 2026-03-17 — Партиалы: nav, form-errors

### Добавлено
- `templates/_partials/nav.tpl` — навигационная полоса через хуки PS9.
  Обрабатывает: `displayTop`, `displayNav1`, `displayNav2`, `displayNavFullWidth`.
  Каждый хук проверяется через `{assign}` — пустые обёртки не генерируются.
  В `layout-full-width.tpl` **не подключается** (хуки уже в header.tpl).
  Зарезервирован для `layout-checkout.tpl` (v0.8.0).
- `templates/_partials/form-errors.tpl` — ошибки валидации форм.
  Два режима: сводный `alert-danger` над формой (`$errors`) и inline под полем (`$field`).
  `id="form-errors-summary"` + `tabindex="-1"` — для `focus()` в checkout.js (v0.14.0).
  `role="alert"` + `aria-live="assertive"` — скринридер озвучивает немедленно.

### Заметки
- `nav.tpl` не вызывается из layout-full-width.tpl — дублирование хуков с header.tpl.
- `$error_msg` экранируется через `escape:'html':'UTF-8'` — PS9 передаёт plain text.
- `id="form-errors-summary"` — не переименовывать без правки checkout.js.

---

## [0.5.1] — 2026-03-17 — Партиалы: breadcrumb, notifications, pagination

### Добавлено
- `templates/_partials/breadcrumb.tpl` — хлебные крошки.
  Bootstrap `.breadcrumb` + microdata `itemscope/itemprop`. JSON-LD не дублирует (уже в head.tpl).
  Последний элемент — `<span aria-current="page">`. Условие подключения: `pages|@count > 1`.
- `templates/_partials/notifications.tpl` — flash-сообщения 4 типов.
  Маппинг тип→Bootstrap alert через единый `{assign var='notif_map'}`.
  `$message` без `escape` — PS9 передаёт HTML со ссылками.
  Закрытие через `data-bs-dismiss="alert"` без JS.
- `templates/_partials/pagination.tpl` — пагинация каталога.
  `prev_url`/`next_url` из `$pagination.pages`. Разделители `aria-hidden="true"`.
  `rel="prev"`/`rel="next"` для SEO. `{if pages_count > 1}` — не рендерится на 1 странице.

### Заметки
- breadcrumb.tpl не содержит JSON-LD — дублировать schema-breadcrumb.tpl нельзя.
- pagination.tpl подключён в category.tpl (v0.6.0) ✅.

---

## [0.5.0] — 2026-03-17 — Главная страница: index.tpl, layout, displayHome

### Добавлено
- `templates/layouts/layout-full-width.tpl` — базовый layout для всей темы.
  5 переопределяемых блоков: `content`, `head_extra`, `body_attrs`, `before_header`, `after_footer`.
  Хуки: `displayAfterBodyOpeningTag`, `displayContentWrapperTop/Bottom`, `displayBeforeBodyClosingTag`.
- `templates/_partials/hooks/displayHome.tpl` — обёртка хука `displayHome`.
- `templates/index.tpl` — главная страница. 5 секций:
  Hero (статичный, единственный h1) → USP Bar (4 преимущества) →
  Hook Modules (displayHome) → About (SEO-текст) → FAQ (Bootstrap аккордеон + JSON-LD FAQPage).

### Заметки
- Hero — статичный HTML (не ps_imageslider). Быстрее, лучше LCP, выше конверсия.
- FAQ — Вариант A (assign). `{l}` не работает внутри `{assign value=[...]}` — ограничение Smarty.
- `h1` в Hero — fallback `$shop.name`. Заменить перед production.

---

## [0.4.0] — 2026-03-17 — Микроразметка JSON-LD

### Добавлено
- `schema-organization.tpl` — `Organization + WebSite + SearchAction`
- `schema-breadcrumb.tpl` — `BreadcrumbList`
- `schema-product.tpl` — `Product + Offer + AggregateRating`
- `schema-category.tpl` — `ItemList` (URL-only, Carousel закомментирован)
- `schema-article.tpl` — `WebPage` или `Article`
- `schema-faq.tpl` — `FAQPage`

### Исправлено
- `schema-article.tpl` — порядок модификаторов: было `escape|truncate`, стало `truncate|escape`.

### Заметки
- `schema-sitelinks.tpl` — не нужен. SearchAction в schema-organization.tpl.
- Запятые в JSON + Smarty: используется паттерн «ведущей запятой» внутри `{if}`.
- PHP 8.4 даты: `|truncate:10:''` вместо deprecated `date_format:'%Y-%m-%d'`.
- Порядок модификаторов в JSON-LD: `strip_tags → trim → truncate → escape` — строго.

---

## [0.3.2] — 2026-03-16 — theme.css, theme.js

### Добавлено
- `assets/css/theme.css` — глобальные стили, 19 секций.
  CSS Variables (hex, v0.3.2 — заменены на OKLCH в v0.6.1).
- `assets/js/theme.js` — 6 Vanilla JS модулей.

---

## [0.3.1] — 2026-03-16 — header.tpl, footer.tpl

### Добавлено
- `templates/_partials/header.tpl` — 11 секций (announcement bar → offcanvas wishlist).
- `templates/_partials/footer.tpl` — benefits bar + 4 колонки + subfooter.

---

## [0.3.0] — 2026-03-16 — head.tpl

### Добавлено
- `templates/_partials/head.tpl` — полная реализация.
  Meta charset/viewport, canonical, hreflang, Open Graph, Twitter Card,
  preconnect/preload, CSS assets, favicon, JSON-LD хуки.

### Заметки
- OG image: product→cover, category→large, остальные→`og-default.jpg` (1200×630).
- Hreflang обёрнут в `{if $urls.alternative_langs|@count > 1}`.
- JS в `<head>` исключён — только `defer` + `position: bottom`.

---

## [0.2.1] — 2026-03-16 — theme.yml патч: wishlist + FA7

### Изменено
- `config/theme.yml` — blockwishlist включён. FA7 разделён на 3 отдельных CSS файла.

---

## [0.2.0] — 2026-03-16 — theme.yml финальная версия

### Добавлено
- `config/theme.yml` — полная конфигурация.
  `PS_QUICK_VIEW: 0`, `PS_PRODUCTS_PER_PAGE: 24`, `PS_GRID_PRODUCT_DEFAULT: 1`,
  `PS_SEARCH_AJAX: 1`. Кастомный хук `displaySchemaMarkup` зарегистрирован.
  4 layout: full-width, left-column, right-column, both-columns.

---

## [0.1.0] — 2026-03-16 — Архитектура проекта

### Добавлено
- `PROJECT.md` — главный контекстный файл проекта
- `CHANGELOG.md` — этот файл
- Полная структура папок темы спроектирована
- Список модулей определён
- Стратегия микроразметки принята

### Заметки
- Тема независимая, без наследования от Hummingbird
- Микроразметка: только JSON-LD
- JS: Vanilla JS, без jQuery, `defer`
- CSS: без SCSS, Bootstrap 5, BEM

---

## ШАБЛОН ДЛЯ НОВОЙ ЗАПИСИ

```
## [X.X.X] — ГГГГ-ММ-ДД — Короткое название

### Добавлено
- `путь/к/файлу.tpl` — что делает

### Изменено
- `путь/к/файлу.tpl` — что изменилось и почему

### Исправлено
- `путь/к/файлу.tpl` — описание бага и фикса

### Удалено
- `путь/к/файлу.tpl` — причина удаления

### Заметки
- Важные решения, договорённости, нюансы для будущего
```

---

## ПЛАН ВЕРСИЙ

| Версия | Содержание | Статус |
|---|---|---|
| `0.1.0` | Архитектура, PROJECT.md, CHANGELOG.md | ✅ |
| `0.2.0` | `theme.yml` финальная версия | ✅ |
| `0.2.1` | `theme.yml`: wishlist включён, FA7 раздельные CSS | ✅ |
| `0.3.0` | `head.tpl` | ✅ |
| `0.3.1` | `header.tpl`, `footer.tpl` | ✅ |
| `0.3.2` | `theme.css`, `theme.js` | ✅ |
| `0.4.0` | Вся микроразметка `_partials/microdata/` (6 файлов) | ✅ |
| `0.5.0` | Главная страница `index.tpl` + layout + displayHome.tpl | ✅ |
| `0.5.1` | Партиалы: breadcrumb, notifications, pagination | ✅ |
| `0.5.2` | Партиалы: nav, form-errors | ✅ |
| `0.6.0` | Каталог: 3 шаблона + 3 партиала + category.css | ✅ |
| `0.6.1` | `theme.css`: рефакторинг `:root` на OKLCH | ✅ |
| `0.7.0` | Карточка товара `product.tpl` + партиалы | ⬜ |
| `0.8.0` | Корзина и оформление заказа `checkout/` | ⬜ |
| `0.9.0` | Личный кабинет `customer/` | ⬜ |
| `0.10.0` | CMS страницы + ошибки | ⬜ |
| `0.11.0` | Переопределения модулей `modules/` | ⬜ |
| `0.12.0` | Глобальные стили `theme.css` (доработка) | ⬜ |
| `0.13.0` | Глобальный JS `theme.js` (доработка) | ⬜ |
| `0.14.0` | Страничные CSS и JS (`pages/`) | ⬜ |
| `0.15.0` | SEO модуль + финальная проверка микроразметки | ⬜ |
| `1.0.0` | Тема готова к production | ⬜ |
