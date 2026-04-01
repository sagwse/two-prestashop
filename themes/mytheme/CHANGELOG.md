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

## [0.7.4] — 2026-03-28 — Header refactor: мега-меню + mobile drawer + search CSS

### Добавлено
- `templates/_partials/mega-menu.tpl` — десктопный `<ul class="nav-list">` с двумя мегаменю
  (Catalog: 5 колонок + SOOV-баннер; For What: 6 направлений), FA7, {l} переводы.
- `templates/_partials/mobile-menu.tpl` — мобильный drawer-accordion:
  5 секций (Vitamins / Minerals / Supplements / Special / Popular) + утилиты + lang + auth.
- `assets/css/theme.css` — добавлены недостающие стили:
  - `.search-widget` (десктоп: `.search-widget__inner`, `__icon`, `__input`) — BEM поверх ps_searchbar.
  - `.search-dropdown` + все дочерние элементы (`__item`, `__img`, `__name`, `__price`,
    `__footer`, `__empty`) — выпадающий список результатов из `ps_searchbar.tpl`.

### Изменено
- `templates/_partials/header.tpl` — полный рефакторинг из `prototype/header.tpl`:
  Новая структура (8 секций): Announcement → Top Bar → Main Header → Site Nav →
  Mobile Top Bar → Mobile Bottom Nav → Mobile Drawer → 3 Offcanvas (Cart/Wishlist/Contact).
  - Замены HTML → Smarty: `{$urls.*}`, `{$shop.logo}`, `{$shop.phone}`, `{$shop.baseline}`.
  - Мобильное меню: кастомный JS drawer (`mobile-drawer`) вместо Bootstrap offcanvas.
  - Брейкпоинты: `d-none d-md-flex` (desktop) / `d-md-none` (mobile).
  - `{include file='_partials/mega-menu.tpl'}` и `{include file='_partials/mobile-menu.tpl'}`.
  - Offcanvas Contact: Telegram/Viber/WhatsApp обёрнуты в `{if $shop.XXX|default:''}`.

### Заметки
- `{url entity='category' id=2}` — id=2 стандартный корень каталога PS; проверить в BO.
- `$shop.telegram / $shop.viber / $shop.whatsapp` — кастомные поля; если не заданы — каналы не рендерятся.
- `{$urls.theme_assets}img/soov-award.png` — нужно положить файл в `assets/img/`.
- `$shop.baseline` — проверить доступность поля в PS9.



## [0.7.3] — 2026-03-21 — Поиск: фикс отображения + Top Bar

### Исправлено

- `templates/_partials/header.tpl` — устранены дублирующие хуки отображения поля поиска.
  Поле поиска теперь выводится только в одном корректном месте (рядом с иконками в Main Header).
- `assets/css/theme.css` — поле «Вход для покупателя» в Top Bar скрыто через `display: none`.
  Причина: элемент дублировался — верное место отображения уже есть рядом с полем поиска.

### Заметки
- Правки выполнены напрямую в файлах темы (не через BO). Зафиксированы в этой версии.

---

## [0.6.2] — 2026-03-20 — Документация: обновление CATALOG + PRODUCT рекомендаций

> Тема установлена, ведётся работа с каталогом и карточкой товара.
> Этот релиз — документационный: обновлены два файла рекомендаций.
> Файлы шаблонов — не изменялись.

### Изменено

- `CATALOG-0.6.0-recommendations.md` — дополнен разделами:
  - **Раздел 5** — Структура категорий PS9 (маппинг из `ps9_categories.md`):
    полная иерархия 4 основных категорий + 5 подразделов «Популярне»,
    принцип ассоциаций товаров (многокатегорийность в PS9), CSS подкатегорий-плиток.
  - **Раздел 6** — SEO Google Ukraine 2025–2026: Helpful Content Update,
    AI Overviews (доступны в UA с 2025), Core Web Vitals (LCP/CLS/INP актуальные пороги),
    структурированные данные для категорий, hreflang uk/ru.
  - **Раздел 7** — AI-агенты (новый, полностью):
    Perplexity / ChatGPT Search / Gemini / Claude Search.
    Принцип чтения страниц AI-агентами, рекомендации по текстам категорий,
    llms.txt (новый стандарт 2025) — пример для G&G UA.
  - **Раздел 8** — Фильтры ps_facetedsearch: полная таблица фильтров для G&G,
    таблица характеристик (Features) — создать до загрузки товаров.
  - **Раздел 10** — Карточка в листинге: тег серии (SOOV / Kids / Cal-M),
    CSS для `.product-series-tag`.
  - **Раздел 11** — Украинский e-commerce: правовые требования для БАДов
    (Закон № 4122-IX), дисклеймер категории, нотификация ДПСС,
    языковые требования, отображение цен в гривнях.
  - **Раздел 12** — Страница «Для чого»: 18 направлений здоровья,
    реализация через теги PS9.

- `PRODUCT-0.7.0-recommendations.md` — дополнен разделами:
  - **Раздел 3.4** — Тег серии (лінійки) в покупательской панели:
    `.product-line-badge` для SOOV / Kids / Cal-M / Total Fitness — CSS.
  - **Раздел 3.5** — Доверительные метки (Trust Badges): Made in UK,
    Нотифіковано МОЗ, Без наповнювачів, Не тестовано на тваринах.
  - **Раздел 6** — Информационные секции: полный HTML всех 9 секций,
    CSS аккордеон для mobile, обход лимита 255 символов в Features.
  - **Раздел 7** — Characteristics (Features) PS9: расширенная таблица
    (14 характеристик), таблица характеристик в шаблоне.
  - **Раздел 8** — Микроразметка: обновлён JSON-LD Product под Google Shopping
    2025–2026 (обязательны gtin13, brand, countryOfOrigin), рекомендуемые FAQ для G&G.
    AI-агенты — сигналы для ранжирования страниц товаров.
  - **Раздел 9** — Отзывы: Distribution Bar (Baymard 2025, +34% доверия).
  - **Раздел 10** — Схожі товари: логика подбора для G&G (серия, форма,
    cross-sell), контекстные заголовки секции.
  - **Раздел 12** — Украинские правовые требования: обязательные элементы
    на странице товара (Закон № 4122-IX), таблица 11 обязательных элементов,
    обязательный дисклеймер «Дієтична добавка».
  - **Раздел 13** — Core Web Vitals страницы товара: LCP (preload главного
    фото), CLS (aspect-ratio галереи), INP (IntersectionObserver для sticky bar).
  - **Раздел 14** — SEO страницы товара: meta tags, Google Shopping UA 2025,
    оптимизация для AI-агентов.

### Добавлено

- `ps9_categories.md` — новый файл (создан параллельно): полная структура
  46 категорий и подкатегорий PS9 с маппингом всех ~300 товаров G&G.
  Источники: gandgvitamins.com/sitemap.html + soov.uk.
  Включает: таблицу ассоциаций [МУЛЬТИ], характеристики (Features),
  теги, рекомендации по SEO slug-ам, навигацию «Для чого» (18 направлений).

### Исправлено

- **Главная страница (ручные правки на сайте, 2026-03-19):**
  - Выпадающий список в модуле поиска — добавлен и работает корректно.
  - Устранены основные ошибки отображения на главной странице.
  - *(Правки выполнены вне системы версий — зафиксировать в theme.css / header.tpl при следующем рефакторинге.)*

### Заметки

- **Следующий шаг по плану:** v0.7.0 — карточка товара `product.tpl` + партиалы.
  Перед написанием кода — изучить обновлённый `PRODUCT-0.7.0-recommendations.md`.
- **Главная страница** (`index.tpl`) — разрабатывается после каталога и карточки товара.
- **ps_facetedsearch:** установить и настроить фильтры согласно разделу 8 CATALOG.
  Сделать до загрузки товаров — характеристики (Features) создаются первыми.
- **ps9_categories.md** — использовать как справочник при создании категорий в PS9 BO.
- **llms.txt:** создать в корне сайта после запуска — новый стандарт 2025 для AI-агентов.

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
  1. Хлебные крошки — `_partials/breadcrumb.tpl`
  2. Flash-уведомления — `_partials/notifications.tpl`
  3. Двухколоночный layout `.product-layout` (≥992px: 55% галерея + 45% панель)
  4. Информационные секции `.product-info-sections` (8 секций, accordion mobile)
  5. Відгуки — `{hook h='displayProductTabContent'}` → ps_productcomments
  6. Схожі товари — `{hook h='displayFooterProduct'}`, scroll-snap
  7. JSON-LD: `schema-product.tpl` + `schema-faq.tpl`

**Партиалы страницы товара:**

- `templates/catalog/_partials/product-images.tpl` — галерея. Desktop: миниатюры слева + главное фото. Mobile: swipe + dots. Lightbox: нативный `<dialog>`.
- `templates/catalog/_partials/product-prices.tpl` — блок цен (текущая, старая, бейдж скидки).
- `templates/catalog/_partials/product-variants.tpl` — выбор вариантов PS9.
- `templates/catalog/_partials/product-add-to-cart.tpl` — qty stepper + кнопка «До кошика».

---

## [0.6.1] — 2026-03-18 — theme.css: рефакторинг :root на OKLCH

### Изменено
- `assets/css/theme.css` — полный рефакторинг `:root`: все цвета переведены с HEX/rgba на `oklch()`. Добавлены новые токены типографики, теней, высот.

### Заметки
- Правило `:root`: ни одного `#hex` или `rgba()` — только `oklch()`.
- Смена `--color-primary`: `#FF5722` (оранжевый) → `oklch(47% 0.07 145)` (корпоративный зелёный G&G).

---

## [0.6.0] — 2026-03-18 — Каталог: category.tpl, product-list.tpl, product-miniature.tpl + партиалы + category.css

### Добавлено

- `templates/catalog/listing/category.tpl` — страница категории.
- `templates/catalog/listing/product-list.tpl` — сетка товаров.
- `templates/catalog/listing/product-miniature.tpl` — карточка товара в листинге.
- `templates/catalog/listing/_partials/rating-stars.tpl`
- `templates/catalog/listing/_partials/empty-state.tpl`
- `templates/catalog/listing/_partials/products-top.tpl`
- `assets/css/pages/category.css`

### Заметки
- `category.tpl`: описание в `<details>/<summary>` — в DOM, читается Google и AI-агентами.
- `product-miniature.tpl`: `$is_above_fold` — первые 4 карточки `eager+high`.
- `noindex` при `$listing.is_filtered`.

---

## [0.5.2] — 2026-03-17 — Партиалы: nav, form-errors

### Добавлено
- `templates/_partials/nav.tpl`
- `templates/_partials/form-errors.tpl`

---

## [0.5.1] — 2026-03-17 — Партиалы: breadcrumb, notifications, pagination

### Добавлено
- `templates/_partials/breadcrumb.tpl`
- `templates/_partials/notifications.tpl`
- `templates/_partials/pagination.tpl`

---

## [0.5.0] — 2026-03-17 — Главная страница: index.tpl, layout, displayHome

### Добавлено
- `templates/layouts/layout-full-width.tpl`
- `templates/_partials/hooks/displayHome.tpl`
- `templates/index.tpl` — 5 секций: Hero → USP Bar → Modules → About → FAQ

### Заметки
- Hero — статичный HTML, не ps_imageslider. Лучше LCP, выше конверсия.
- FAQ — Вариант A (assign). `{l}` не работает внутри `{assign value=[...]}`.

---

## [0.4.0] — 2026-03-17 — Микроразметка JSON-LD

### Добавлено
- `schema-organization.tpl` — Organization + WebSite + SearchAction
- `schema-breadcrumb.tpl` — BreadcrumbList
- `schema-product.tpl` — Product + Offer + AggregateRating
- `schema-category.tpl` — ItemList
- `schema-article.tpl` — WebPage или Article
- `schema-faq.tpl` — FAQPage

### Исправлено
- `schema-article.tpl` — порядок модификаторов: `truncate|escape` (исправлено).

### Заметки
- Порядок модификаторов в JSON-LD: `strip_tags → trim → truncate → escape` — строго.
- PHP 8.4: `|truncate:10:''` вместо `date_format:'%Y-%m-%d'`.

---

## [0.3.2] — 2026-03-16 — theme.css, theme.js

### Добавлено
- `assets/css/theme.css` — глобальные стили, 19 секций.
- `assets/js/theme.js` — 6 Vanilla JS модулей.

---

## [0.3.1] — 2026-03-16 — header.tpl, footer.tpl

### Добавлено
- `templates/_partials/header.tpl`
- `templates/_partials/footer.tpl`

---

## [0.3.0] — 2026-03-16 — head.tpl

### Добавлено
- `templates/_partials/head.tpl`

---

## [0.2.1] — 2026-03-16 — theme.yml патч: wishlist + FA7

### Изменено
- `config/theme.yml` — blockwishlist включён. FA7 → 3 отдельных CSS файла.

---

## [0.2.0] — 2026-03-16 — theme.yml финальная версия

### Добавлено
- `config/theme.yml` — полная конфигурация.

---

## [0.1.0] — 2026-03-16 — Архитектура проекта

### Добавлено
- `PROJECT.md`, `CHANGELOG.md`, структура папок, список модулей.

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
| `0.6.2` | Документация: обновление CATALOG + PRODUCT + ps9_categories.md | ✅ |
| `0.7.0` | Карточка товара `product.tpl` + партиалы | ✅ |
| `0.7.1` | Заглушки (stubs) для установки темы в PS9 | ✅ |
| `0.7.2` | Карточка товара: `product.css` + `product.js` | ✅ |
| `0.7.3` | Фикс: поиск + Top Bar (display:none для дублирующего поля) | ✅ |
| `0.8.0` | Корзина и оформление заказа `checkout/` (полная реализация) | ⬜ |
| `0.9.0` | Личный кабинет `customer/` | ⬜ |
| `0.10.0` | CMS страницы + ошибки | ⬜ |
| `0.11.0` | Переопределения модулей `modules/` | ⬜ |
| `0.12.0` | Глобальные стили `theme.css` (доработка) | ⬜ |
| `0.13.0` | Глобальный JS `theme.js` (доработка) | ⬜ |
| `0.14.0` | Страничные CSS и JS (`pages/`) | ⬜ |
| `0.15.0` | SEO модуль + финальная проверка микроразметки + llms.txt | ⬜ |
| `1.0.0` | Тема готова к production | ⬜ |
