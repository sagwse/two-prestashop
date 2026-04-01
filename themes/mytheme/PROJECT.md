# MyShop — PrestaShop 9.0 Custom Theme Project
> Последнее обновление: v0.7.3 — Фикс поиска + Top Bar (2026-03-21)

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

## СТРУКТУРА ТЕМЫ

> Актуальная структура файлов — всегда в файле **`STRUCTURE_THEMES_current.txt`**.
> Генерировать командой из корня темы:
> ```bash
> tree -a --gitignore > STRUCTURE_THEMES_current.txt
> ```

---

## КАТАЛОГ v0.6.0 — КЛЮЧЕВЫЕ РЕШЕНИЯ

> Полная документация: **`CATALOG-0.6.0-recommendations.md`**

| Вопрос | Решение | Обоснование |
|---|---|---|
| Layout | `layout-left-column` + aside фильтры | 300+ товаров — фильтры обязательны (Baymard 2025) |
| Grid/List toggle | Оба режима, по умолчанию Grid | 78% Grid, 41% переключаются в List (Forrester 2024) |
| Фон фото | Белый `#fff`, `object-fit: contain` | Google Merchant Center + не обрезает упаковки |
| Колонки mobile | 2 колонки | +23% конверсии vs 1 колонка (Baymard 2025) |
| Фильтры mobile | Bootstrap Offcanvas drawer | Не перекрывает контент |
| Модуль фильтров | `ps_facetedsearch` | Официальный, слабая связь через хук |
| AJAX | AJAX + History API + fallback | SEO (pushState), кнопка «Назад» |
| Рейтинг | 3 состояния | Пустые звёзды при 0 → −15% конверсии (Baymard 2024) |
| Подкатегории | Плитки между Hero и Toolbar | Стандартный паттерн навигации |
| Сравнение | Не реализуем | Решение принято |

---

## СТРУКТУРА КАТЕГОРИЙ — ps9_categories.md

> Полная документация + маппинг всех товаров: **`ps9_categories.md`**

### Краткая схема мега-меню (6 колонок)

| # | Колонка | Подкатегорий | Ключевые товары |
|---|---|---|---|
| 1 | 🌿 Вітаміни | 8 | Vit D3★, Vit C, Vit B12★, Мульти |
| 2 | 💊 Мінерали | 9 | Магній★ (Cal-M), Цинк, Залізо, Кальцій |
| 3 | 🌱 Добавки | 13 | Омега★, Пробіотики★, Колаген, Botanicals |
| 4 | ⭐ Спеціальні | 10 | SOOV★, Kids Rainbow★, 50+, Веган, Daily Packs |
| 5 | 🔥 Популярне | 5 | Топ для початку★, Новинки, Сезонні |
| 6 | 🎀 SOOV [банер] | 1 сторінка | Flow★, Meno, 40+, Deflate★, Ouch★ + 7 ін. |

**Принципы ассоциаций (многокатегорийность):**
- Каждый товар: 1 основная категория + N дополнительных.
- Настройка: BO → Товары → вкладка «Ассоциации» → «Дополнительные категории».
- Список товаров [МУЛЬТИ] — в `ps9_categories.md`.

---

## КАРТОЧКА ТОВАРА v0.7.0 — КЛЮЧЕВЫЕ РЕШЕНИЯ

> Полная документация: **`PRODUCT-0.7.0-recommendations.md`**

| Вопрос | Решение | Обоснование |
|---|---|---|
| Layout | 55/45 двухколоночный | Стандарт нутрицевтики |
| Информационные секции | Вертикально раскрытые | Горизонтальные табы — 27% пропускают (Baymard 2025) |
| Галерея desktop | Миниатюры слева (вертикально) | Лучший pattern для 4–6 фото (NNG 2024) |
| Галерея mobile | Swipe + dots | Нет миниатюр на mobile |
| Зум | Нативный `<dialog>` lightbox | Без JS-библиотек |
| Supplement Facts | Обязательное фото в галерее | Baymard 2025: критично для БАДов |
| Sticky desktop | Галерея прилипает | До начала инфо-блоков |
| Sticky mobile | Bottom bar с ценой + кнопкой | IntersectionObserver, выше bottom nav |
| Рейтинг | Distribution Bar | +34% доверия (Baymard 2025) |
| Секции | 9 секций + отзывы + похожие | Полная информация о БАДе |
| Дисклеймер | Обязательная открытая секция | Закон Украины № 4122-IX |
| Характеристики | 14 Features в PS9 BO | Создать ДО загрузки товаров |

---

## SEO И AI-АГЕНТЫ — СТРАТЕГИЯ 2025–2026

| Направление | Решение | Статус |
|---|---|---|
| Google Helpful Content | Описания 100–300 слов + E-E-A-T | ⬜ при заполнении категорий |
| Google AI Overviews | Фокус на транзакционных запросах | ⬜ при написании описаний |
| Core Web Vitals | LCP ≤ 2.5s / CLS ≤ 0.1 / INP ≤ 200ms | ⬜ проверить после v0.7.0 |
| Google Shopping UA | EAN (gtin13) + белый фон фото + цена UAH | ⬜ при загрузке товаров |
| Perplexity / ChatGPT Search | JSON-LD + FAQ Schema + текстовый состав | ✅ schema-product + schema-faq |
| Gemini | Аналогично Perplexity | ✅ schema реализована |
| llms.txt | Файл в корне сайта | ⬜ v0.15.0 |
| hreflang uk/ru | Автоматически при добавлении языка PS9 | ✅ в head.tpl |

---

## МИКРОРАЗМЕТКА — СТРАТЕГИЯ

| Страница | Файл схемы | Тип schema.org | Статус |
|---|---|---|---|
| Все страницы (head) | schema-organization.tpl | `Organization + WebSite + SearchAction` | ✅ |
| Все страницы | schema-breadcrumb.tpl | `BreadcrumbList` | ✅ |
| Карточка товара | schema-product.tpl | `Product + Offer + AggregateRating` | ✅ ⚠️ проверить gtin13 |
| Страница категории | schema-category.tpl | `ItemList` | ✅ |
| CMS страница | schema-article.tpl | `WebPage` или `Article` | ✅ |
| FAQ блок | schema-faq.tpl | `FAQPage` | ✅ |
| Подтверждение заказа | inline Order | `Order` | ⬜ v0.8.0 |

Страничные схемы подключаются через `{hook h='displaySchemaMarkup'}`.

### Правило порядка модификаторов в JSON-LD
```smarty
{* ПРАВИЛЬНО — escape всегда последний: *}
{$var|strip_tags|trim|truncate:5000:''|escape:'javascript'}
```

---

## THEME.JS — МОДУЛИ

| Модуль | Назначение |
|---|---|
| `SmartSticky` | Умная шапка: IntersectionObserver + scroll direction |
| `CartOffcanvasMode` | Переключение mini-cart: bottom (mobile) / end (desktop) |
| `CartBadgeSync` | Синхронизация счётчика корзины (слушает `updateCart` PS) |
| `MobileNavSpacer` | Динамическая высота spacer через `getBoundingClientRect()` |
| `FooterAccordion` | Accordion поведение footer |
| `SearchBarEnhance` | Кнопка ×, автофокус, MutationObserver, выпадающий список ✅ |

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

## ЦВЕТОВАЯ СИСТЕМА — OKLCH

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
| gtin13 не заполнен в schema-product.tpl | Проверить Features «Штрихкод EAN» + schema-product.tpl |
| AI-агенты не видят контент в display:none | Описания в `<details>` — в DOM, всегда читаются ✅ |
| llms.txt — новый стандарт AI 2025 | Создать в корне сайта при v0.15.0 |
| Поле «Вход» дублировалось в Top Bar | Скрыто через `display: none` в theme.css (v0.7.3) |

---

## ПЛАН ВЕРСИЙ

> Полная история изменений — в **`CHANGELOG.md`**

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
| `0.6.2` | Документация: CATALOG + PRODUCT + ps9_categories.md | ✅ |
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
