# Рекомендации по разработке карточки товара v0.7.0
## PrestaShop 9.0 — mytheme | G&G Vitamins UA
**Актуально:** март 2026 | Ниша: дієтичні добавки, вітаміни, мінерали | Ассортимент: 300+

> Документ является продолжением `CATALOG-0.6.0-recommendations.md`.
> Читать вместе с `PROJECT.md`, `CHANGELOG.md` и `ps9_categories.md`.
>
> **Обновление v0.7.0 (март 2026):** добавлены разделы по Google Product Search 2025–2026,
> AI-агентам, украинским правовым требованиям, специфике категорий G&G,
> требованиям к Supplement Facts и нотификации ДПСС.

---

## 1. СТРАТЕГИЧЕСКИЕ РЕШЕНИЯ (принятые до написания кода)

### 1.1 Layout страницы товара

**Решение: двухколоночный layout + вертикально раскрытые секции (Collapsed Sections).**

```
Desktop (≥992px):
┌──────────────────────────┬─────────────────────────────┐
│   Галерея (левая, 55%)   │   Покупательская панель (45%)│
│   sticky при скролле     │   название, рейтинг, варианты│
│   до начала инфо-блоков  │   цена, кнопка, доставка     │
└──────────────────────────┴─────────────────────────────┘
│              Информационные секции (full width)          │
│   [Опис] [Склад] [Застосування] [Сертифікати] [FAQ]     │
│   Вертикально раскрытые, не горизонтальные табы         │
└─────────────────────────────────────────────────────────┘
│                  Відгуки (full width)                    │
└─────────────────────────────────────────────────────────┘
│              Схожі товари (full width)                   │
└─────────────────────────────────────────────────────────┘
```

**Почему НЕ горизонтальные табы (Baymard Institute, 2025):**
- 27% пользователей полностью пропускают содержимое горизонтальных вкладок при навигации по странице товара.
- При вертикально раскрытых секциях число пользователей, пропустивших контент, — лишь 8%.
- Google может не индексировать контент, скрытый в горизонтальных табах через CSS `display:none`.
- **Для G&G критично:** покупатели БАДов активно ищут состав и способ применения — если они в табах, их пропускают.

**Мобильный layout (<992px):**
```
[Галерея — полная ширина, swipe]
[Покупательская панель]
[Информационные секции — accordion]
[Відгуки]
[Схожі товари]
[Sticky bottom bar: ціна + «До кошика»]
```

---

### 1.2 Sticky элементы

**Desktop:** галерея прилипает (`position: sticky`) при скролле вниз, пока пользователь читает описание. Когда скролл достигает начала информационных секций — галерея «отлипает».

**Mobile:** sticky bottom bar фиксирован внизу экрана. Содержит: текущая цена + кнопка «До кошика» (или «Обрати варіант»). Появляется через 200px скролла от начала страницы (JS IntersectionObserver).

---

## 2. ГАЛЕРЕЯ ФОТО — `product-images.tpl`

### 2.1 Навигация по галерее

**Решение: миниатюры слева (вертикальная колонка) на десктопе. Swipe + точки-индикаторы на мобильном.**

Обоснование:
- Nielsen Norman Group (2024): вертикальная колонка миниатюр слева — лучший pattern для 4–6 фото.
- Миниатюры снизу (strip) занимают вертикальное пространство и конкурируют с кнопкой «До кошика» за видимость.

**Размеры миниатюр:**
- Ширина колонки: 80px
- Размер одной миниатюры: 72×72px
- Активная миниатюра: `border: 2px solid var(--color-primary)`
- Gap между миниатюрами: 6px

**Главное фото:**
- Контейнер: `aspect-ratio: 1/1`
- Изображение: `thickbox_default` (800×800px)
- `object-fit: contain` — упаковки G&G не обрезаются
- Белый фон (`var(--color-card)`)

### 2.2 Обязательные типы фото для G&G (Baymard, 2025)

Baymard (2025) специально выделяет нутрицевтику в отдельный сценарий: фото этикетки с составом (Supplement Facts) является критическим для покупательского решения — пользователи ищут её в галерее.

| № | Тип фото | Описание | Приоритет |
|---|---|---|---|
| 1 | Упаковка фронт | Главное фото, белый фон | **Обязательно** |
| 2 | **Supplement Facts** | Этикетка с составом — текст читаемый! | **Обязательно** |
| 3 | Упаковка тыл / боковая | Обратная сторона упаковки | **Обязательно** |
| 4 | Lifestyle | Продукт в контексте (здоровый человек) | Желательно |
| 5 | Нотифікація ДПСС | Скан свидетельства МОЗ Украины | Желательно |
| 6 | Содержимое | Фото капсул/порошка (без упаковки) | Желательно |

**⚠️ Supplement Facts — технические требования:**
- Фото снято прямо (не под углом)
- Минимум 1500×1500px в оригинале — текст должен читаться без зума
- Для мобильных: пользователь должен иметь возможность pinch-to-zoom

### 2.3 Зум и Lightbox

**Решение:** клик открывает нативный `<dialog>` lightbox. Hover-зум через CSS `transform: scale()`.

```html
<dialog class="product-lightbox" id="js-product-lightbox"
        aria-label="Повноекранний перегляд фото">
  <div class="product-lightbox__inner">
    <button class="product-lightbox__close" aria-label="Закрити">
      <i class="fa-solid fa-xmark" aria-hidden="true"></i>
    </button>
    <button class="product-lightbox__prev" aria-label="Попереднє фото">
      <i class="fa-solid fa-chevron-left" aria-hidden="true"></i>
    </button>
    <div class="product-lightbox__stage">
      <img class="product-lightbox__img" src="" alt="" id="js-lightbox-img">
    </div>
    <button class="product-lightbox__next" aria-label="Наступне фото">
      <i class="fa-solid fa-chevron-right" aria-hidden="true"></i>
    </button>
  </div>
</dialog>
```

```css
.product-lightbox::backdrop {
  background: oklch(10% 0 0 / 0.92);
  backdrop-filter: blur(4px);
}
.product-lightbox {
  border: none;
  border-radius: var(--radius-lg);
  max-width: min(90vw, 900px);
  max-height: 90vh;
  padding: 0;
  overflow: hidden;
}
```

```javascript
// product.js — открытие/закрытие
const lightbox = document.getElementById('js-product-lightbox');
lightbox.showModal();   // открыть
lightbox.close();       // закрыть (Esc — нативно)
lightbox.addEventListener('click', (e) => {
  if (e.target === lightbox) lightbox.close();
});
```

### 2.4 Размеры изображений PS9

| Тип PS9 | Размер | Использование |
|---|---|---|
| `home_default` | 250×250 | Карточка в листинге mobile |
| `medium_default` | 452×452 | Карточка в листинге desktop |
| `large_default` | 800×800 | Главное фото страницы товара |
| `thickbox_default` | 800×800 | Lightbox / зум |
| `cart_default` | 125×125 | Корзина, offcanvas cart |

**Рекомендуемый оригинал:** 1200×1200px, WebP, качество 85–90%.
Для Supplement Facts: минимум 1500×1500px.

### 2.5 Мобильная галерея

- Swipe: CSS `scroll-snap-type: x mandatory`
- Точки-индикаторы под галереей: активная — `var(--color-primary)`, остальные — `var(--color-border)`
- Нет миниатюр на мобильном
- `aspect-ratio: 1/1`, полная ширина экрана

---

## 3. ПОКУПАТЕЛЬСКАЯ ПАНЕЛЬ — правая колонка desktop

### 3.1 Порядок элементов (сверху вниз)

```
[1]  Хлебные крошки (категорія > назва товару)
[2]  Название товара — H1
[3]  Рейтинг + счётчик отзывов → якорь #product-reviews
[4]  Артикул (Product Code G&G: GA651...)
[5]  Серия / Лінійка (тег: SOOV / Kids Rainbow / Cal-M)
[6]  Цена (текущая + старая + % скидки)
[7]  Цена за единицу (грн за капсулу)
[8]  Метки доверия: Made in England 🇬🇧 | Нотифікація ДПСС ✓
[9]  ─── Варианты упаковки (если есть) ───
[10] Количество + кнопка «До кошика»
[11] Wishlist + Share
[12] Доставка / наличие
[13] Гарантии: иконки (повернення / оплата / підтримка)
```

### 3.2 H1 и SEO

- Единственный `<h1>` на странице = `$product.name`
- На украинском языке (требование закона)
- Не содержит «купити» в H1 — антипаттерн для нутрицевтики
- `$product.name` в PS9: заполнять на украинском, транслитерация торговых марок сохраняется

### 3.3 Рейтинг

```html
<!-- формат: ★★★★☆ 4.2 (17 відгуків) -->
<a href="#product-reviews" class="product-rating-link">
  {include file='catalog/listing/_partials/rating-stars.tpl' ...}
  <span class="product-rating__score">{$product.stars_ratings|string_format:"%.1f"}</span>
  <span class="product-rating__count">({$product.comment_count} відгуків)</span>
</a>
```

При 0 отзывов: `<a href="#product-reviews">Залишити перший відгук</a>`.

### 3.4 Тег серии (лінійки)

Визуальный тег над H1 или рядом с артикулом:

```css
.product-line-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  font-size: 0.75rem;
  font-weight: 700;
  padding: 3px 10px;
  border-radius: var(--radius-pill);
  margin-bottom: 0.5rem;
}
.product-line-badge--soov {
  background: oklch(88% 0.09 340);
  color: oklch(30% 0.18 340);
}
.product-line-badge--kids {
  background: oklch(92% 0.07 145);
  color: oklch(28% 0.12 145);
}
.product-line-badge--calM {
  background: oklch(92% 0.05 200);
  color: oklch(28% 0.10 200);
}
.product-line-badge--totalFitness {
  background: oklch(88% 0.12 85);
  color: oklch(28% 0.14 85);
}
```

### 3.5 Доверительные метки (Trust Badges)

```
[🇬🇧 Виготовлено у Великій Британії]
[✓ Нотифіковано МОЗ України]
[🌿 Без наповнювачів та зв'язуючих]
[🐰 Не тестовано на тваринах]  ← если применимо
```

**Реализация:** горизонтальный flex-контейнер с иконками и текстом. FA7 иконки или SVG. Цвет: `var(--color-text-muted)`. Font-size: 0.8rem.

---

## 4. ЦЕНЫ — `product-prices.tpl`

### 4.1 Структура блока цен

```
┌─────────────────────────────────────┐
│  ~~1 200 грн~~   980 грн     -18%   │  ← старая + новая + % скидки
│  ≈ 16.33 грн за капс. (60 шт.)      │  ← цена за единицу
└─────────────────────────────────────┘
```

```css
.product-prices__current {
  font-size: clamp(1.5rem, 2.5vw, 2rem);
  font-weight: 800;
  color: var(--color-text);
}
.product-prices__current--discounted {
  color: var(--color-discount);
}
.product-prices__old {
  font-size: 1rem;
  font-weight: 400;
  color: var(--color-text-secondary);
  text-decoration: line-through;
}
.product-prices__discount-percent {
  display: inline-block;
  background: var(--color-discount);
  color: #fff;
  font-size: 0.875rem;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: var(--radius-sm);
  margin-left: 0.5rem;
}
.product-prices__unit {
  font-size: 0.875rem;
  color: var(--color-text-muted);
  margin-top: 4px;
}
```

### 4.2 Цена за единицу — стратегия G&G

Для G&G особенно важна «цена за капсулу» — покупатель сравнивает упаковки 60 и 120 капсул одного продукта.

**Заполнять в PS9 BO (Каталог → Товары → Цены):**
- `unit_price` — цена за 1 единицу (капсулу/грамм)
- `unit_price_ratio` — коэффициент
- `unity` — единица измерения: «капсула», «г», «мл»

**Отображение:**
```smarty
{if $product.unit_price_ratio > 0}
  <div class="product-prices__unit">
    ≈ {$product.unit_price} грн за {$product.unity}
    {if $product.unity == 'капсула'}
      ({$product.quantity_wanted * $product.unit_price_ratio|round:0} капс. в уп.)
    {/if}
  </div>
{/if}
```

---

## 5. КНОПКА «ДО КОШИКА» — `product-add-to-cart.tpl`

### 5.1 Три состояния кнопки

| Состояние | Текст | Стиль |
|---|---|---|
| Простой товар | «До кошика» | `--color-btn-cart` — зелёный |
| Есть комбинации | «Обрати варіант» | `--color-primary-light` — светло-зелёный |
| Нет в наличии | «Немає в наявності» | disabled, серый |

### 5.2 Quantity Stepper (выбор количества)

```html
<div class="product-qty-stepper">
  <button class="product-qty-stepper__btn" aria-label="Зменшити кількість"
          data-action="decrement">
    <i class="fa-solid fa-minus" aria-hidden="true"></i>
  </button>
  <input type="number" name="qty" id="quantity_wanted"
         class="product-qty-stepper__input"
         value="{$product.quantity_wanted}" min="1" max="{$product.quantity}"
         aria-label="Кількість товару">
  <button class="product-qty-stepper__btn" aria-label="Збільшити кількість"
          data-action="increment">
    <i class="fa-solid fa-plus" aria-hidden="true"></i>
  </button>
</div>
```

```css
.product-qty-stepper {
  display: flex;
  align-items: center;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-base);
  overflow: hidden;
  width: fit-content;
}
.product-qty-stepper__input {
  width: 56px;
  text-align: center;
  border: none;
  padding: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  -moz-appearance: textfield;
}
.product-qty-stepper__input::-webkit-outer-spin-button,
.product-qty-stepper__input::-webkit-inner-spin-button { display: none; }
.product-qty-stepper__btn {
  background: var(--color-primary-subtle);
  border: none;
  padding: 0.5rem 0.875rem;
  cursor: pointer;
  color: var(--color-primary);
  transition: background 0.15s;
}
.product-qty-stepper__btn:hover { background: var(--color-primary-xsubtle); }
```

### 5.3 Кнопка — полная ширина

```css
.product-add-to-cart__btn {
  display: block;
  width: 100%;
  padding: 0.875rem 1.5rem;
  font-size: 1rem;
  font-weight: 700;
  border: none;
  border-radius: var(--radius-base);
  cursor: pointer;
  background: var(--color-btn-cart);
  color: var(--color-btn-cart-text);
  transition: background 0.15s, transform 0.1s;
}
.product-add-to-cart__btn:hover:not(:disabled) {
  background: var(--color-btn-cart-hover);
  transform: translateY(-1px);
}
.product-add-to-cart__btn:disabled {
  background: var(--color-border);
  color: var(--color-text-muted);
  cursor: not-allowed;
}
```

---

## 6. ИНФОРМАЦИОННЫЕ СЕКЦИИ (product-info-sections)

### 6.1 Структура и порядок

```html
<!-- Раскрытые секции (не табы) -->
<div class="product-info-sections">

  <!-- 1. Опис -->
  <section class="product-section" id="product-description">
    <h2 class="product-section__title">Опис</h2>
    <div class="product-section__body">
      {$product.description nofilter}
    </div>
  </section>

  <!-- 2. Склад та харчова цінність -->
  <section class="product-section" id="product-composition">
    <h2 class="product-section__title">Склад та харчова цінність</h2>
    <div class="product-section__body">
      {* Supplement Facts фото + таблица состава *}
    </div>
  </section>

  <!-- 3. Спосіб застосування -->
  <section class="product-section" id="product-usage">
    <h2 class="product-section__title">Спосіб застосування та дозування</h2>
    <div class="product-section__body">
      {$product.description_short nofilter}
      {* Хранить "Спосіб застосування" в description_short (обход лимита 255 в Features) *}
    </div>
  </section>

  <!-- 4. Обязательный дисклеймер (закон Украины) -->
  <section class="product-section product-section--warning" id="product-warnings">
    <h2 class="product-section__title">⚠️ Застереження</h2>
    <div class="product-section__body">
      <p>Дієтична добавка. Не є лікарським засобом. Не перевищуйте рекомендовану добову дозу.
      Зберігати в недоступному для дітей місці. Проконсультуйтесь з лікарем перед застосуванням.</p>
      {* + специфические предупреждения из Feature 'Умови зберігання' *}
    </div>
  </section>

  <!-- 5. Деталі та характеристики -->
  <section class="product-section" id="product-details">
    <h2 class="product-section__title">Деталі та характеристики</h2>
    <div class="product-section__body">
      {* PS9 Features: нотификація, виробник, штрихкод, EAN... *}
      {include file='catalog/_partials/product-features.tpl'}
    </div>
  </section>

  <!-- 6. Виробник та представник -->
  <section class="product-section" id="product-manufacturer">
    <h2 class="product-section__title">Виробник та офіційний представник</h2>
    <div class="product-section__body">
      <p><strong>Виробник:</strong> G&G Vitamins Ltd, Велика Британія</p>
      <p><strong>Офіційний представник в Україні:</strong> [назва компанії], [адреса]</p>
      <p><strong>Імпортер:</strong> [дані імпортера — вимога закону]</p>
    </div>
  </section>

  <!-- 7. Сертифікати -->
  <section class="product-section" id="product-certificates">
    <h2 class="product-section__title">Сертифікати та документи</h2>
    <div class="product-section__body">
      {* Нотифікація МОЗ + фото сертификата *}
    </div>
  </section>

  <!-- 8. Відеоогляд (если есть) -->
  {if isset($product.video_url) && $product.video_url}
  <section class="product-section" id="product-video">
    <h2 class="product-section__title">Відеоогляд</h2>
    <div class="product-section__body">
      {* Lazy iframe — загружается только по клику *}
    </div>
  </section>
  {/if}

  <!-- 9. FAQ -->
  <section class="product-section" id="product-faq">
    <h2 class="product-section__title">Часті запитання</h2>
    <div class="product-section__body">
      {* schema-faq.tpl уже реализован в v0.4.0 *}
      {hook h='displaySchemaMarkup'}
    </div>
  </section>

</div>
```

### 6.2 CSS для секций (collapsed по умолчанию на mobile)

```css
.product-section {
  border-bottom: 1px solid var(--color-border);
  padding: 1.5rem 0;
}

.product-section__title {
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--color-text);
  margin-bottom: 1rem;
}

/* На мобильном — аккордеон */
@media (max-width: 991px) {
  .product-section__title {
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    margin-bottom: 0;
    padding-bottom: 1rem;
  }
  .product-section__title::after {
    content: '';
    display: block;
    width: 20px;
    height: 20px;
    background-image: url("data:image/svg+xml,..."); /* FA7 chevron-down */
    transition: transform 0.2s;
  }
  .product-section.is-open .product-section__title::after {
    transform: rotate(180deg);
  }
  .product-section__body {
    display: none;
  }
  .product-section.is-open .product-section__body {
    display: block;
  }
}
```

### 6.3 Обход лимита 255 символов в Features (PS9)

Поле «Спосіб застосування» часто длиннее 255 символов. Решение:

- Хранить в `$product.description_short` (поле «Короткий опис» в BO) — поддерживает HTML.
- Семантически переиспользовать это поле только для «Спосіб застосування».
- В шаблоне секции «Опис»: `{$product.description nofilter}`
- В шаблоне секции «Спосіб застосування»: `{$product.description_short nofilter}`

---

## 7. CHARACTERISTICS (FEATURES) PS9 — СТРУКТУРА ДЛЯ G&G

### 7.1 Создать в BO → Каталог → Характеристики

| Характеристика (назва) | Пример значения | Где выводить |
|---|---|---|
| Спосіб застосування | «1 капсула на день під час їжі» | Секція «Спосіб застосування» |
| Добова доза | «1 капсула» | Секція «Деталі» |
| Форма випуску | «Веганські капсули» | Секція «Деталі» + фильтры |
| Кількість у упаковці | «60 капсул» | Покупательська панель + название |
| Умови зберігання | «При t° до 25°C, сухе місце» | Секція «Застереження» |
| Термін придатності | «Дивіться на упаковці» | Секція «Деталі» |
| Виробник | «G&G Vitamins Ltd, Велика Британія» | Секція «Виробник» |
| Країна виробництва | «Велика Британія» | Покупательська панель |
| Нотифікація ДПСС | «№ МОЗ України ...» | Секція «Деталі» + мета |
| Product Code | «GA651» | Покупательська панель |
| Штрихкод EAN | «5060327540123» | Секція «Деталі» |
| Серія | «SOOV / Kids Rainbow Food / Cal-M / G&G Classic» | Тег лінійки + фильтры |
| Цільова аудиторія | «Жінки / Чоловіки / Діти / 50+» | Фильтры + секція «Деталі» |
| Веган | «Так» | Тег + фильтры |
| Органічний | «Так» | Тег + фильтры |

### 7.2 Таблица характеристик в секции «Деталі»

```smarty
{if $product.features}
<table class="product-features-table">
  {foreach from=$product.features item=feature}
    {* Пропускаем 'Спосіб застосування' — он в отдельной секции *}
    {if $feature.name !== 'Спосіб застосування'}
    <tr>
      <th class="product-features-table__key">{$feature.name}</th>
      <td class="product-features-table__val">{$feature.value}</td>
    </tr>
    {/if}
  {/foreach}
</table>
{/if}
```

```css
.product-features-table { width: 100%; border-collapse: collapse; }
.product-features-table tr { border-bottom: 1px solid var(--color-border); }
.product-features-table__key {
  width: 40%;
  padding: 0.625rem 0;
  font-weight: 600;
  color: var(--color-text-secondary);
  font-size: 0.875rem;
  vertical-align: top;
}
.product-features-table__val {
  padding: 0.625rem 0 0.625rem 1rem;
  color: var(--color-text);
  font-size: 0.875rem;
}
```

---

## 8. МИКРОРАЗМЕТКА — СТРАНИЦА ТОВАРА

### 8.1 Schema.org Product (уже реализован в schema-product.tpl v0.4.0)

Убедиться, что содержит все поля для Google Shopping 2025–2026:

```json
{
  "@type": "Product",
  "name": "...",
  "description": "...",
  "image": ["url1", "url2"],
  "brand": {
    "@type": "Brand",
    "name": "G&G Vitamins"
  },
  "sku": "GA651",
  "gtin13": "5060327540123",
  "offers": {
    "@type": "Offer",
    "price": "980",
    "priceCurrency": "UAH",
    "availability": "https://schema.org/InStock",
    "url": "...",
    "seller": {
      "@type": "Organization",
      "name": "..."
    }
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "17"
  }
}
```

**Новое в Google Product Search 2025–2026:**
- `gtin13` (EAN) — обязателен для Google Shopping. Хранить в Feature «Штрихкод EAN».
- `brand` — обязателен. Всегда «G&G Vitamins».
- `countryOfOrigin` — рекомендован. Великобритания.
- `offers.priceValidUntil` — рекомендован для акционных товаров.

### 8.2 FAQ Schema (schema-faq.tpl v0.4.0)

Реализован. На страницах товаров G&G рекомендуемые FAQ:

```
Q: Чи підходить цей продукт веганам?
A: [Так/Ні — из характеристик]

Q: Скільки капсул у упаковці?
A: [Із характеристик]

Q: Чи нотифікований препарат МОЗ України?
A: [Так, свідоцтво № ...]

Q: Чи є цей продукт офіційним G&G Vitamins?
A: Так, ми офіційний представник G&G Vitamins Ltd (Велика Британія) в Україні.
```

### 8.3 AI-агенты и страница товара

Для AI-агентов (Perplexity, ChatGPT Search, Gemini) критически важны:

1. **JSON-LD Product** — читается в первую очередь.
2. **Описание товара** — должно содержать ключевые факты: назначение, состав, дозировка. Без «воды».
3. **FAQ Schema** — AI-агенты активно используют FAQ для формирования ответов.
4. **Секция «Склад»** — текстовое описание состава (не только фото!) — парсится AI для ответов «що входить до складу...».

**Рекомендация:** добавить в `$product.description` (описание) структурированный текст:
```
[Назва] — [короткое определение, 1 предложение].
[Основной эффект / для чего]. [Ключевые ингредиенты].
Виготовлено G&G Vitamins Ltd (Велика Британія) без наповнювачів.
```

---

## 9. SECTION «ВІДГУКИ» — РЕЙТИНГОВАЯ РАЗБИВКА

### 9.1 Distribution Bar (новый паттерн, 2025)

Baymard (2025): показ distribution bar (сколько отзывов на каждую звёзду) повышает доверие к рейтингу на 34%. Особенно важно при малом количестве отзывов.

```html
<div class="product-reviews-summary">
  <div class="product-reviews-summary__score">
    <span class="product-reviews-summary__avg">4.8</span>
    <div class="product-reviews-summary__stars">
      {include file='catalog/listing/_partials/rating-stars.tpl' ...}
    </div>
    <span class="product-reviews-summary__count">17 відгуків</span>
  </div>

  <div class="product-reviews-summary__bars">
    {* Distribution bars: 5☆ / 4☆ / 3☆ / 2☆ / 1☆ *}
    {foreach item=bar from=[5,4,3,2,1]}
    <div class="review-bar">
      <span class="review-bar__label">{$bar}☆</span>
      <div class="review-bar__track">
        <div class="review-bar__fill" style="width: {$bar_percent}%"></div>
      </div>
      <span class="review-bar__count">{$bar_count}</span>
    </div>
    {/foreach}
  </div>
</div>
```

### 9.2 Модуль ps_productcomments

Модуль критически важен — без него нет `AggregateRating` в JSON-LD.

```smarty
{* Секция отзывов *}
<section id="product-reviews" class="product-section">
  <h2 class="product-section__title">Відгуки</h2>
  <div class="product-section__body">
    {include file='catalog/_partials/product-reviews-summary.tpl'} {* distribution bar *}
    {hook h='displayProductTabContent'}   {* → ps_productcomments *}
    <a href="#product-reviews" class="btn btn-outline-primary">
      {l s='Написати відгук' d='Shop.Theme.Catalog'}
    </a>
  </div>
</section>
```

---

## 10. СХОЖІ ТОВАРИ — `product-related`

### 10.1 Логика подбора «схожих товаров» для G&G

Стандартный PS9 подбирает «похожие» по категории. Для G&G нужна кастомная логика:

**Приоритет отображения:**
1. Товары из той же подкатегории (например, все формы Магния для страницы Mg Bisglycinate)
2. Товары из той же серии (SOOV, Cal-M, Kids Rainbow)
3. Товары, часто покупаемые вместе (cross-sell — если есть данные)
4. Другие товары из той же основной категории

**Заголовки секции по ситуации:**
- Стандарт: «Схожі товари»
- Для SOOV: «Інші продукти лінійки SOOV»
- Для Магния: «Інші форми магнію»
- Для Daily Packs: «Також вас може зацікавити»

### 10.2 Горизонтальный scroll-snap

```css
.product-related__scroll {
  display: flex;
  gap: 1rem;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  scrollbar-width: none;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 0.5rem;
}
.product-related__scroll .col {
  flex: 0 0 calc(25% - 0.75rem); /* 4 карточки desktop */
  scroll-snap-align: start;
}
@media (max-width: 991px) {
  .product-related__scroll .col {
    flex: 0 0 calc(50% - 0.5rem);
  }
}
@media (max-width: 575px) {
  .product-related__scroll .col {
    flex: 0 0 calc(60% - 0.5rem); /* неполная карточка = «есть ещё» */
  }
}
```

---

## 11. STICKY BOTTOM BAR (mobile)

```html
<div class="product-sticky-bar" id="js-product-sticky-bar" hidden>
  <div class="product-sticky-bar__price">
    <span class="product-sticky-bar__current">{$product.price}</span>
    {if $product.has_discount}
      <span class="product-sticky-bar__old">{$product.regular_price}</span>
    {/if}
  </div>
  <button class="product-sticky-bar__btn btn" id="js-sticky-add-to-cart">
    {if $product.add_to_cart_url}
      {l s='До кошика' d='Shop.Theme.Catalog'}
    {else}
      {l s='Обрати варіант' d='Shop.Theme.Catalog'}
    {/if}
  </button>
</div>
```

```css
.product-sticky-bar {
  position: fixed;
  bottom: var(--mobile-bottom-nav-height);  /* выше bottom nav bar */
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem 1rem;
  padding-bottom: calc(0.75rem + env(safe-area-inset-bottom));
  background: var(--color-card);
  box-shadow: 0 -2px 12px oklch(22% 0.02 145 / 0.12);
}

@media (min-width: 992px) {
  .product-sticky-bar { display: none !important; }
}
```

```javascript
// product.js — появление sticky bar при скролле
const addToCartBtn = document.querySelector('.product-add-to-cart__btn');
const stickyBar = document.getElementById('js-product-sticky-bar');

const observer = new IntersectionObserver(([entry]) => {
  stickyBar.hidden = entry.isIntersecting;
}, { rootMargin: '0px 0px -80px 0px' });

if (addToCartBtn) observer.observe(addToCartBtn);
```

---

## 12. УКРАИНСКИЕ ПРАВОВЫЕ ТРЕБОВАНИЯ — СТРАНИЦА ТОВАРА

### 12.1 Обязательные элементы (Закон України № 4122-IX)

| Элемент | Где разместить | Формат |
|---|---|---|
| Назва продукту | H1, украинский язык | «Вітамін D3 1000 МО — 120 веганських капсул» |
| Склад | Секція «Склад» | Повный перечень ингредиентов |
| Харчова цінність | Секція «Склад» | Таблица (или фото Supplement Facts) |
| Спосіб застосування | Секція «Застосування» | Дозировка, кратность |
| Застереження | Секція «Застереження» | Обязательный текст |
| Виробник | Секція «Виробник» | Полное название + страна |
| Імпортер/представник | Секція «Виробник» | Название + адрес в Украине |
| Нотифікація ДПСС | Feature «Нотифікація» + Секція «Деталі» | «№ МОЗ України ...» |
| Умови зберігання | Feature + Секція «Застереження» | t°, влажность |
| Термін придатності | Feature + Секція «Деталі» | «Дивіться на упаковці» |

### 12.2 Дисклеймер (обязательный текст)

На каждой странице товара — БАД:
```
Дієтична добавка до раціону. Не є лікарським засобом і не призначена для діагностики,
лікування або профілактики захворювань. Не перевищуйте рекомендовану добову дозу.
Проконсультуйтесь з лікарем перед застосуванням. Зберігати в недоступному для дітей місці.
```

Размещение: в секции «⚠️ Застереження» (обязательная секция, всегда открыта).

---

## 13. CORE WEB VITALS — СТРАНИЦА ТОВАРА

### 13.1 LCP (Largest Contentful Paint) — цель ≤ 2.5s

LCP на странице товара = главное фото (hero image).

**Обязательно:**
```html
<!-- Главное фото товара — EAGER + HIGH PRIORITY -->
<img src="{$product.cover.large.url}"
     alt="{$product.name|escape:'html'}"
     width="800" height="800"
     fetchpriority="high"
     loading="eager"
     decoding="async">
```

**Дополнительно:**
- `<link rel="preload" as="image" href="{$product.cover.large.url}">` в `{block head_extra}` — предзагрузка главного фото.
- Оригинал: WebP, качество 85%, максимум 150KB после оптимизации.

### 13.2 CLS (Cumulative Layout Shift) — цель ≤ 0.1

- `aspect-ratio: 1/1` на контейнере галереи — место резервируется до загрузки.
- Sticky bottom bar — `position: fixed`, не влияет на layout.
- Шрифты: `font-display: swap` в `@font-face`.

### 13.3 INP (Interaction to Next Paint) — цель ≤ 200ms

- Кнопка «До кошика» — обработчик через `addEventListener('click')`, не через `onclick`.
- AJAX добавление в корзину — PS9 нативный через `prestashop.emit('updateCart')`.
- Accordion секций — CSS-only через `details/summary` или минимальный JS.

---

## 14. SEO СТРАНИЦЫ ТОВАРА — GOOGLE 2025–2026

### 14.1 Meta tags

```smarty
{block name='head_extra'}
  {* Title: Название + основной атрибут + бренд *}
  {* «Вітамін D3 1000 МО — 120 капсул | G&G Vitamins UA» *}

  {* Description: 150-160 символов. Включить: назначение + ключевые эффекты + CTA *}

  {* Canonical — всегда указывать, особенно при вариантах *}
  <link rel="canonical" href="{$product.canonical_url}">

  {* Для товаров не в наличии — опционально noindex *}
  {if !$product.availability == 'available'}
    <meta name="robots" content="noindex, follow">
  {/if}
{/block}
```

### 14.2 Оптимизация для Google Shopping Ukraine 2025

Google Shopping активен в Украине. Для попадания:
1. Заполнить EAN (gtin13) в характеристиках.
2. Настроить Google Merchant Center (отдельно от PS9).
3. Установить Google Tag Manager Community Module для PS9.
4. Белый фон фото товара — требование GMC.
5. Цена в UAH — обязательно.

### 14.3 Оптимизация для AI-агентов (страница товара)

AI-агенты (Perplexity, ChatGPT Search, Gemini) при запросах «[название G&G продукта] купити Україна» должны находить вашу страницу.

**Сигналы для AI:**
1. `schema-product.tpl` с полными данными — JSON-LD читается первым.
2. `schema-faq.tpl` — ответы на частые вопросы.
3. Текст описания: первый абзац = четкое определение продукта + назначение.
4. Упоминание «офіційний представник G&G Vitamins в Україні» — сигнал авторитетности.

---

## 15. ВИДЕО ОБЗОР — lazy iframe

```html
{if isset($product.video_url) && $product.video_url}
<section class="product-section" id="product-video">
  <h2 class="product-section__title">Відеоогляд</h2>
  <div class="product-section__body">
    <div class="product-video">
      <button class="product-video__placeholder"
              data-video-url="{$product.video_url|escape:'html':'UTF-8'}"
              aria-label="Відтворити відео">
        <img class="product-video__thumb" src="..." loading="lazy"
             alt="Відео про {$product.name|escape:'html':'UTF-8'}">
        <span class="product-video__play-icon" aria-hidden="true">
          <i class="fa-solid fa-circle-play"></i>
        </span>
      </button>
    </div>
  </div>
</section>
{/if}
```

LCP-безопасно: iframe грузится только по клику.

---

## 16. ФАЙЛЫ ДЛЯ СОЗДАНИЯ В v0.7.0

```
templates/catalog/
├── product.tpl                          ⬜ главный шаблон страницы товара
└── _partials/
    ├── product-prices.tpl               ⬜ блок цен
    ├── product-images.tpl               ⬜ галерея + lightbox
    ├── product-variants.tpl             ⬜ выбор варианта (pill-кнопки)
    ├── product-add-to-cart.tpl          ⬜ qty stepper + кнопка
    ├── product-features.tpl             ⬜ таблица характеристик
    ├── product-reviews-summary.tpl      ⬜ distribution bar рейтинга
    └── product-info-sections.tpl        ⬜ информационные секции

assets/css/pages/
└── product.css                          ⬜ v0.14.0

assets/js/pages/
└── product.js                           ⬜ v0.14.0
    (gallery, lightbox, accordion, sticky bar, qty stepper, AJAX cart)

templates/_partials/microdata/
└── schema-product.tpl                   ✅ v0.4.0 (проверить GTIN, brand)
└── schema-faq.tpl                       ✅ v0.4.0 (переиспользовать)
```

**Зависимости v0.7.0:**
```
catalog/listing/_partials/rating-stars.tpl    ✅ v0.6.0 — переиспользуется
_partials/breadcrumb.tpl                      ✅ v0.5.1
_partials/notifications.tpl                   ✅ v0.5.1
microdata/schema-product.tpl                  ✅ v0.4.0
microdata/schema-faq.tpl                      ✅ v0.4.0
ps_productcomments                            ← установить + проверить
```

---

## 17. ПОЛНАЯ СТРУКТУРА СТРАНИЦЫ ТОВАРА — финальная схема

```
product.tpl
│
├── {block head_extra}
│     <link rel="canonical">
│     <link rel="preload" as="image" — главное фото (LCP)>
│     <meta noindex если нет в наличии>
│     {hook h='displaySchemaMarkup'} → schema-product.tpl + schema-faq.tpl
│
├── {block content}
│     │
│     ├── breadcrumb.tpl
│     ├── notifications.tpl
│     │
│     ├── .product-layout (двухколоночный ≥992px)
│     │   ├── .product-layout__gallery (55%, sticky desktop)
│     │   │     └── product-images.tpl
│     │   │           ├── Миниатюры слева (вертикальная колонка, desktop)
│     │   │           ├── Главное фото (eager+high, 800×800, object-fit:contain)
│     │   │           ├── Hover-зум (CSS scale)
│     │   │           ├── Lightbox (<dialog>, по клику)
│     │   │           └── Swipe + dots (mobile)
│     │   │
│     │   └── .product-layout__panel (45%)
│     │         ├── .product-line-badge (SOOV / Kids / Cal-M тег)
│     │         ├── H1: $product.name (укр.)
│     │         ├── rating-stars.tpl + якорь → #product-reviews
│     │         ├── .product-identity (артикул, Product Code G&G)
│     │         ├── product-prices.tpl (цена + скидка + ₴/капсула)
│     │         ├── .product-trust (Made in UK 🇬🇧 | Нотифікація ДПСС ✓)
│     │         ├── product-variants.tpl (pill-кнопки выбора варианта)
│     │         ├── product-add-to-cart.tpl (qty stepper + кнопка)
│     │         ├── .product-wishlist-share
│     │         ├── .product-delivery (наличие + краткая доставка)
│     │         └── .product-guarantees (иконки: повернення / оплата / чат)
│     │
│     ├── .product-info-sections (full width, вертикально раскрытые)
│     │     ├── #product-description     Опис
│     │     ├── #product-composition     Склад та харчова цінність
│     │     ├── #product-usage          Спосіб застосування та дозування
│     │     ├── #product-warnings       ⚠️ Застереження (ОБЯЗАТЕЛЬНО, открытая)
│     │     ├── #product-details         Деталі та характеристики (Features)
│     │     ├── #product-manufacturer   Виробник та представник (ОБЯЗАТЕЛЬНО)
│     │     ├── #product-certificates   Сертифікати (нотифікація ДПСС)
│     │     ├── #product-video          Відеоогляд (lazy iframe, если есть)
│     │     └── #product-faq            FAQ + schema-faq.tpl
│     │
│     ├── #product-reviews (full width)
│     │     ├── product-reviews-summary.tpl (distribution bar)
│     │     ├── {hook h='displayProductTabContent'} → ps_productcomments
│     │     └── Кнопка «Написати відгук»
│     │
│     ├── .product-related (full width)
│     │     ├── Заголовок (контекстный: «Схожі» / «Лінійка SOOV» / ...)
│     │     └── scroll-snap из product-miniature.tpl (v0.6.0)
│     │
│     └── {hook h='displayFooterProduct'}
│
└── .product-sticky-bar (fixed, mobile, IntersectionObserver)
      ├── Текущая цена
      └── «До кошика» / «Обрати варіант»
```

---

*Документ составлен на основе: Baymard Institute Vitamins & Supplements UX Benchmark (2025),
Baymard Product Page UX (2025), Baymard Distribution Bar research (2025),
Nielsen Norman Group (2024), Google Search Central Product structured data (2025–2026),
Google Shopping requirements Ukraine (2025), Google AI Overviews (2025),
Закон України № 4122-IX від 05.12.2024 (вступив у силу 27.09.2025),
Наказ МОЗ № 1114 від 19.12.2013, Держпродспоживслужба України,
ps9_categories.md (март 2026), рішення по відкритих питаннях (архітектурні рішення, березень 2026).*
