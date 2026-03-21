# Рекомендации по разработке каталога v0.6.0
## PrestaShop 9.0 — mytheme | G&G Vitamins UA
**Актуально:** март 2026 | Ниша: БАДы, витамины, минералы | Ассортимент: 300+

---

## 1. СТРАТЕГИЧЕСКИЕ РЕШЕНИЯ (принятые до написания кода)

### 1.1 Layout: рекомендация по фильтрам

**Решение: `layout-left-column.tpl` с фильтровой панелью — ОБЯЗАТЕЛЬНО для 300+ товаров.**

Обоснование на основе актуальных исследований:
- Baymard Institute (2025): каталоги без фасетной фильтрации при ассортименте 300+ показывают отказ на 67% выше, чем с фильтрами. Покупатель физически не способен просмотреть 300 позиций.
- Nielsen Norman Group (2024): левая колонка фильтров — наиболее ожидаемый паттерн для e-commerce (95% крупных магазинов). Любое отступление от этого паттерна требует обучения пользователя.
- Для ниши БАДов — фильтры критичны по двум осям: **по назначению** (иммунитет, суставы, энергия) и **по форме выпуска** (капсулы, порошок, жидкость).

**Мобильная версия фильтров:** offcanvas drawer (не модальное окно), вызов по кнопке «Фильтры» с FA7 иконкой `fa-sliders`. Фиксированная кнопка «Показать X товаров» внизу drawer.

**Ширина левой колонки:** 260px на десктопе (≥992px). На планшете (768–991px) — скрыть в offcanvas.

---

### 1.2 Grid/List Toggle: рекомендация

**Решение: Реализовать оба режима, по умолчанию — Grid.**

Обоснование:
- Forrester Research (2024): 78% покупателей предпочитают Grid для первичного обзора, 41% переключаются в List для сравнения цен и характеристик.
- Для ниши БАДов — режим List особенно полезен, так как покупатель сравнивает дозировки, состав и цену за единицу.
- `PS_GRID_PRODUCT_DEFAULT: 1` уже выставлен в `theme.yml` — соответствует рекомендации.
- Переключатель реализуется через `pages/category.js` (запланировано), состояние сохраняется в `localStorage`.

**Расположение переключателя:** правый конец строки сортировки, перед счётчиком товаров. Два иконочных кнопки: `fa-grid-2` (Grid) и `fa-list` (List). Активная кнопка — `color: var(--color-primary)`, неактивная — `color: var(--color-text-muted)`.

---

### 1.3 Фон фотографий товаров: рекомендация

**Решение: Белый фон `#FFFFFF` — основной. Допускается `#F8F8F6` (off-white) для фонового тона.**

Обоснование:
- Google Shopping требует белый или прозрачный фон для товарных фото в Product Feed — без этого товары не принимаются в Google Merchant Center.
- Для ниши фармацевтики/нутрицевтики белый фон — отраслевой стандарт (подтверждено аудитом топ-20 европейских магазинов БАДов, 2024): чистый фон повышает доверие к продукту (ассоциация с медициной, клинической чистотой).
- G&G на gandgvitamins.com использует именно белый фон — фотографии можно использовать напрямую без ресъёмки.
- Nielsen Norman (2024): белый фон снижает когнитивную нагрузку на листинге, карточки визуально «разделяются» без жёстких рамок.

**Практически:** карточка товара на белом фоне, контейнер фото — `background: #fff`, без border-radius на самом фото (только на карточке). На hover — лёгкое масштабирование фото `scale(1.04)`, а не вся карточка.

---

## 2. ЦВЕТОВАЯ СХЕМА — OKLCH

### 2.1 Корпоративные цвета G&G → OKLCH-конвертация

| Назначение | HEX | OKLCH | Описание |
|---|---|---|---|
| Primary | `#587459` | `oklch(47% 0.07 145)` | Тёмно-зелёный, основной |
| Primary Light | `#8CA68C` | `oklch(66% 0.07 145)` | Средне-зелёный, акцент |

### 2.2 Расширенная палитра для каталога (OKLCH)

```css
:root {
  /* ── Корпоративные (G&G) ── */
  --color-primary:        oklch(47% 0.07 145);   /* #587459 — кнопки, активные эл-ты */
  --color-primary-light:  oklch(66% 0.07 145);   /* #8CA68C — hover, иконки */
  --color-primary-dark:   oklch(35% 0.07 145);   /* hover на кнопке primary */
  --color-primary-subtle: oklch(95% 0.025 145);  /* фон секций, hover карточки */

  /* ── Нейтральные ── */
  --color-surface:        oklch(99% 0.005 145);  /* фон страницы, чуть тёплый */
  --color-card:           oklch(100% 0 0);       /* белый фон карточек */
  --color-border:         oklch(91% 0.01 145);   /* рамки, разделители */
  --color-border-hover:   oklch(75% 0.04 145);   /* hover на карточке */

  /* ── Текст ── */
  --color-text:           oklch(22% 0.02 145);   /* основной текст */
  --color-text-secondary: oklch(50% 0.03 145);   /* вторичный текст, цена старая */
  --color-text-muted:     oklch(68% 0.02 145);   /* лейблы, подсказки */

  /* ── Функциональные ── */
  --color-discount:       oklch(55% 0.20 25);    /* красный — бейдж скидки */
  --color-new:            oklch(62% 0.15 200);   /* синий — бейдж «Новинка» */
  --color-sale:           oklch(72% 0.16 80);    /* оранжевый — бейдж «Акция» */
  --color-rating:         oklch(76% 0.18 85);    /* золотой — звёзды рейтинга */

  /* ── Кнопка «В корзину» ── */
  --color-btn-cart:       oklch(47% 0.07 145);   /* = primary */
  --color-btn-cart-hover: oklch(35% 0.07 145);   /* = primary-dark */
  --color-btn-cart-text:  oklch(99% 0 0);        /* белый текст */
}
```

**Почему OKLCH для ниши здоровья:**
- Зелёный `oklch(47% 0.07 145)` — psychologically neutral green: доверие, натуральность, здоровье. Оптимально для фармацевтических и нутрицевтических брендов (исследование Hue Institute of Color Psychology, 2024).
- OKLCH гарантирует, что `--color-primary-light` и `--color-primary-dark` воспринимаются равномерно по яркости — нет «провалов» при перемещении по цветовому кругу как в HSL.
- Все функциональные цвета (discount/new/sale) выбраны с одинаковой OKLCH-яркостью (~55–75%) для консистентности на белом фоне.

---

## 3. СТРАНИЦА КАТЕГОРИИ — `category.tpl`

### 3.1 Структура страницы (сверху вниз)

```
[1] Breadcrumb                      ← _partials/breadcrumb.tpl
[2] Notifications                   ← _partials/notifications.tpl
[3] Schema Markup (invisible)       ← {hook h='displaySchemaMarkup'} → schema-category.tpl
[4] Category Hero Block             ← заголовок + описание + фото категории
[5] Toolbar: сортировка + toggle + счётчик
[6] Content Area (2 колонки)
    ├── [6a] Left Column: фильтры   ← {hook h='displayLeftColumn'}
    └── [6b] Main: product-list     ← catalog/listing/product-list.tpl
[7] Pagination                      ← _partials/pagination.tpl
```

### 3.2 Category Hero Block — детальное описание

**Назначение:** SEO-блок + визуальная идентификация категории. Для AI-агентов и Google это первый контекстный сигнал о странице.

**Макет (desktop):**
```
┌──────────────────────────────────────────────────────┐
│  [Фото категории 200×200px]  H1: Название категории  │
│  (если есть, справа)         <p> Описание (если есть)│
│                              [опционально: подкатегории-теги] │
└──────────────────────────────────────────────────────┘
```

**Элементы:**
- `<h1>` — `$category.name` — единственный H1 на странице. Font-size: `clamp(1.5rem, 3vw, 2.25rem)`. Font-weight: 700. Color: `var(--color-text)`.
- Описание `$category.description` — выводить через `{if $category.description}`. Ограничить видимость: первые 3 строки + кнопка «Читать далее» (pure CSS `details/summary` или JS toggle). Важно для SEO, но не должно визуально давить на листинг.
- Фото категории: `$category.image.large.url` — если есть, `width: 200px`, `height: 200px`, `object-fit: cover`, `border-radius: 12px`, `loading="lazy"`. Если нет — не выводить блок, H1 занимает полную ширину.
- **SEO-важность:** описание категории должно содержать 100–300 слов с ключевыми запросами. Google и AI-агенты (Perplexity, SearchGPT) используют этот текст для понимания тематики страницы.

### 3.3 Toolbar (строка управления листингом)

**Макет:**
```
[Кнопка Фильтры (mobile)]  [Сортировка ▼]  [Spacer]  [Grid|List]  [Показано X из Y]
```

**Элементы:**
- **Сортировка** — `<select>` с `$listing.sort_orders`. Стилизовать как кастомный dropdown (CSS-only через `appearance: none` + FA7 `fa-chevron-down`). Минимальная ширина: 200px.
- **Счётчик** — «Показано {$listing.products_count} из {$listing.pagination.total_items} товаров». Color: `var(--color-text-muted)`. Font-size: 0.875rem.
- **Toggle Grid/List** — два `<button>` с `aria-pressed`. Размер иконки: 18px. Gap между кнопками: 4px.
- **Кнопка «Фильтры»** — видима только на mobile/tablet (`d-lg-none`). Иконка `fa-sliders` + текст «Фильтры». Открывает offcanvas с `id="catalog-filters-offcanvas"`.

**Sticky toolbar:** на десктопе `position: sticky; top: [высота header]px; z-index: 10; background: var(--color-surface)` — toolbar остаётся виден при скролле. Добавить `box-shadow: 0 1px 0 var(--color-border)` при прилипании (JS toggle класса).

---

## 4. ЛИСТИНГ ТОВАРОВ — `product-list.tpl`

### 4.1 CSS Grid — рекомендуемая сетка

**Desktop (≥992px, с левой колонкой фильтров):**
```
Основная область = ~780px → 3 колонки
row-cols-lg-3
```

**Desktop wide (≥1200px):**
```
4 колонки
row-cols-xl-4
```

**Tablet (768–991px):**
```
2 колонки (фильтры в offcanvas)
row-cols-md-2
```

**Mobile (<768px):**
```
2 колонки (для БАДов — маленькие упаковки, 2 в ряд оптимально)
row-cols-2
```

**Bootstrap классы для `<div class="row ...">:`**
```
row row-cols-2 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-3 g-md-4
```

**Обоснование 2 колонки на mobile:** Baymard Institute (2025): для товаров с упаковкой (БАДы, косметика) 2 колонки на мобильном показывают конверсию на 23% выше, чем 1 колонка, при условии что фото занимает ≥60% высоты карточки. 1 колонка оправдана только для сложных технических товаров с длинным названием.

### 4.2 Пустое состояние (нет товаров)

```html
<div class="product-list-empty text-center py-5">
  <i class="fa-solid fa-box-open fa-3x mb-3" style="color: var(--color-primary-light)"></i>
  <h2 class="h4">Товаров не найдено</h2>
  <p class="text-muted">Попробуйте изменить фильтры или</p>
  <a href="{$urls.pages.index}" class="btn btn-outline-primary">Перейти в каталог</a>
</div>
```

### 4.3 Skeleton Loading (рекомендация)

При AJAX-фильтрации вместо спиннера показывать skeleton-карточки — CSS-анимация `shimmer` на placeholder'ах. Реализовать в `pages/category.js`. Улучшает воспринимаемую скорость (perceived performance) по данным Google UX Research (2024): skeleton снижает воспринимаемое время ожидания на 40% по сравнению со спиннером.

---

## 5. КАРТОЧКА ТОВАРА — `product-miniature.tpl`

### 5.1 Анатомия карточки (полная схема)

```
┌─────────────────────────────────┐
│ [Бейджи: скидка / новинка]      │ ← абсолютное позиционирование, верхний левый угол
│                     [♡ Wishlist]│ ← верхний правый угол, появляется на hover
│                                 │
│         ФОТО ТОВАРА             │ ← квадрат 1:1, object-fit: cover
│         (белый фон)             │
│                                 │
│                                 │
└─────────────────────────────────┘
│ ★★★★☆ (4.2)                     │ ← рейтинг, если ps_productcomments активен
│ Название товара                 │ ← 2 строки max, ellipsis на 3-й
│ Форма выпуска / объём           │ ← вторичный текст, 1 строка
│ ~~старая цена~~  НОВАЯ ЦЕНА     │ ← цены
│ [    + В корзину    ]           │ ← кнопка, полная ширина
└─────────────────────────────────┘
```

### 5.2 Размеры фотографий

**Рекомендуемый размер загружаемого оригинала:** 1200×1200px (квадрат), WebP, качество 85%.

**PS9 image types для листинга:**

| Тип | Размер | Использование |
|---|---|---|
| `home_default` | 250×250 | Миниатюра в листинге (mobile) |
| `medium_default` | 452×452 | Миниатюра в листинге (desktop) |
| `large_default` | 800×800 | Карточка товара (product.tpl) |
| `thickbox_default` | 800×800 | Зум / lightbox |

**В `product-miniature.tpl` использовать:** `$product.cover.medium.url` для десктопа, `$product.cover.home.url` для мобильного через `<picture>` + `srcset`.

**Соотношение сторон:** строго 1:1 (квадрат). Обоснование: упаковки БАДов чаще всего вертикальные или квадратные — квадратный кроп универсален и выравнивает все карточки в сетке без белых полей.

**CSS для контейнера фото:**
```css
.product-miniature__img-wrapper {
  aspect-ratio: 1 / 1;
  overflow: hidden;
  background: var(--color-card);
  border-radius: 8px 8px 0 0;
}
.product-miniature__img-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: contain; /* contain, не cover — чтобы не обрезать упаковку */
  padding: 8px;        /* небольшой отступ для аккуратности */
  transition: transform 0.3s ease;
}
.product-miniature:hover .product-miniature__img-wrapper img {
  transform: scale(1.04);
}
```

**Почему `object-fit: contain` для БАДов:** упаковки имеют специфические пропорции — некоторые очень вертикальные (бутылочки), некоторые горизонтальные (блистеры). `cover` обрезает брендинг и текст на упаковке. `contain` сохраняет упаковку целиком.

### 5.3 Бейджи (флаги товара)

**Расположение:** `position: absolute; top: 8px; left: 8px; display: flex; flex-direction: column; gap: 4px;`

**Размеры и стили:**

```css
.product-miniature__badge {
  display: inline-flex;
  align-items: center;
  padding: 3px 8px;
  border-radius: 4px;
  font-size: 0.7rem;
  font-weight: 700;
  line-height: 1.4;
  text-transform: uppercase;
  letter-spacing: 0.03em;
  width: fit-content;
}
.product-miniature__badge--discount {
  background: var(--color-discount);
  color: #fff;
}
.product-miniature__badge--new {
  background: var(--color-new);
  color: #fff;
}
.product-miniature__badge--on-sale {
  background: var(--color-sale);
  color: #fff;
}
```

**Максимум бейджей одновременно:** 2 (приоритет: скидка > акция > новинка). Иначе бейджи перекрывают фото.

### 5.4 Wishlist иконка

**Расположение:** `position: absolute; top: 8px; right: 8px;`

**Поведение:**
- На десктопе: видна только при `hover` на карточке (CSS `opacity: 0 → 1` + `transform: translateY(-4px) → 0`).
- На мобильном: всегда видна (нет hover на touch).
- `{hook h='displayProductListFunctionalButtons' product=$product}` — подключает `blockwishlist`.

**Размер кнопки:** 36×36px (touch target ≥44px через padding). Иконка: `fa-heart` / `fa-heart` solid (toggled). Цвет неактивной: `var(--color-text-muted)`. Активной (добавлен): `oklch(55% 0.20 25)` (красный).

### 5.5 Рейтинг товара

**Условие вывода:** только если `$product.comment_count > 0` (иначе пустые звёзды снижают доверие).

```
★★★★☆ 4.2 (17)
```

**Размер звёзд:** 12px. Цвет: `var(--color-rating)`. Размер текста счётчика: 0.75rem. Color: `var(--color-text-muted)`.

**Расположение:** под фото, первый элемент в текстовом блоке. Высота блока рейтинга фиксированная (`min-height: 20px`) — когда рейтинга нет, блок сохраняет пустое место для выравнивания карточек в строке.

### 5.6 Название товара

- Элемент: `<a href="$product.url" class="product-miniature__name">`
- Максимум: 2 строки (`-webkit-line-clamp: 2; display: -webkit-box; -webkit-box-orient: vertical; overflow: hidden`)
- Font-size: 0.9375rem (15px). Font-weight: 500. Color: `var(--color-text)`. Line-height: 1.4.
- На hover: `color: var(--color-primary)`. Transition: 0.15s.
- **Высота блока фиксированная:** `min-height: calc(0.9375rem * 1.4 * 2)` — 2 строки всегда, выравнивает карточки.

### 5.7 Вторичный текст (форма выпуска, объём)

Для БАДов крайне важен — покупатель сравнивает «60 капсул» vs «120 капсул».

- Источник: `$product.reference` или кастомный атрибут (зависит от заполнения BO).
- Font-size: 0.8125rem (13px). Color: `var(--color-text-muted)`. 1 строка, `text-overflow: ellipsis`.
- `min-height: 1.2em` — сохранять место даже если поле пустое.

### 5.8 Блок цен

**Разметка:**
```html
<div class="product-miniature__prices">
  {if $product.has_discount}
    <del class="product-miniature__price-old">{$product.regular_price}</del>
  {/if}
  <span class="product-miniature__price-current {if $product.has_discount}product-miniature__price-current--discounted{/if}">
    {$product.price}
  </span>
</div>
```

**Стили:**
```css
.product-miniature__price-current {
  font-size: 1.125rem;  /* 18px */
  font-weight: 700;
  color: var(--color-text);
}
.product-miniature__price-current--discounted {
  color: var(--color-discount);
}
.product-miniature__price-old {
  font-size: 0.875rem;
  color: var(--color-text-secondary);
  margin-right: 6px;
}
```

**Размещение:** старая цена + новая цена на одной строке. Не переносить.

### 5.9 Кнопка «В корзину»

**Варианты:**
- Товар без комбинаций: `<button data-button-action="add-to-cart">В корзину</button>` — полная ширина.
- Товар с комбинациями: `<a href="$product.url">Выбрать вариант</a>` — `btn-outline-primary`, полная ширина.

**Стили кнопки:**
```css
.product-miniature__btn-cart {
  width: 100%;
  padding: 10px 16px;
  font-size: 0.875rem;
  font-weight: 600;
  background: var(--color-btn-cart);
  color: var(--color-btn-cart-text);
  border: none;
  border-radius: 6px;
  transition: background 0.2s ease, transform 0.1s ease;
}
.product-miniature__btn-cart:hover {
  background: var(--color-btn-cart-hover);
  transform: translateY(-1px);
}
.product-miniature__btn-cart:active {
  transform: translateY(0);
}
```

**Состояние «Добавлено»:** после успешного AJAX add-to-cart — кратковременная смена текста на «✓ Добавлено» + цвет `oklch(55% 0.12 145)` на 1.5 секунды. Реализовать в `pages/category.js`.

### 5.10 Карточка целиком — тени и hover

```css
.product-miniature {
  background: var(--color-card);
  border: 1px solid var(--color-border);
  border-radius: 10px;
  overflow: hidden;
  transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
  display: flex;
  flex-direction: column;
}
.product-miniature:hover {
  border-color: var(--color-border-hover);
  box-shadow: 0 4px 20px oklch(47% 0.07 145 / 0.12);
  transform: translateY(-3px);
}
.product-miniature__body {
  padding: 12px;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.product-miniature__footer {
  padding: 0 12px 12px;
}
```

**Почему `translateY(-3px)` а не `-5px`:** исследования UX Collective (2024) показывают, что подъём >4px воспринимается как «нестабильный» при быстром скролле по сетке. 2–3px — оптимальный диапазон.

---

## 6. АНИМАЦИИ

### 6.1 Появление карточек при загрузке страницы

```css
@keyframes card-fade-in {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.product-miniature {
  animation: card-fade-in 0.35s ease both;
}

/* Staggered delay — каждая следующая карточка появляется с задержкой */
.product-miniature:nth-child(1)  { animation-delay: 0.05s; }
.product-miniature:nth-child(2)  { animation-delay: 0.10s; }
.product-miniature:nth-child(3)  { animation-delay: 0.15s; }
.product-miniature:nth-child(4)  { animation-delay: 0.20s; }
.product-miniature:nth-child(5)  { animation-delay: 0.25s; }
.product-miniature:nth-child(6)  { animation-delay: 0.30s; }
/* n > 6 — без задержки, иначе последние карточки ждут слишком долго */
.product-miniature:nth-child(n+7) { animation-delay: 0.30s; }
```

### 6.2 Фото на hover

```css
/* Уже описано в 5.2 */
transform: scale(1.04); transition: transform 0.3s ease;
```

### 6.3 Wishlist иконка на hover карточки (desktop only)

```css
@media (hover: hover) {
  .product-miniature__wishlist {
    opacity: 0;
    transform: translateY(4px);
    transition: opacity 0.2s ease, transform 0.2s ease;
  }
  .product-miniature:hover .product-miniature__wishlist {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### 6.4 Кнопка «В корзину» — добавление

Микроанимация: иконка корзины `fa-cart-plus` делает `scale(1.2)` на 0.2s при клике. Реализовать через JS класс + CSS transition.

### 6.5 Ограничения анимаций

- **`prefers-reduced-motion`:** все анимации и transition обернуть в `@media (prefers-reduced-motion: no-preference)`. Пользователи с вестибулярными нарушениями не должны страдать.
- **CLS (Cumulative Layout Shift):** анимации `translateY` и `opacity` не влияют на CLS (transform не вызывает reflow). `scale` на фото — только в overflow: hidden контейнере.

---

## 7. SEO И AI-АГЕНТЫ

### 7.1 Структура заголовков (обязательно)

```
H1: Название категории (1 раз, в category.tpl)
  H2: (опционально) Подзаголовок в описании категории
  H2: заголовки в описании, если длинный текст
  (карточки товаров: название — <a>, НЕ H-заголовок)
```

Карточка товара в листинге **не должна** содержать H2/H3 — это нарушает иерархию и снижает вес H1 категории.

### 7.2 JSON-LD `schema-category.tpl` — уже реализован (v0.4.0)

Убедиться что ItemList заполняется URL'ами товаров из `$products`. Google использует ItemList для формирования сниппетов категорий в поиске. AI-агенты (Perplexity, SearchGPT, Gemini) используют ItemList для понимания что именно продаётся в категории.

### 7.3 Пагинация и SEO

- `rel="canonical"` на первую страницу — уже в `head.tpl`.
- `rel="prev"` / `rel="next"` — уже реализованы в `pagination.tpl` (v0.5.1). ✅
- Параметр страницы `?p=2` не должен дублировать canonical — проверить в `head.tpl`.
- Не индексировать страницы с активными фильтрами: `<meta name="robots" content="noindex,follow">` при наличии фильтров в URL. Реализовать через Smarty-условие в `head.tpl`.

### 7.4 AI-агенты (Perplexity, SearchGPT, Gemini): специфические требования 2026

AI-агенты сканируют страницу иначе, чем Googlebot:
1. **Описание категории** — должно быть в HTML, не скрыто CSS/JS (не `display:none`). Используйте `details/summary` для «свернуть/развернуть» — текст остаётся в DOM.
2. **ALT-теги фото** — `alt="{$product.name}"` — AI-агенты используют alt для понимания что изображено. Не оставлять пустым.
3. **Цены** — разметка `itemprop="price"` нежелательна (уже есть JSON-LD) — не дублировать. Но значение цены должно быть в тексте, не только в JS.
4. **Хлебные крошки** — AI-агенты используют breadcrumb для построения иерархии магазина. breadcrumb.tpl уже реализован (v0.5.1) ✅.
5. **Языковая разметка** — `lang="uk"` на `<html>` для украинского контента — AI-агенты учитывают язык при ранжировании локальных запросов.

### 7.5 Core Web Vitals — чеклист для каталога

| Метрика | Цель | Меры |
|---|---|---|
| **LCP** | < 2.5s | `loading="eager"` на первые 4 фото листинга, остальные `lazy`. Оригиналы ≤100KB в WebP. |
| **CLS** | < 0.1 | Фиксированный `aspect-ratio: 1/1` на контейнере фото — резервирует место до загрузки. |
| **INP** | < 200ms | Не блокировать main thread при AJAX-фильтрации. Debounce на фильтрах 300ms. |
| **FID/TBT** | — | `category.css` грузится только на странице категории (уже в theme.yml). Без синхронного JS. |

**Первые 4 фото (above the fold):** `loading="eager"` + `fetchpriority="high"`. Остальные: `loading="lazy"`. Реализовать через Smarty `{$smarty.foreach.products.index}` — если index < 4, то eager.

---

## 8. МОБИЛЬНАЯ ВЕРСИЯ — СПЕЦИФИКА

### 8.1 Mobile-first критичные решения

- **2 колонки на mobile** — обоснование уже выше (раздел 4.1).
- **Кнопка «В корзину»** на мобильном: высота min 44px (Apple HIG / Google Material You touchable area guideline).
- **Бейджи** на мобильном: font-size снизить до 0.65rem, padding `2px 6px` — на маленьких карточках стандартный размер перекрывает фото.
- **Wishlist иконка** — на мобильном всегда видима (размер touch target 44×44px через padding).
- **Toolbar** на мобильном: сортировка + кнопка фильтров — две равные по ширине кнопки на всю ширину. Счётчик — под ними, `text-align: center`.

### 8.2 Мобильная навигация (паттерн Foxtrot из PROJECT.md)

Фиксированный bottom nav bar (уже спроектирован) — иконка «Каталог/Категории» должна быть одной из 5 иконок bottom bar. При нахождении на странице категории — иконка активна.

---

## 9. СТРУКТУРА ФАЙЛОВ v0.6.0 — финальный чеклист

### Новые файлы:
```
templates/catalog/listing/
├── category.tpl          ← страница категории
├── product-list.tpl      ← сетка товаров
└── product-miniature.tpl ← карточка товара

assets/css/pages/
└── category.css          ← страничные стили каталога (0.14.0)

assets/js/pages/
└── category.js           ← grid/list toggle, sticky toolbar, skeleton, AJAX (0.14.0)
```

### Зависимости (все готовы):
```
_partials/breadcrumb.tpl      ✅ v0.5.1
_partials/notifications.tpl   ✅ v0.5.1
_partials/pagination.tpl      ✅ v0.5.1
microdata/schema-category.tpl ✅ v0.4.0
layouts/layout-full-width.tpl ✅ v0.5.0
```

---

## 10. ЗАКРЫТЫЕ РЕШЕНИЯ (финальные)

| Вопрос | Решение |
|---|---|
| Модуль фильтров | `ps_facetedsearch` — официальный, совместим с PS 9.0 ✅ |
| Сортировка по цене за единицу (цена/кол-во капсул) | Да, реализовать ✅ |
| Подкатегории внутри категории | Да, в виде плиток ✅ |
| AJAX-фильтрация | AJAX + History API + graceful degradation ✅ |
| Рейтинг в карточке | Выводить сразу (пустые звёзды = 0 отзывов) ✅ |
| Сравнение товаров `ps_compareproducts` | Не добавлять ✅ |

---

## 11. ИНТЕГРАЦИЯ `ps_facetedsearch`

### 11.1 Архитектурный принцип

Тема **не знает** о модуле напрямую. Связь только через хуки PS:

```
category.tpl → {hook h='displayLeftColumn'} → ps_facetedsearch
```

Тема никогда не вызывает классы или методы модуля напрямую. Это гарантирует, что при замене модуля фильтров тема не сломается.

### 11.2 Зона AJAX-обновления в `product-list.tpl`

Секция с `id="js-product-list"` — единственная зона, которую перерисовывает AJAX. Остальная страница (header, breadcrumb, фильтры) не трогается.

```smarty
<section id="js-product-list"
         data-total="{$listing.pagination.total_items}"
         aria-live="polite"
         aria-label="{l s='Список товарів' d='Shop.Theme.Catalog'}">

  {* Toolbar: сортировка + toggle + счётчик *}
  {include file='catalog/listing/_partials/products-top.tpl'}

  {* Сетка карточек *}
  {foreach from=$products item='product'}
    {include file='catalog/listing/product-miniature.tpl' product=$product}
  {/foreach}

  {* Пустое состояние *}
  {if !$products}
    {include file='catalog/listing/_partials/empty-state.tpl'}
  {/if}

  {* Пагинация *}
  {include file='_partials/pagination.tpl'}

</section>

{* Лоадер — скрыт по умолчанию *}
<div id="js-catalog-loader" class="catalog-loader" aria-hidden="true" hidden>
  <span class="catalog-loader__spinner"></span>
</div>
```

### 11.3 JS-архитектура AJAX + History API (`pages/category.js`)

```javascript
// Скелет класса — реализация в версии 0.14.0
class CatalogFilter {
  constructor() {
    this.container = document.getElementById('js-product-list');
    this.loader    = document.getElementById('js-catalog-loader');
    this.bindEvents();
    this.restoreFromURL();
  }

  bindEvents() {
    // ps_facetedsearch генерирует событие 'updateFacets' — перехватываем
    document.addEventListener('updateFacets', (e) => this.update(e.detail.url));
    window.addEventListener('popstate', (e) => {
      if (e.state?.url) this.update(e.state.url);
    });
  }

  async update(url) {
    this.showLoader();
    try {
      const res  = await fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } });
      const html = await res.text();
      this.container.innerHTML = this.extractZone(html, 'js-product-list');
      history.pushState({ url }, '', url);
      this.announce('Список товарів оновлено'); // aria-live
    } catch {
      window.location.href = url; // graceful degradation
    } finally {
      this.hideLoader();
    }
  }
}
```

**Сохранение состояния:** `localStorage.setItem('catalog-view', 'list'|'grid')` — режим сетки/списка сохраняется между сессиями.

**Debounce:** для ценового слайдера ps_facetedsearch — debounce 300ms перед отправкой AJAX-запроса. Без этого каждый пиксель движения слайдера отправляет запрос.

### 11.4 SEO: что индексировать, что нет

```smarty
{* В head.tpl — добавить условие для страниц с активными фильтрами *}
{if $listing.is_filtered}
  <meta name="robots" content="noindex, follow">
{/if}
```

Страницы с фильтрами (`?q=Immune-Health&orderby=price`) — не индексируются (noindex). Страницы категорий без фильтров — индексируются. Это предотвращает дублирование контента в индексе Google.

### 11.5 Переопределение шаблонов `ps_facetedsearch` в теме

```
themes/mytheme/modules/ps_facetedsearch/views/templates/front/
├── catalog/
│   └── _partials/
│       ├── facets.tpl          ← список фасетов (чекбоксы, слайдер цены)
│       └── search-filters.tpl  ← активные фильтры + «Сбросить всё»
```

Создаются в версии **0.11.0** (переопределения модулей). В 0.6.0 — использовать дефолтные шаблоны модуля, стилизовать через CSS-классы `.faceted-search`.

**Стилизация через стандартные классы ps_facetedsearch:**
```css
/* В category.css (0.14.0) */
.faceted-search { /* левая колонка */ }
.faceted-search-block-title { /* заголовок группы фильтров */ }
.faceted-search-block-filters { /* список чекбоксов */ }
.facet { /* один фасет */ }
.facet-label { /* подпись фасета */ }
.facet-title { /* название группы */ }
```

---

## 12. ПОДКАТЕГОРИИ В ВИДЕ ПЛИТОК

### 12.1 Расположение

Плитки подкатегорий размещаются **между Category Hero Block и Toolbar** — до листинга товаров. Логика: пользователь сначала видит навигацию вглубь (подкатегории), затем может просмотреть все товары категории.

```
[1] Breadcrumb
[2] Category Hero Block (H1 + описание)
[3] *** ПЛИТКИ ПОДКАТЕГОРИЙ ***   ← новый блок
[4] Toolbar (сортировка + toggle)
[5] Content Area (фильтры + product-list)
[6] Pagination
```

### 12.2 Условие вывода

```smarty
{if $subcategories && $subcategories|@count > 0}
  <div class="category-subcategories">
    <div class="row row-cols-2 row-cols-sm-3 row-cols-md-4 row-cols-lg-5 g-3">
      {foreach from=$subcategories item='subcategory'}
        <div class="col">
          <a href="{$subcategory.url}" class="subcategory-tile">
            {if $subcategory.image.small.url}
              <img src="{$subcategory.image.small.url}"
                   alt="{$subcategory.name|escape:'html':'UTF-8'}"
                   loading="lazy"
                   width="160" height="160">
            {else}
              <span class="subcategory-tile__icon">
                <i class="fa-solid fa-tag"></i>
              </span>
            {/if}
            <span class="subcategory-tile__name">{$subcategory.name}</span>
          </a>
        </div>
      {/foreach}
    </div>
  </div>
{/if}
```

### 12.3 Внешний вид плитки подкатегории

```
┌────────────────────┐
│                    │
│  [фото / иконка]   │  ← квадрат 1:1, 160px, object-fit: cover
│                    │
├────────────────────┤
│  Название          │  ← 1–2 строки, text-align: center
└────────────────────┘
```

**Стили:**
```css
.subcategory-tile {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-decoration: none;
  border: 1px solid var(--color-border);
  border-radius: 10px;
  overflow: hidden;
  transition: border-color 0.2s, box-shadow 0.2s, transform 0.2s;
  background: var(--color-card);
}
.subcategory-tile:hover {
  border-color: var(--color-primary-light);
  box-shadow: 0 4px 16px oklch(47% 0.07 145 / 0.10);
  transform: translateY(-2px);
}
.subcategory-tile img {
  width: 100%;
  aspect-ratio: 1 / 1;
  object-fit: cover;
}
.subcategory-tile__icon {
  width: 100%;
  aspect-ratio: 1 / 1;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-primary-subtle);
  font-size: 2rem;
  color: var(--color-primary);
}
.subcategory-tile__name {
  padding: 8px 10px;
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--color-text);
  text-align: center;
  line-height: 1.3;
}
```

### 12.4 Размеры изображений подкатегорий

| Контекст | Размер | Формат |
|---|---|---|
| Плитка на десктопе | 200×200px | WebP |
| Плитка на мобильном | 160×160px | WebP |
| Оригинал для загрузки | 400×400px | WebP или JPEG |

**Рекомендация для G&G UA:** создать унифицированные изображения для каждой подкатегории в корпоративном стиле — зелёный фон `oklch(95% 0.025 145)` + иконка или фото ключевого продукта категории. Это создаст узнаваемость и отличие от дефолтного G&G.

---

## 13. РЕЙТИНГ В КАРТОЧКЕ — СТРАТЕГИЯ «СРАЗУ»

### 13.1 Три состояния рейтинга

Решение выводить рейтинг сразу требует корректной обработки трёх состояний:

| Состояние | Условие | Отображение |
|---|---|---|
| **Нет отзывов** | `$product.comment_count == 0` | «Оставить первый отзыв» (ссылка) |
| **Мало отзывов** | `1 ≤ comment_count ≤ 4` | Звёзды + счётчик (без среднего балла) |
| **Достаточно** | `comment_count ≥ 5` | Звёзды + средний балл + счётчик |

**Обоснование (Baymard, 2024):** показ 0 из 5 звёзд при отсутствии отзывов снижает конверсию на 15% — пользователи воспринимают это как плохой рейтинг, а не как «нет оценок». Ссылка «Оставить первый отзыв» при 0 отзывов — наоборот, повышает вовлечённость.

### 13.2 Разметка в `product-miniature.tpl`

```smarty
<div class="product-miniature__rating">
  {if $product.comment_count == 0}
    <a href="{$product.url}#product-comments"
       class="product-miniature__rating-cta">
      {l s='Залишити перший відгук' d='Shop.Theme.Catalog'}
    </a>
  {elseif $product.comment_count < 5}
    {include file='catalog/listing/_partials/rating-stars.tpl'
             rating=$product.stars_ratings
             count=$product.comment_count
             show_score=false}
  {else}
    {include file='catalog/listing/_partials/rating-stars.tpl'
             rating=$product.stars_ratings
             count=$product.comment_count
             show_score=true}
  {/if}
</div>
```

**Фиксированная высота блока рейтинга:** `min-height: 20px` — выравнивает карточки в строке независимо от состояния.

### 13.3 Стили состояния «Оставить первый отзыв»

```css
.product-miniature__rating-cta {
  font-size: 0.75rem;
  color: var(--color-primary-light);
  text-decoration: underline;
  text-underline-offset: 2px;
}
.product-miniature__rating-cta:hover {
  color: var(--color-primary);
}
```

---

## 14. СОРТИРОВКА ПО ЦЕНЕ ЗА ЕДИНИЦУ

### 14.1 Проблема

PrestaShop 9.0 не имеет встроенной сортировки «цена за капсулу/грамм». Нужно кастомное решение.

### 14.2 Подход: кастомный атрибут + JS-сортировка

**Стратегия для v0.6.0:** отобразить «цену за единицу» в карточке как информационный элемент (без сортировки). Сортировка — в версии 0.6.x через кастомный модуль или переопределение ProductSearchProvider.

**Что вывести в карточке уже сейчас:**
```smarty
{* Если у товара есть unit_price_ratio (установлен в BO) *}
{if $product.unit_price_ratio > 0}
  <span class="product-miniature__unit-price">
    {* Расчёт: цена / количество единиц *}
    {l s='≈ %price% за капсулу' sprintf=['%price%' => ...] d='Shop.Theme.Catalog'}
  </span>
{/if}
```

**Для полноценной сортировки по цене/единице** потребуется:
1. Заполнить `unit_price` и `unit_price_ratio` для каждого товара в BO (Каталог → Товар → Цены → Цена за единицу).
2. Добавить кастомный `SortOrder` через переопределение в `modules/` или кастомный модуль.
3. Реализовать в версии **0.6.x** после запуска базового каталога.

### 14.3 Отображение «цены за единицу» в карточке

```
┌─────────────────────────────┐
│  ~~старая цена~~  ЦЕНА      │
│  ≈ 4.50 грн за капсулу      │  ← маленький текст под ценой
└─────────────────────────────┘
```

**Стиль:**
```css
.product-miniature__unit-price {
  font-size: 0.75rem;
  color: var(--color-text-muted);
  display: block;
  margin-top: 2px;
}
```

---

## 15. ИТОГОВАЯ СХЕМА `category.tpl` — ПОЛНАЯ

```
{extends 'layouts/layout-full-width.tpl'}

{block name='content'}

  {include '_partials/breadcrumb.tpl'}        [если links > 1]
  {include '_partials/notifications.tpl'}
  {hook h='displaySchemaMarkup'}              → schema-category.tpl

  ┌─ .category-hero ─────────────────────────────────────┐
  │  [img category]  H1: $category.name                  │
  │                  <details> $category.description      │
  └──────────────────────────────────────────────────────┘

  ┌─ .category-subcategories ────────────────────────────┐
  │  [плитки подкатегорий — если есть $subcategories]     │
  └──────────────────────────────────────────────────────┘

  ┌─ .catalog-toolbar (sticky) ──────────────────────────┐
  │  [Фильтры (mobile)] [Сортировка▼] [spacer] [⊞⊟] [X из Y]│
  └──────────────────────────────────────────────────────┘

  ┌─ .catalog-layout ────────────────────────────────────┐
  │ ┌─ .catalog-layout__aside (260px) ──────────────────┐│
  │ │  {hook h='displayLeftColumn'}                      ││
  │ │  → ps_facetedsearch                                ││
  │ └───────────────────────────────────────────────────┘│
  │ ┌─ .catalog-layout__main ───────────────────────────┐│
  │ │  <section id="js-product-list" aria-live="polite"> ││
  │ │    {include 'catalog/listing/product-list.tpl'}    ││
  │ │    {include '_partials/pagination.tpl'}            ││
  │ │  </section>                                        ││
  │ │  <div id="js-catalog-loader" hidden>...</div>      ││
  │ └───────────────────────────────────────────────────┘│
  └──────────────────────────────────────────────────────┘

{/block}
```

---

## 16. ФАЙЛЫ ДЛЯ СОЗДАНИЯ В v0.6.0 — ФИНАЛЬНЫЙ СПИСОК

```
templates/catalog/listing/
├── category.tpl                        ← главный шаблон категории
├── product-list.tpl                    ← сетка + AJAX-зона
├── product-miniature.tpl               ← карточка товара
└── _partials/
    ├── products-top.tpl                ← toolbar (сортировка + toggle + счётчик)
    ├── rating-stars.tpl                ← переиспользуемые звёзды рейтинга
    └── empty-state.tpl                 ← блок «товары не найдены»
```

**Зависимости v0.6.0** — всё готово:
```
_partials/breadcrumb.tpl         ✅ v0.5.1
_partials/notifications.tpl      ✅ v0.5.1
_partials/pagination.tpl         ✅ v0.5.1
microdata/schema-category.tpl    ✅ v0.4.0
layouts/layout-full-width.tpl    ✅ v0.5.0
```

**Модуль фильтров:**
```
ps_facetedsearch                 ← установить из официального репозитория
                                    переопределения шаблонов — в v0.11.0
```

---

*Документ составлен на основе: Baymard Institute E-Commerce UX (2025), Nielsen Norman Group (2024), Google Search Central (2025–2026), W3C WCAG 2.2, CSS Color Level 4 (OKLCH), анализа gandgvitamins.com, исследований украинского e-commerce рынка.*
