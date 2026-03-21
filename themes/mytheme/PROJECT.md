# MyShop — PrestaShop 9.0 Custom Theme Project
> Последнее обновление: Сессия 7 — Карточка товара v0.7.2 (CSS/JS) + Установка темы v0.7.1

---

## СТЕК И ОКРУЖЕНИЕ

| Параметр | Значение |
|---|---|
| CMS | PrestaShop 9.0.3 |
| PHP | 8.4.x |
| Шаблонизатор | Smarty |
| CSS фреймворк | Bootstrap 5.3.8 |
| Цветовая модель | OKLCH (CSS Color Level 4) |
| JS | Vanilla JS (без jQuery, без TypeScript) |
| CSS препроцессор | Нет (без SCSS) |
| Иконки | Font Awesome Free 7.2.0 (хостится локально) |
| Тема | mytheme (независимая, без наследования от Hummingbird) |
| Микроразметка | JSON-LD (только, без микроатрибутов в HTML) |

---

## КЛЮЧЕВЫЕ РЕШЕНИЯ (принятые раз и навсегда)

- **Hummingbird НЕ используется как родитель** — только как справочник. Полная независимость темы.
- **Микроразметка — только JSON-LD** — вынесена в отдельные .tpl файлы, не смешивается с HTML.
- **JS подключается с атрибутом `defer`** — все скрипты, position: bottom.
- **CSS разделён на глобальный и страничный** — страничный CSS грузится только на нужном контроллере.
- **Font Awesome 7 — локально**, не через CDN. Только 3 CSS файла: `fontawesome.min.css`, `solid.min.css`, `brands.min.css`. Файл `all.min.css` — не использовать.
- **BEM-именование** для кастомных CSS-классов.
- **Переопределения модулей — только через `themes/mytheme/modules/`**, сами модули не трогаем.
- **Кастомный хук `displaySchemaMarkup`** зарегистрирован в theme.yml для страничных JSON-LD схем.
- **Тема проектируется как база** для сборки других магазинов. Переопределение под новый магазин — только секция CSS Variables в `theme.css` (`:root`).
- **Мобильная навигация** — паттерн Foxtrot: fixed top bar (поиск + связаться) + fixed bottom nav bar (5 иконок). Всё остальное — offcanvas и модальные окна.
- **blockwishlist включён** — список желаний нужен (подтверждено опросом пользователей).
- **Smarty модификаторы в JSON-LD** — порядок всегда: `strip_tags → trim → truncate → escape:'javascript'`. escape — строго последний.
- **Layout-система** — базовый `layouts/layout-full-width.tpl`, все страницы наследуют через `{extends}`.
- **Hero на главной — статичный HTML** в `index.tpl`, не модуль `ps_imageslider`.
- **FAQ на главной — статичный assign** (Вариант A) для моноязычного. Для мультиязычного — Вариант B (модуль).
- **Цветовая модель — OKLCH** (CSS Color Level 4). Браузерная поддержка 97%+ на 2026 год. HEX и `rgba()` в `:root` не использовать.
- **PS_QUICK_VIEW: 0** — быстрый просмотр отключён (прописан в theme.yml).
- **ps_compareproducts** — не используем (решение принято в рамках v0.6.0).
- **ps_facetedsearch** — официальный модуль фильтров. Тема не знает о модуле напрямую — только через хук `displayLeftColumn`.
- **AJAX-фильтрация** — AJAX + History API + graceful degradation. Зона обновления: `#js-product-list`.

---

## СТРУКТУРА ТЕМЫ (актуальная)

```
prestashop/
├── PROJECT.md                               ← Этот файл (контекст проекта)
├── CHANGELOG.md                             ← История изменений
├── CATALOG-0.6.0-recommendations.md        ← Исследования и рекомендации по каталогу ⭐
└── themes/
    └── mytheme/
        ├── config/
        │   └── theme.yml                   ✅ v0.2.1
        ├── templates/
        │   ├── layouts/
        │   │   └── layout-full-width.tpl   ✅ v0.5.0
        │   ├── _partials/
        │   │   ├── head.tpl                ✅ v0.3.0
        │   │   ├── header.tpl              ✅ v0.3.1
        │   │   ├── footer.tpl              ✅ v0.3.1
        │   │   ├── nav.tpl                 ✅ v0.5.2
        │   │   ├── breadcrumb.tpl          ✅ v0.5.1
        │   │   ├── pagination.tpl          ✅ v0.5.1
        │   │   ├── form-errors.tpl         ✅ v0.5.2
        │   │   ├── notifications.tpl       ✅ v0.5.1
        │   │   ├── microdata/
        │   │   │   ├── schema-organization.tpl  ✅ v0.4.0
        │   │   │   ├── schema-breadcrumb.tpl    ✅ v0.4.0
        │   │   │   ├── schema-product.tpl       ✅ v0.4.0
        │   │   │   ├── schema-category.tpl      ✅ v0.4.0
        │   │   │   ├── schema-article.tpl       ✅ v0.4.0
        │   │   │   └── schema-faq.tpl           ✅ v0.4.0
        │   │   └── hooks/
        │   │       └── displayHome.tpl          ✅ v0.5.0
        │   ├── catalog/
        │   │   ├── product.tpl                  ✅ v0.7.0
        │   │   ├── listing/
        │   │   │   ├── category.tpl             ✅ v0.6.0
        │   │   │   ├── product-list.tpl         ✅ v0.6.0
        │   │   │   ├── product-miniature.tpl    ✅ v0.6.0
        │   │   │   └── _partials/
        │   │   │       ├── rating-stars.tpl     ✅ v0.6.0
        │   │   │       ├── empty-state.tpl      ✅ v0.6.0
        │   │   │       └── products-top.tpl     ✅ v0.6.0
        │   │   └── _partials/
        │   │       ├── product-prices.tpl       ✅ v0.7.0
        │   │       ├── product-images.tpl       ✅ v0.7.0
        │   │       ├── product-variants.tpl     ✅ v0.7.0
        │   │       └── product-add-to-cart.tpl  ✅ v0.7.0
        │   ├── checkout/
        │   │   ├── checkout.tpl                 ✅ v0.7.1 (stub)
        │   │   ├── cart.tpl                     ✅ v0.7.1 (stub)
        │   │   └── order-confirmation.tpl       ✅ v0.7.1 (stub)
        │   ├── customer/                        ✅ v0.7.1 (stubs)
        │   ├── cms/                             ✅ v0.7.1 (stubs)
        │   ├── errors/                          ✅ v0.7.1 (stubs)
        │   └── index.tpl                        ✅ v0.5.0
        ├── assets/
        │   ├── css/
        │   │   ├── bootstrap.min.css            ✅
        │   │   ├── fontawesome.min.css          ✅
        │   │   ├── solid.min.css                ✅
        │   │   ├── brands.min.css               ✅
        │   │   ├── theme.css                    ✅ v0.6.1 (OKLCH рефакторинг :root)
        │   │   └── pages/
        │   │       ├── category.css             ✅ v0.6.0
        │   │       ├── product.css              ✅ v0.7.2
        │   │       ├── checkout.css             ✅ v0.7.1 (stub)
        │   │       └── home.css                 ✅ v0.7.1 (stub)
        │   ├── js/
        │   │   ├── bootstrap.bundle.min.js      ✅
        │   │   ├── theme.js                     ✅ v0.3.2
        │   │   └── pages/
        │   │       ├── category.js              ⬜ v0.14.0
        │   │       ├── product.js               ✅ v0.7.2
        │   │       ├── cart.js                  ✅ v0.7.1 (stub)
        │   │       └── checkout.js              ✅ v0.7.1 (stub)
        │   ├── img/
        │   │   ├── logo.svg                     ⚠️ создать вручную
        │   │   ├── og-default.png               ✅ создан (1200×630 px)
        │   │   ├── hero-bg.webp                 ⚠️ создать вручную
        │   │   └── about-home.webp              ⚠️ создать вручную (780×585 px)
        │   └── fonts/
        │       ├── fa-solid-900.woff2           ✅
        │       ├── fa-brands-400.woff2          ✅
        │       └── fa-regular-400.woff2         ✅
        └── modules/                             ⬜ v0.11.0
            ├── ps_mainmenu/
            ├── ps_searchbar/
            ├── ps_shoppingcart/
            ├── blockwishlist/
            ├── ps_categoryproducts/
            └── ps_facetedsearch/               ← переопределение шаблонов фильтров
```

---

## КАТАЛОГ v0.6.0 — КЛЮЧЕВЫЕ РЕШЕНИЯ

> Полная документация с обоснованиями, исследованиями и спецификациями:
> **`CATALOG-0.6.0-recommendations.md`** — отдельный файл, изучать перед правками каталога.

### Архитектурные решения

| Вопрос | Решение | Обоснование |
|---|---|---|
| Layout | `layout-left-column` + aside фильтры | 300+ товаров — фильтры обязательны (Baymard, 2025) |
| Grid/List toggle | Оба режима, по умолчанию Grid | 78% предпочитают Grid, 41% переключаются в List (Forrester, 2024) |
| Фон фото товаров | Белый `#fff`, `object-fit: contain` | Google Merchant Center + не обрезает упаковки БАДов |
| Колонки mobile | 2 колонки | +23% конверсии vs 1 колонка для товаров с упаковкой (Baymard, 2025) |
| Фильтры mobile | Bootstrap Offcanvas drawer | Не модальное окно — drawer не перекрывает контент |
| Модуль фильтров | `ps_facetedsearch` | Официальный, совместим PS 9.0, слабая связь через хук |
| AJAX-фильтрация | AJAX + History API + fallback | SEO (pushState), кнопка «Назад», прямые ссылки |
| Рейтинг в карточке | 3 состояния сразу | Пустые звёзды при 0 отзывов −15% конверсии (Baymard, 2024) |
| Подкатегории | Плитки между Hero и Toolbar | Навигация вглубь до листинга — стандартный паттерн |
| Сравнение товаров | Не реализуем | Решение принято — не добавлять |
| Цена за единицу | Отображение в карточке | Сортировка — в v0.6.x (требует кастомный SortOrder) |

### Сетка Bootstrap

```
Mobile  <768px    row-cols-2           2 колонки
Tablet  768–991px row-cols-md-2        2 колонки (фильтры в offcanvas)
Desktop ≥992px    row-cols-lg-3        3 колонки (с aside 260px)
Wide    ≥1200px   row-cols-xl-4        4 колонки
```

### AJAX-зона обновления

Только `<section id="js-product-list">` перерисовывается при фильтрации.
Остальная страница (header, breadcrumb, toolbar, aside) не трогается.

### Страницы с фильтрами — SEO

```smarty
{if isset($listing.is_filtered) && $listing.is_filtered}
  <meta name="robots" content="noindex, follow">
{/if}
```

Отфильтрованные URL не индексируются — предотвращает дублирование контента.

---

## ЦВЕТОВАЯ СИСТЕМА — OKLCH

> Полный рефакторинг `:root` выполнен в v0.6.1.
> Корпоративные цвета G&G Vitamins UA:

| Токен | OKLCH | HEX-эквивалент | Назначение |
|---|---|---|---|
| `--color-primary` | `oklch(47% 0.07 145)` | `#587459` | Кнопки, активные элементы |
| `--color-primary-light` | `oklch(66% 0.07 145)` | `#8CA68C` | Hover, иконки, бордеры |
| `--color-primary-dark` | `oklch(35% 0.07 145)` | — | Hover на кнопках |
| `--color-primary-subtle` | `oklch(95% 0.025 145)` | — | Фон активных состояний |
| `--color-card` | `oklch(100% 0 0)` | `#FFFFFF` | Фон карточек |
| `--color-surface` | `oklch(99% 0.005 145)` | — | Фон страницы |
| `--color-discount` | `oklch(55% 0.20 25)` | — | Бейдж скидки, скидочная цена |
| `--color-rating` | `oklch(76% 0.18 85)` | — | Золотые звёзды |

**Правило:** ни одного `#hex` или `rgba()` внутри `:root` — только `oklch()`.
Все тени и полупрозрачные значения: `oklch(L% C H / alpha)`.

---

## FONT AWESOME 7.2.0 — СТРАТЕГИЯ ПОДКЛЮЧЕНИЯ

| Файл | Приоритет в theme.yml | Назначение |
|---|---|---|
| `bootstrap.min.css` | 5 | Bootstrap |
| `fontawesome.min.css` | 6 | FA7 ядро |
| `solid.min.css` | 7 | Solid иконки (fas) |
| `brands.min.css` | 8 | Брендовые иконки (fab) |
| `theme.css` | 50 | Глобальные стили |
| `pages/category.css` | 60 | Каталог (контроллер: category) |

**НЕ использовать:** `all.min.css`, `all.js`, v4/v5 шимы.

Preload: `fa-solid-900.woff2` — eager (виден сразу). `fa-brands-400.woff2` — без preload (только footer).

---

## HEADER — АРХИТЕКТУРА

### Структура (11 секций в header.tpl)

| Секция | Элемент | Видимость |
|---|---|---|
| 1 | Announcement Bar | Все устройства |
| 2 | Top Bar (язык, валюта) | Только desktop |
| 3 | Main Header (лого, поиск, иконки) | Только desktop |
| 4 | Desktop Navigation | Только desktop |
| 5 | Mobile Top Bar (поиск + «Зв'язатися») | Mobile/tablet |
| 6 | Mobile Bottom Nav Bar (5 иконок) | Mobile/tablet |
| 7 | Offcanvas: мобильное меню | Все |
| 8 | Offcanvas: «Зв'язатися» | Все |
| 9 | Offcanvas: Mini-Cart | Все |
| 10 | Offcanvas: Mini-Wishlist | Все |
| 11 | Bootstrap backdrop | Автоматически |

### Mobile Bottom Nav Bar — состав (5 иконок)
```
[ 🏠 Головна ] [ 🗂 Каталог ] [ 🛒 Кошик ] [ ❤️ Обране ] [ ☰ Меню ]
```
Активная иконка при нахождении на странице категории: «Каталог».

### Smart Sticky поведение
- Скролл вниз 40px → Announcement bar скрывается
- Скролл вниз 80px → Шапка уезжает (`transform: translateY(-100%)`)
- Скролл вверх → Шапка возвращается целиком
- scrollY = 0 → Полный сброс состояния

---

## FOOTER — АРХИТЕКТУРА

**1. Benefits Bar** — 5 преимуществ. Mobile: горизонтальный скролл.

**2. Footer Main** — 4 колонки:
- Колонка 1: Лого + описание + соцсети
- Колонка 2: «Покупцям» — CMS ссылки — аккордеон mobile
- Колонка 3: «Компанія» — ссылки — аккордеон mobile
- Колонка 4: Підписка (ps_emailsubscription)

**3. Subfooter** — copyright + иконки оплаты + правовые ссылки.

Аккордеон mobile — Bootstrap Collapse без кастомного JS.

---

## INDEX.TPL — АРХИТЕКТУРА ГЛАВНОЙ СТРАНИЦЫ

| № | Секция | Реализация |
|---|---|---|
| 1 | Hero | Статичный HTML, единственный h1, два CTA |
| 2 | USP Bar | 4 преимущества, FA7-иконки |
| 3 | Hook Modules | `displayHome.tpl` → категории, featured, баннер |
| 4 | About | SEO-текст, 2 колонки, lazy-img |
| 5 | FAQ | Bootstrap аккордеон + JSON-LD FAQPage |

Hero — статичный HTML (не ps_imageslider). Статика: лучше LCP, выше конверсия.
FAQ — Вариант A (assign) для моноязычного. Для мультиязычного — Вариант B (модуль).

---

## LAYOUT-СИСТЕМА

**Базовый файл:** `templates/layouts/layout-full-width.tpl`

| Блок | Назначение |
|---|---|
| `content` | Основной контент (обязателен) |
| `head_extra` | Доп. теги в `<head>` (per-page meta, noindex) |
| `body_attrs` | Доп. атрибуты `<body>` |
| `before_header` | Зона перед header |
| `after_footer` | Модальные окна уровня страницы |

---

## THEME.JS — МОДУЛИ

| Модуль | Назначение |
|---|---|
| `SmartSticky` | Умная шапка: IntersectionObserver + scroll direction |
| `CartOffcanvasMode` | Переключение mini-cart: bottom (mobile) / end (desktop) |
| `CartBadgeSync` | Синхронизация счётчика корзины (слушает `updateCart` PS) |
| `MobileNavSpacer` | Динамическая высота spacer через `getBoundingClientRect()` |
| `FooterAccordion` | Accordion поведение footer |
| `SearchBarEnhance` | Кнопка ×, автофокус, MutationObserver |

---

## THEME.CSS — ПЕРЕМЕННЫЕ ДЛЯ ПЕРЕОПРЕДЕЛЕНИЯ

При настройке под новый магазин менять только эти токены в `:root`:

```css
/* Корпоративные цвета */
--color-primary:        oklch(47% 0.07 145);   /* основной бренд-цвет */
--color-primary-light:  oklch(66% 0.07 145);   /* акцентный */

/* Высоты фиксированных элементов (связаны с JS) */
--mobile-bottom-nav-height:  60px;   /* ⚠️ связана со spacer */
--mobile-top-bar-height:     56px;   /* ⚠️ body padding-top mobile */
--announcement-height:       40px;
--header-height:             72px;   /* ⚠️ используется sticky offset каталога */
```

**⚠️ Правила:**
- `--mobile-bottom-nav-height` → используется и в nav bar и в spacer — менять только переменную.
- `--header-height` → используется в `catalog-toolbar: sticky` offset и sticky aside каталога.
- Ни одного `#hex` внутри `:root` — только `oklch()`.

---

## МИКРОРАЗМЕТКА — СТРАТЕГИЯ

| Страница | Файл схемы | Тип schema.org | Статус |
|---|---|---|---|
| Все страницы (head) | schema-organization.tpl | `Organization + WebSite + SearchAction` | ✅ |
| Все страницы | schema-breadcrumb.tpl | `BreadcrumbList` | ✅ |
| Карточка товара | schema-product.tpl | `Product + Offer + AggregateRating` | ✅ |
| Страница категории | schema-category.tpl | `ItemList` | ✅ |
| CMS страница | schema-article.tpl | `WebPage` или `Article` | ✅ |
| FAQ блок | schema-faq.tpl | `FAQPage` | ✅ |
| Подтверждение заказа | inline Order | `Order` | ⬜ v0.8.0 |

Страничные схемы подключаются через `{hook h='displaySchemaMarkup'}`.
`schema-sitelinks.tpl` не нужен — SearchAction в schema-organization.tpl.

### Правило порядка модификаторов в JSON-LD
```smarty
{* ПРАВИЛЬНО — escape всегда последний: *}
{$var|strip_tags|trim|truncate:5000:''|escape:'javascript'}
```

---

## МОДУЛИ

### Встроенные PS9
`ps_shoppingcart`, `ps_searchbar`, `ps_featuredproducts`, `ps_emailsubscription`,
`ps_languageselector`, `ps_currencyselector`, `ps_socialfollow`,
`ps_productcomments` (**критически важен** — без него нет AggregateRating),
`psgdpr`, `ps_facetedsearch` (**каталог — фильтры**).

### Сторонние
- `blockwishlist` ✅ — список желаний включён
- SEO модуль — Yoast SEO for PrestaShop или аналог ⬜
- Google Tag Manager community module ⬜

### Переопределения в modules/ (v0.11.0)
`ps_mainmenu`, `ps_searchbar`, `ps_shoppingcart`, `blockwishlist`,
`ps_categoryproducts`, `ps_featuredproducts`,
`ps_facetedsearch` (шаблоны фильтров под дизайн темы).

---

## ИЗВЕСТНЫЕ НЮАНСЫ И РЕШЕНИЯ

| Проблема | Решение |
|---|---|
| AdminBar PS9 перекрывается Bootstrap | `z-index: 9999` на `#admin-bar-container` (theme.css) |
| AggregateRating без отзывов ломает JSON-LD | `{if $product.comment_count > 0}` в schema-product.tpl |
| Страничный CSS не грузится на других страницах | Прописывать в theme.yml с указанием контроллера |
| Bootstrap не поддерживает responsive placement offcanvas | Mini-cart: геометрия через CSS media query, JS только меняет класс |
| `$shop.telegram / viber / whatsapp` — нет в PS9 | Хардкод в header.tpl, в 0.11.0 — кастомный модуль конфигурации |
| Footer логотип цветной, фон тёмный | `filter: brightness(0) invert(1)` на `.footer-col__logo-img` |
| CMS id в footer — заглушки | Заменить на реальные id после создания CMS страниц в BO |
| `blockwishlist` — не входит в стандартный PS9 | Устанавливать отдельно из Marketplace / GitHub |
| `$urls.pages.wishlist` — недоступен без модуля | `\|default:'#'` в footer.tpl и header.tpl |
| Mobile spacer может не совпасть с nav bar | `MobileNavSpacer` JS пересчитывает через `getBoundingClientRect()` |
| Safe area iPhone (notch) | `env(safe-area-inset-bottom)` в nav bar, spacer, offcanvas footer |
| Hreflang на моноязычном магазине | `{if $urls.alternative_langs|@count > 1}` в head.tpl |
| `date_format:'%Y-%m-%d'` deprecated PHP 8.4 | `\|truncate:10:''` в schema-article.tpl → валидный ISO 8601 |
| `escape:'javascript'` до `truncate` ломает JSON | Порядок: `strip_tags → trim → truncate → escape`. Исправлено в v0.4.0 |
| `{l}` не работает внутри `{assign value=[...]}` | Ограничение Smarty. Для мультиязычного FAQ — Вариант B (модуль) |
| Hero: `$shop.name` как h1 — только fallback | Заменить на реальный ключевой запрос перед production |
| `about-home.webp` и `hero-bg.webp` — заглушки | Создать вручную: hero 1920×900 px, about 780×585 px |
| Страницы с фильтрами дублируют контент в индексе | `<meta name="robots" content="noindex, follow">` при `$listing.is_filtered` |
| Отфильтрованные URL в AJAX не попадают в историю | AJAX + `history.pushState` + `popstate` handler (category.js v0.14.0) |
| Пустые звёзды при 0 отзывов снижают конверсию | 3 состояния рейтинга: 0 → ссылка, 1–4 → звёзды без балла, 5+ → полный |
| `object-fit: cover` обрезает упаковки БАДов | `object-fit: contain` + padding 8px на фото товара |
| Сортировка по цене за единицу — нет в PS9 | v0.6.0: только отображение. Сортировка — v0.6.x (кастомный SortOrder) |

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
| `0.6.0` | Каталог: category.tpl + product-list.tpl + product-miniature.tpl + 3 партиала + category.css | ✅ |
| `0.6.1` | `theme.css`: полный рефакторинг `:root` на OKLCH | ✅ |
| `0.7.0` | Карточка товара `product.tpl` + партиалы | ✅ |
| `0.7.1` | Минимальные файлы-заглушки (stubs) для установки PS9 + фикс `theme.yml` | ✅ |
| `0.7.2` | Карточка товара: стили `product.css` и скрипты `product.js` | ✅ |
| `0.8.0` | Корзина и оформление заказа `checkout/` (полная реализация) | ⬜ |
| `0.10.0` | CMS страницы + ошибки | ⬜ |
| `0.11.0` | Переопределения модулей `modules/` | ⬜ |
| `0.12.0` | Глобальные стили `theme.css` (доработка) | ⬜ |
| `0.13.0` | Глобальный JS `theme.js` (доработка) | ⬜ |
| `0.14.0` | Страничные CSS и JS (`pages/`) | ⬜ |
| `0.15.0` | SEO модуль + финальная проверка микроразметки | ⬜ |
| `1.0.0` | Тема готова к production | ⬜ |
