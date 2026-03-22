# Рекомендации по разработке корзины и чекаута v0.8.0
## PrestaShop 9.0 — mytheme | G&G Vitamins UA
**Актуально:** март 2026 | Ниша: дієтичні добавки, вітаміни | Ассортимент: 300+

> Документ является продолжением `CATALOG-0.6.0`, `PRODUCT-0.7.0`, `HOME-0.5.x`.
> Читать вместе с `PROJECT.md`, `CHANGELOG.md`, `ps9_categories.md`.
>
> **Стек оплаты:** Картка (Visa/MC) + Накладений платіж + Google Pay / Apple Pay
> **Доставка:** Нова Пошта (відділення + поштомат + кур'єр) + Укрпошта + Кур'єр по Києву + Самовивіз
> **Тип чекауту:** One-page checkout (одна сторінка) — прийнято на основі Baymard 2025
> **Реєстрація:** Необов'язкова — Guest checkout доступний завжди
> **Cross-sell:** Так — тільки в кошику, не в чекауті

---

## 1. СТРАТЕГІЧНІ РІШЕННЯ

### 1.1 One-page checkout — обґрунтування

**Рішення: весь чекаут на одній сторінці, кроки — accordion-секції.**

Дослідження (Baymard Institute, 2025):
- One-page checkout показує на **21% менше відмов** на мобільних vs мультикрокового.
- Для замовлень з 1–3 товарами (типово для БАДів) one-page — оптимальний формат.
- Мультикроковий виправданий тільки для складних замовлень (B2B, кастомізація) — G&G UA не потребує.

**Реалізація в PS9:** переопределення `checkout/checkout.tpl`. PS9 нативно підтримує one-step checkout через конфіг. Кроки відображаються як accordion, відкриваються послідовно.

**Структура one-page:**
```
[1] Контактні дані (або вхід)
[2] Доставка — вибір способу + адреса / відділення НП
[3] Оплата — вибір способу + деталі
[4] Підтвердження — резюме + кнопка «Оформити замовлення»
```

### 1.2 Guest Checkout — обґрунтування

**Рішення: guest checkout обов'язковий, реєстрація — опціональна пропозиція після замовлення.**

Дослідження (Baymard Institute, 2025):
- Обов'язкова реєстрація — **причина №1 покидання чекауту (37% відмов)**.
- Пропозиція зареєструватись після успішного замовлення («Зберегти ваші дані для наступного разу?») конвертує ~28% guest-покупців в зареєстрованих — без тиску.
- Для ніші БАДів особливо важливо: новий покупець ще не впевнений у магазині, примусова реєстрація відлякує.

**Реалізація в PS9:** `PS_GUEST_CHECKOUT_ENABLED: 1` у конфізі. Після успішного замовлення — email з посиланням «Створити акаунт одним кліком».

### 1.3 Cross-sell — тільки в кошику

**Рішення: cross-sell у `cart.tpl`, НЕ в `checkout.tpl`.**

Дослідження (Nielsen Norman Group, 2024):
- Cross-sell у чекауті на 14% збільшує відмови — відволікає від завершення покупки.
- Cross-sell у кошику збільшує AOV (Average Order Value) на 8–12% без негативного впливу на конверсію.
- Для G&G: показувати «Часто купують разом» або «Доповни базовий набір» — органічна логіка для ніші добавок.

---

## 2. СТОРІНКА КОШИКА — `cart.tpl`

### 2.1 Структура сторінки кошика

**Layout (desktop — 2 колонки):**
```
┌────────────────────────────────────────────────────────┐
│  Breadcrumb: Головна > Кошик                           │
│  H1: Ваш кошик (N товарів)                             │
├───────────────────────────────┬────────────────────────┤
│  Список товарів (65%)         │  Підсумок (35%)        │
│  ─────────────────────────    │  ──────────────────    │
│  [фото] Назва товару          │  Товари: 1 480 грн     │
│         Кількість stepper     │  Знижка: -148 грн      │
│         Ціна × кількість      │  Доставка: безкоштовно │
│         [× видалити]          │  ─────────────────     │
│                               │  Разом: 1 332 грн      │
│  [фото] Назва товару 2        │                        │
│         ...                   │  [Оформити замовлення] │
│                               │                        │
│  ── Cross-sell ──             │  🔒 Безпечна оплата    │
│  «Часто купують разом»        │  ↩️  Повернення 14 днів │
├───────────────────────────────┴────────────────────────┤
│  [← Продовжити покупки]                                │
└────────────────────────────────────────────────────────┘
```

**Mobile:** одна колонка, підсумок — sticky блок знизу або після списку товарів.

### 2.2 Рядок товару в кошику

```smarty
{* cart.tpl — рядок одного товару *}
<div class="cart-item" data-id-product="{$product.id_product}">

  {* Фото *}
  <a href="{$product.url}" class="cart-item__img-link">
    <img
      src="{$product.cover.small.url}"
      alt="{$product.name|escape:'html'}"
      width="100" height="100"
      loading="lazy"
      class="cart-item__img"
    >
  </a>

  {* Назва + варіант *}
  <div class="cart-item__info">
    <a href="{$product.url}" class="cart-item__name">
      {$product.name}
    </a>
    {if $product.attributes}
      <span class="cart-item__attrs">{$product.attributes}</span>
    {/if}
    {* Тег серії SOOV / Kids — якщо є *}
    {foreach from=$product.features item=feature}
      {if $feature.name == 'Серія' && $feature.value == 'SOOV'}
        <span class="product-series-tag product-series-tag--soov">SOOV</span>
      {/if}
    {/foreach}
    {* Ціна за одиницю (якщо є) *}
    {if $product.unit_price_ratio > 0}
      <span class="cart-item__unit-price">
        ≈ {$product.unit_price} грн/{$product.unity}
      </span>
    {/if}
  </div>

  {* Qty Stepper — переиспользуем логику из product-add-to-cart.tpl *}
  <div class="cart-item__qty">
    <div class="product-qty-stepper product-qty-stepper--sm">
      <button class="product-qty-stepper__btn js-cart-qty"
              data-action="decrement"
              data-id-product="{$product.id_product}"
              aria-label="Зменшити кількість">
        <i class="fa-solid fa-minus" aria-hidden="true"></i>
      </button>
      <input type="number" value="{$product.quantity}" min="1"
             class="product-qty-stepper__input js-cart-qty-input"
             aria-label="Кількість">
      <button class="product-qty-stepper__btn js-cart-qty"
              data-action="increment"
              data-id-product="{$product.id_product}"
              aria-label="Збільшити кількість">
        <i class="fa-solid fa-plus" aria-hidden="true"></i>
      </button>
    </div>
  </div>

  {* Ціна рядку *}
  <div class="cart-item__price">
    {if $product.has_discount}
      <span class="cart-item__price-old">{$product.price_without_reduction}</span>
    {/if}
    <span class="cart-item__price-current">{$product.total}</span>
  </div>

  {* Видалити *}
  <button class="cart-item__remove js-cart-remove"
          data-id-product="{$product.id_product}"
          aria-label="Видалити {$product.name|escape:'html'} з кошика">
    <i class="fa-solid fa-xmark" aria-hidden="true"></i>
  </button>

</div>
```

**CSS рядка товару:**
```css
.cart-item {
  display: grid;
  grid-template-columns: 100px 1fr auto auto auto;
  gap: 1rem;
  align-items: center;
  padding: 1.25rem 0;
  border-bottom: 1px solid var(--color-border);
}

.cart-item__img {
  width: 100px;
  height: 100px;
  object-fit: contain;
  border-radius: var(--radius-base);
  border: 1px solid var(--color-border);
  background: var(--color-card);
  padding: 4px;
}

.cart-item__name {
  font-weight: 600;
  color: var(--color-text);
  text-decoration: none;
  font-size: var(--font-size-base);
  line-height: 1.3;
}
.cart-item__name:hover { color: var(--color-primary); }

.cart-item__attrs {
  display: block;
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
  margin-top: 4px;
}

.cart-item__unit-price {
  display: block;
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
  margin-top: 4px;
}

.cart-item__price-old {
  display: block;
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  text-decoration: line-through;
}
.cart-item__price-current {
  font-size: var(--font-size-lg);
  font-weight: 700;
  color: var(--color-text);
}

.cart-item__remove {
  background: none;
  border: none;
  color: var(--color-text-muted);
  cursor: pointer;
  padding: 0.25rem;
  font-size: 1rem;
  transition: color 0.15s;
}
.cart-item__remove:hover { color: var(--color-discount); }

@media (max-width: 767px) {
  .cart-item {
    grid-template-columns: 80px 1fr auto;
    grid-template-rows: auto auto;
    gap: 0.75rem;
  }
  .cart-item__img { width: 80px; height: 80px; }
  .cart-item__qty { grid-column: 2; }
  .cart-item__price { grid-column: 3; grid-row: 2; text-align: right; }
  .cart-item__remove { grid-column: 3; grid-row: 1; }
}
```

### 2.3 Підсумок кошика (Order Summary)

**Sticky на desktop:**
```css
.cart-summary {
  position: sticky;
  top: calc(var(--header-height) + 1rem);
  background: var(--color-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  padding: 1.5rem;
}
```

**Smarty:**
```smarty
<div class="cart-summary">
  <h2 class="cart-summary__title">
    {l s='Підсумок замовлення' d='Shop.Theme.Checkout'}
  </h2>

  <div class="cart-summary__lines">
    {* Товари *}
    <div class="cart-summary__line">
      <span>{l s='Товари' d='Shop.Theme.Checkout'}</span>
      <span>{$cart.subtotals.products.value}</span>
    </div>

    {* Знижка — тільки якщо є *}
    {if $cart.subtotals.discounts.value}
      <div class="cart-summary__line cart-summary__line--discount">
        <span>{l s='Знижка' d='Shop.Theme.Checkout'}</span>
        <span>- {$cart.subtotals.discounts.value}</span>
      </div>
    {/if}

    {* Доставка *}
    <div class="cart-summary__line">
      <span>{l s='Доставка' d='Shop.Theme.Checkout'}</span>
      <span>
        {if $cart.subtotals.shipping.value == '0,00 грн'}
          <span class="cart-summary__free-shipping">
            {l s='Безкоштовно' d='Shop.Theme.Checkout'}
          </span>
        {else}
          {$cart.subtotals.shipping.value}
        {/if}
      </span>
    </div>
  </div>

  <div class="cart-summary__total">
    <span>{l s='Разом' d='Shop.Theme.Checkout'}</span>
    <span class="cart-summary__total-price">{$cart.totals.total.value}</span>
  </div>

  {* Поле промокоду *}
  <div class="cart-voucher">
    <button class="cart-voucher__toggle js-voucher-toggle"
            aria-expanded="false"
            aria-controls="cart-voucher-form">
      <i class="fa-solid fa-tag" aria-hidden="true"></i>
      {l s='Маєте промокод?' d='Shop.Theme.Checkout'}
      <i class="fa-solid fa-chevron-down cart-voucher__chevron" aria-hidden="true"></i>
    </button>
    <div id="cart-voucher-form" class="cart-voucher__form" hidden>
      {hook h='displayCartVoucher'}
    </div>
  </div>

  {* CTA *}
  <a href="{$urls.pages.order}" class="btn btn-primary cart-summary__checkout-btn">
    {l s='Оформити замовлення' d='Shop.Theme.Checkout'}
    <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
  </a>

  {* Trust signals під кнопкою *}
  <div class="cart-summary__trust">
    <span>
      <i class="fa-solid fa-lock" aria-hidden="true"></i>
      {l s='Безпечна оплата' d='Shop.Theme.Checkout'}
    </span>
    <span>
      <i class="fa-solid fa-rotate-left" aria-hidden="true"></i>
      {l s='Повернення 14 днів' d='Shop.Theme.Checkout'}
    </span>
  </div>

</div>
```

### 2.4 Cross-sell у кошику

**Заголовок:** «Часто купують разом» або «Доповни базовий набір» (залежно від товарів у кошику).

**Логіка підбору для G&G:**
- Якщо в кошику є Vitamin D3 → показати Magnesium, Vitamin K2, Zinc
- Якщо SOOV → показати Flow + Deflate + Ouch (комплект)
- Якщо Kids Rainbow Food → показати Vitamin D3 1000iu (дитяче дозування)
- Якщо Daily Pack → нічого не показувати (пакет вже комплексний)
- За замовчуванням → «Топ для початку» (з категорії 5.1)

**Реалізація:** `ps_crossselling` або `ps_categoryproducts` через хук `displayShoppingCart`. Максимум 4 товари. Переиспользувати `product-miniature.tpl` (v0.6.0).

```smarty
{* Підключається через displayShoppingCart hook *}
{if $cross_sell_products|@count > 0}
<section class="cart-cross-sell">
  <h2 class="cart-cross-sell__title">
    {l s='Часто купують разом' d='Shop.Theme.Checkout'}
  </h2>
  <div class="row row-cols-2 row-cols-md-4 g-3">
    {foreach from=$cross_sell_products item=product}
      {include file='catalog/listing/product-miniature.tpl' product=$product}
    {/foreach}
  </div>
</section>
{/if}
```

---

## 3. ONE-PAGE CHECKOUT — `checkout.tpl`

### 3.1 Повна структура сторінки

```
checkout.tpl
│
├── {block head_extra}
│     <meta name="robots" content="noindex, nofollow">  ← чекаут не індексується
│     {* Без schema.org — не потрібно *}
│
└── {block content}
      │
      ├── .checkout-header (спрощений — тільки лого + замок)
      │
      ├── .checkout-layout (2 колонки desktop)
      │   ├── .checkout-main (65%)
      │   │     ├── [1] .checkout-step — Контактні дані
      │   │     ├── [2] .checkout-step — Доставка
      │   │     ├── [3] .checkout-step — Оплата
      │   │     └── [4] .checkout-step — Підтвердження
      │   │
      │   └── .checkout-aside (35%, sticky)
      │         └── Order Summary (спрощений, без cross-sell)
      │
      └── .checkout-footer (мінімальний — копірайт + посилання)
```

**⚠️ Важливо — спрощений header у чекауті:**
Baymard 2025: спрощений header (без навігації, пошуку, кошика) у чекауті знижує відволікання і збільшує completion rate на 17%. Залишити тільки лого та індикатор кроків.

```smarty
{* checkout-header — відмінний від основного header.tpl *}
<header class="checkout-header">
  <div class="container checkout-header__inner">
    <a href="{$urls.base_url}" class="checkout-header__logo" aria-label="На головну">
      <img src="{$urls.base_url}themes/mytheme/assets/img/logo.svg"
           alt="{$shop.name}" height="40" width="auto">
    </a>
    <div class="checkout-header__secure">
      <i class="fa-solid fa-lock" aria-hidden="true"></i>
      <span>{l s='Безпечне оформлення' d='Shop.Theme.Checkout'}</span>
    </div>
  </div>
</header>
```

### 3.2 Прогрес-індикатор (Steps indicator)

**Горизонтальний прогрес над формою:**
```
[1 Контакти] ──── [2 Доставка] ──── [3 Оплата] ──── [4 Підтвердження]
      ✓                 ✓               →                  ○
```

```smarty
<nav class="checkout-steps" aria-label="Кроки оформлення">
  {foreach from=$checkout_process.steps item=step name=steps_loop}
    <div class="checkout-steps__item
      {if $step.current} is-current{/if}
      {if $step.complete} is-complete{/if}">
      <span class="checkout-steps__num" aria-hidden="true">
        {if $step.complete}
          <i class="fa-solid fa-check"></i>
        {else}
          {$smarty.foreach.steps_loop.iteration}
        {/if}
      </span>
      <span class="checkout-steps__label">{$step.title}</span>
    </div>
    {if !$smarty.foreach.steps_loop.last}
      <div class="checkout-steps__connector" aria-hidden="true"></div>
    {/if}
  {/foreach}
</nav>
```

```css
.checkout-steps {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0;
  margin-bottom: 2rem;
  padding: 1.5rem 0;
}

.checkout-steps__item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.375rem;
  opacity: 0.45;
  transition: opacity 0.2s;
}
.checkout-steps__item.is-current { opacity: 1; }
.checkout-steps__item.is-complete { opacity: 0.7; }

.checkout-steps__num {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 2px solid var(--color-border);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.875rem;
  font-weight: 700;
  background: var(--color-card);
  color: var(--color-text-muted);
}
.is-current .checkout-steps__num {
  border-color: var(--color-primary);
  background: var(--color-primary);
  color: #fff;
}
.is-complete .checkout-steps__num {
  border-color: var(--color-primary);
  background: var(--color-primary-subtle);
  color: var(--color-primary);
}

.checkout-steps__label {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--color-text-muted);
  white-space: nowrap;
}
.is-current .checkout-steps__label { color: var(--color-primary); }

.checkout-steps__connector {
  flex: 1;
  height: 2px;
  background: var(--color-border);
  max-width: 80px;
  margin-bottom: 1.25rem; /* вирівнювання по центру кружечків */
}

@media (max-width: 575px) {
  .checkout-steps__label { display: none; }
  .checkout-steps__connector { max-width: 40px; }
}
```

### 3.3 Крок 1 — Контактні дані

```smarty
<div class="checkout-step {if $step.current}is-current{/if}" id="checkout-personal-step">

  <div class="checkout-step__header" data-step="personal">
    <span class="checkout-step__num">1</span>
    <h2 class="checkout-step__title">
      {l s='Контактні дані' d='Shop.Theme.Checkout'}
    </h2>
    {if $step.complete}
      <button class="checkout-step__edit" aria-label="Редагувати контактні дані">
        {l s='Змінити' d='Shop.Theme.Checkout'}
      </button>
    {/if}
  </div>

  {if $step.current}
  <div class="checkout-step__content">

    {* Guest або логін *}
    {if !$customer.is_logged}
    <div class="checkout-auth-choice">
      <p class="checkout-auth-choice__hint">
        {l s='Вже маєте акаунт?' d='Shop.Theme.Checkout'}
        <a href="{$urls.pages.login}?back={$urls.pages.order|escape:'url'}">
          {l s='Увійти' d='Shop.Theme.Checkout'}
        </a>
      </p>
    </div>
    {/if}

    {* Форма: Ім'я, Прізвище, Email, Телефон *}
    <div class="checkout-form-grid">
      <div class="form-group">
        <label for="field-firstname">{l s="Ім'я" d='Shop.Forms'} *</label>
        <input type="text" id="field-firstname" name="firstname"
               value="{$customer.firstname}" autocomplete="given-name"
               required class="form-control">
      </div>
      <div class="form-group">
        <label for="field-lastname">{l s='Прізвище' d='Shop.Forms'} *</label>
        <input type="text" id="field-lastname" name="lastname"
               value="{$customer.lastname}" autocomplete="family-name"
               required class="form-control">
      </div>
      <div class="form-group form-group--full">
        <label for="field-email">{l s='Email' d='Shop.Forms'} *</label>
        <input type="email" id="field-email" name="email"
               value="{$customer.email}" autocomplete="email"
               required class="form-control">
      </div>
      <div class="form-group form-group--full">
        <label for="field-phone">{l s='Телефон' d='Shop.Forms'} *</label>
        <input type="tel" id="field-phone" name="phone"
               value="{$customer.phone}" autocomplete="tel"
               placeholder="+380XXXXXXXXX"
               required class="form-control">
        <span class="form-hint">
          {l s='Потрібен для зв\'язку по замовленню та доставці' d='Shop.Forms'}
        </span>
      </div>
    </div>

    {* Гість — пропозиція зберегти пароль (НЕ обов'язково) *}
    {if !$customer.is_logged}
    <div class="checkout-guest-save">
      <label class="checkbox-label">
        <input type="checkbox" name="create_account" value="1">
        <span>{l s='Зберегти дані для наступного разу (необов\'язково)' d='Shop.Theme.Checkout'}</span>
      </label>
      <div class="checkout-guest-save__password" id="guest-password-field" hidden>
        <input type="password" name="password" id="field-password"
               autocomplete="new-password" class="form-control"
               placeholder="{l s='Придумайте пароль' d='Shop.Forms'}">
      </div>
    </div>
    {/if}

    <button class="btn btn-primary checkout-step__continue">
      {l s='Продовжити' d='Shop.Theme.Checkout'}
      <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
    </button>

  </div>
  {/if}

</div>
```

### 3.4 Крок 2 — Доставка

**Пріоритет способів доставки (відображати в цьому порядку):**

| # | Спосіб | Умовна назва в PS9 | Деталі |
|---|---|---|---|
| 1 | Нова Пошта — відділення | `np_branch` | Введення міста + №відділення або поштомату |
| 2 | Нова Пошта — кур'єр | `np_courier` | Введення адреси |
| 3 | Нова Пошта — поштомат | `np_locker` | Введення коду поштомату |
| 4 | Укрпошта | `ukrposhta` | Введення відділення |
| 5 | Кур'єр по Києву | `kyiv_courier` | Тільки для м. Київ |
| 6 | Самовивіз | `pickup` | Адреса магазину |

**⚠️ Нова Пошта — інтеграція API:**
Для автодоповнення відділень НП — використовувати офіційний модуль `novaposhta` або API НП. Це критично для UX — покупець вводить назву міста і отримує список відділень. Без API він змушений вводити номер відділення вручну, що призводить до помилок.

```smarty
<div class="checkout-step" id="checkout-delivery-step">
  <div class="checkout-step__header">
    <span class="checkout-step__num">2</span>
    <h2 class="checkout-step__title">
      {l s='Спосіб доставки' d='Shop.Theme.Checkout'}
    </h2>
  </div>

  {if $step.current}
  <div class="checkout-step__content">

    {* Вибір способу доставки *}
    <div class="delivery-methods">
      {foreach from=$delivery_options item=carrier}
      <label class="delivery-method
        {if $carrier.id == $delivery_option}delivery-method--active{/if}">
        <input type="radio" name="delivery_option"
               value="{$carrier.id}"
               {if $carrier.id == $delivery_option}checked{/if}>
        <div class="delivery-method__content">
          <span class="delivery-method__name">{$carrier.name}</span>
          <span class="delivery-method__delay">{$carrier.delay}</span>
          <span class="delivery-method__price">
            {if $carrier.price == 0}
              <span class="delivery-method__free">
                {l s='Безкоштовно' d='Shop.Theme.Checkout'}
              </span>
            {else}
              {$carrier.price}
            {/if}
          </span>
        </div>
      </label>
      {/foreach}
    </div>

    {* Адресна форма (змінюється залежно від способу) *}
    <div class="delivery-address js-delivery-address-form">
      {hook h='displayCarrierExtraContent'}
      {* → Нова Пошта модуль виводить тут форму пошуку відділення *}
    </div>

    {* Коментар до замовлення *}
    <div class="form-group">
      <label for="field-comment">
        {l s='Коментар до замовлення (необов\'язково)' d='Shop.Forms'}
      </label>
      <textarea id="field-comment" name="message" rows="3"
                class="form-control"
                placeholder="{l s='Наприклад: телефонуйте за 30 хв до доставки' d='Shop.Forms'}">
      </textarea>
    </div>

    <button class="btn btn-primary checkout-step__continue">
      {l s='Продовжити' d='Shop.Theme.Checkout'}
      <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
    </button>

  </div>
  {/if}
</div>
```

**CSS способів доставки:**
```css
.delivery-methods {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
}

.delivery-method {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.25rem;
  border: 1.5px solid var(--color-border);
  border-radius: var(--radius-base);
  cursor: pointer;
  transition: border-color 0.15s, background 0.15s;
}

.delivery-method input[type="radio"] { display: none; }

.delivery-method--active,
.delivery-method:has(input:checked) {
  border-color: var(--color-primary);
  background: var(--color-primary-subtle);
}

.delivery-method__content {
  display: grid;
  grid-template-columns: 1fr auto;
  grid-template-rows: auto auto;
  gap: 0.125rem 1rem;
  width: 100%;
}

.delivery-method__name {
  font-weight: 600;
  color: var(--color-text);
  grid-column: 1;
  grid-row: 1;
}
.delivery-method__delay {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
  grid-column: 1;
  grid-row: 2;
}
.delivery-method__price {
  font-weight: 700;
  color: var(--color-text);
  grid-column: 2;
  grid-row: 1 / 3;
  align-self: center;
  text-align: right;
}
.delivery-method__free { color: var(--color-primary); }
```

### 3.5 Крок 3 — Оплата

**Способи оплати (відображати в цьому порядку):**

| # | Спосіб | Модуль PS9 | Пріоритет |
|---|---|---|---|
| 1 | Google Pay / Apple Pay | WayForPay / LiqPay / Fondy | Перший — найшвидший |
| 2 | Картка Visa/MC (онлайн) | WayForPay / LiqPay / Fondy | Основний |
| 3 | Оплата частинами (Monobank) | Monobank частинами | Збільшує AOV |
| 4 | Оплата частинами (PrivatBank) | Privatbank частинами | Альтернатива |
| 5 | Передоплата (банківський переказ) | PS9 native `ps_wirepayment` | Для ФОП/ТОВ |
| 6 | Накладений платіж | PS9 native `ps_cashondelivery` | Останній |

**⚠️ Рекомендація по платіжному шлюзу:** WayForPay або LiqPay — найбільш поширені в Україні, підтримують Google Pay / Apple Pay, є готові модулі для PS9. Обрати один основний шлюз, решта — опціонально.

```smarty
<div class="checkout-step" id="checkout-payment-step">
  <div class="checkout-step__header">
    <span class="checkout-step__num">3</span>
    <h2 class="checkout-step__title">
      {l s='Спосіб оплати' d='Shop.Theme.Checkout'}
    </h2>
  </div>

  {if $step.current}
  <div class="checkout-step__content">

    {* Методи оплати *}
    <div class="payment-methods">
      {foreach from=$payment_alternatives item=payment_option}
      <label class="payment-method">
        <input type="radio" name="payment-option"
               value="{$payment_option.module_name}">
        <div class="payment-method__content">
          {if $payment_option.logo}
            <img src="{$payment_option.logo}"
                 alt="{$payment_option.call_to_action_text}"
                 class="payment-method__logo" loading="lazy">
          {/if}
          <span class="payment-method__name">
            {$payment_option.call_to_action_text}
          </span>
        </div>
      </label>
      {/foreach}
    </div>

    {* Форма введення даних карти (якщо вибрано картку) *}
    <div class="payment-form-container js-payment-form">
      {foreach from=$payment_alternatives item=payment_option}
        {if $payment_option.form}
          <div class="payment-form"
               id="pay-with-{$payment_option.module_name}"
               hidden>
            {$payment_option.form nofilter}
          </div>
        {/if}
      {/foreach}
    </div>

    {* Consent + умови *}
    <div class="checkout-consent">
      <label class="checkbox-label">
        <input type="checkbox" name="conditions_to_approve[terms-and-conditions]"
               id="conditions_to_approve" required>
        <span>
          {l s='Я погоджуюсь з' d='Shop.Theme.Checkout'}
          <a href="{$urls.pages.cms}?id_cms=3" target="_blank">
            {l s='умовами використання' d='Shop.Theme.Checkout'}
          </a>
          {l s='та' d='Shop.Theme.Checkout'}
          <a href="{$urls.pages.cms}?id_cms=4" target="_blank">
            {l s='політикою конфіденційності' d='Shop.Theme.Checkout'}
          </a> *
        </span>
      </label>
    </div>

    <button class="btn btn-primary checkout-step__continue">
      {l s='Продовжити' d='Shop.Theme.Checkout'}
      <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
    </button>

  </div>
  {/if}
</div>
```

### 3.6 Крок 4 — Підтвердження

```smarty
<div class="checkout-step" id="checkout-confirm-step">
  <div class="checkout-step__header">
    <span class="checkout-step__num">4</span>
    <h2 class="checkout-step__title">
      {l s='Підтвердження замовлення' d='Shop.Theme.Checkout'}
    </h2>
  </div>

  {if $step.current}
  <div class="checkout-step__content">

    {* Резюме: контакти *}
    <div class="checkout-confirm-block">
      <h3 class="checkout-confirm-block__title">
        {l s='Контактні дані' d='Shop.Theme.Checkout'}
      </h3>
      <p>{$customer.firstname} {$customer.lastname}</p>
      <p>{$customer.email}</p>
      <p>{$customer.phone}</p>
      <button class="checkout-confirm-block__edit">
        {l s='Змінити' d='Shop.Theme.Checkout'}
      </button>
    </div>

    {* Резюме: доставка *}
    <div class="checkout-confirm-block">
      <h3 class="checkout-confirm-block__title">
        {l s='Доставка' d='Shop.Theme.Checkout'}
      </h3>
      <p>{$delivery.name}</p>
      <p>{$delivery.address.full}</p>
      <button class="checkout-confirm-block__edit">
        {l s='Змінити' d='Shop.Theme.Checkout'}
      </button>
    </div>

    {* Резюме: оплата *}
    <div class="checkout-confirm-block">
      <h3 class="checkout-confirm-block__title">
        {l s='Оплата' d='Shop.Theme.Checkout'}
      </h3>
      <p>{$payment.name}</p>
    </div>

    {* Фінальна кнопка *}
    <button class="btn btn-primary checkout-confirm__submit" id="payment-confirmation">
      <i class="fa-solid fa-lock" aria-hidden="true"></i>
      {l s='Підтвердити та оплатити' d='Shop.Theme.Checkout'}
    </button>

    <p class="checkout-confirm__legal">
      {l s='Натискаючи кнопку, ви підтверджуєте замовлення та погоджуєтесь з умовами.' d='Shop.Theme.Checkout'}
    </p>

  </div>
  {/if}
</div>
```

### 3.7 Order Summary (aside в чекауті — спрощений)

Той самий підсумок, що і в кошику, але **без**:
- Промокоду (вже застосований на кроці 1)
- Cross-sell (відволікає від завершення)
- Кнопки «Оформити» (вона в основній формі)

Додати: список товарів (згорнутий, розкривається по кліку) — покупець може перевірити що замовляє.

```css
.checkout-layout {
  display: grid;
  grid-template-columns: 1fr 380px;
  gap: 2rem;
  align-items: start;
}

.checkout-aside {
  position: sticky;
  top: calc(var(--header-height) + 1rem);
}

@media (max-width: 991px) {
  .checkout-layout {
    grid-template-columns: 1fr;
  }
  .checkout-aside {
    position: static;
    order: -1; /* підсумок — зверху на mobile */
  }
}
```

---

## 4. СТОРІНКА ПІДТВЕРДЖЕННЯ ЗАМОВЛЕННЯ — `order-confirmation.tpl`

### 4.1 Структура

```
┌──────────────────────────────────────────────┐
│  ✅  Дякуємо! Ваше замовлення прийнято        │
│  Замовлення №12345                            │
│  Підтвердження надіслано на email@example.com │
├──────────────────────────────────────────────┤
│  Що далі?                                     │
│  1. Ми перевіримо наявність товарів           │
│  2. Зателефонуємо для підтвердження           │
│  3. Відправимо Новою Поштою                   │
├──────────────────────────────────────────────┤
│  Деталі замовлення (розкривається)            │
│  [Список товарів + суми]                      │
├──────────────────────────────────────────────┤
│  Schema.org Order JSON-LD                     │
├──────────────────────────────────────────────┤
│  Пропозиція реєстрації (для guest)            │
│  «Збережіть дані — це займе 10 секунд»        │
├──────────────────────────────────────────────┤
│  «Продовжити покупки» → каталог               │
└──────────────────────────────────────────────┘
```

### 4.2 Smarty

```smarty
{extends 'layouts/layout-full-width.tpl'}

{block name='head_extra'}
  <meta name="robots" content="noindex, nofollow">
  {* Schema.org Order — реалізувати в v0.15.0 *}
{/block}

{block name='content'}

  <section class="order-confirmation">
    <div class="container order-confirmation__inner">

      {* Заголовок успіху *}
      <div class="order-confirmation__hero">
        <div class="order-confirmation__icon" aria-hidden="true">
          <i class="fa-solid fa-circle-check"></i>
        </div>
        <h1 class="order-confirmation__title">
          {l s='Дякуємо за замовлення!' d='Shop.Theme.Checkout'}
        </h1>
        <p class="order-confirmation__subtitle">
          {l s='Замовлення' d='Shop.Theme.Checkout'}
          <strong>#{$order.reference}</strong>
          {l s='успішно прийнято.' d='Shop.Theme.Checkout'}
        </p>
        <p class="order-confirmation__email-note">
          {l s='Підтвердження надіслано на' d='Shop.Theme.Checkout'}
          <strong>{$customer.email}</strong>
        </p>
      </div>

      {* Що далі *}
      <div class="order-next-steps">
        <h2 class="order-next-steps__title">
          {l s='Що відбудеться далі?' d='Shop.Theme.Checkout'}
        </h2>
        <ol class="order-next-steps__list">
          <li>{l s='Ми перевіримо наявність усіх товарів' d='Shop.Theme.Checkout'}</li>
          <li>{l s='Наш менеджер зателефонує для підтвердження (якщо потрібно)' d='Shop.Theme.Checkout'}</li>
          <li>{l s='Відправимо замовлення обраним способом доставки' d='Shop.Theme.Checkout'}</li>
          <li>{l s='Ви отримаєте трек-номер для відстеження' d='Shop.Theme.Checkout'}</li>
        </ol>
      </div>

      {* Деталі замовлення *}
      <details class="order-details">
        <summary class="order-details__toggle">
          {l s='Деталі замовлення' d='Shop.Theme.Checkout'}
          <i class="fa-solid fa-chevron-down" aria-hidden="true"></i>
        </summary>
        <div class="order-details__content">
          {hook h='displayOrderConfirmation'}
        </div>
      </details>

      {* Пропозиція реєстрації для guest *}
      {if $guest_email}
      <div class="order-register-offer">
        <h2 class="order-register-offer__title">
          {l s='Збережіть дані для наступного разу' d='Shop.Theme.Checkout'}
        </h2>
        <p>{l s='Це займе 10 секунд — просто придумайте пароль.' d='Shop.Theme.Checkout'}</p>
        <form action="{$urls.pages.guest_tracking}" method="post"
              class="order-register-offer__form">
          <input type="hidden" name="id_order" value="{$order.id}">
          <input type="hidden" name="email" value="{$guest_email}">
          <div class="form-group">
            <label for="guest-register-password">
              {l s='Пароль' d='Shop.Forms'}
            </label>
            <input type="password" id="guest-register-password"
                   name="password" class="form-control"
                   autocomplete="new-password">
          </div>
          <button type="submit" class="btn btn-outline-primary">
            {l s='Створити акаунт' d='Shop.Theme.Checkout'}
          </button>
          <a href="{$urls.base_url}" class="order-register-offer__skip">
            {l s='Пропустити' d='Shop.Theme.Checkout'}
          </a>
        </form>
      </div>
      {/if}

      {* CTA — продовжити покупки *}
      <div class="order-confirmation__cta">
        <a href="{$urls.base_url}ua/vitaminy" class="btn btn-primary">
          {l s='Продовжити покупки' d='Shop.Theme.Checkout'}
        </a>
        {if $customer.is_logged}
          <a href="{$urls.pages.my_account}" class="btn btn-outline-primary">
            {l s='Мої замовлення' d='Shop.Theme.Checkout'}
          </a>
        {/if}
      </div>

    </div>
  </section>

{/block}
```

**CSS сторінки підтвердження:**
```css
.order-confirmation__hero {
  text-align: center;
  padding: 3rem 0 2rem;
}

.order-confirmation__icon {
  font-size: 4rem;
  color: var(--color-primary);
  margin-bottom: 1rem;
}

.order-confirmation__title {
  font-size: clamp(1.5rem, 3vw, 2.25rem);
  font-weight: 800;
  margin-bottom: 0.75rem;
}

.order-next-steps__list {
  counter-reset: steps;
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}
.order-next-steps__list li {
  display: flex;
  align-items: flex-start;
  gap: 0.875rem;
  font-size: var(--font-size-base);
}
.order-next-steps__list li::before {
  counter-increment: steps;
  content: counter(steps);
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: var(--color-primary-subtle);
  color: var(--color-primary);
  font-size: 0.875rem;
  font-weight: 700;
  flex-shrink: 0;
}

.order-register-offer {
  background: var(--color-primary-subtle);
  border-radius: var(--radius-xl);
  padding: 2rem;
  margin: 2rem 0;
}

.order-confirmation__cta {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
  padding: 2rem 0;
}
```

---

## 5. SCHEMA.ORG — ORDER (v0.8.0)

### 5.1 JSON-LD для сторінки підтвердження

Реалізувати інлайн у `order-confirmation.tpl` (не через хук — унікальний для сторінки):

```smarty
{* Schema.org Order *}
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Order",
  "orderNumber": "{$order.reference|escape:'javascript'}",
  "orderStatus": "https://schema.org/OrderProcessing",
  "orderDate": "{$order.date_add|truncate:10:''|escape:'javascript'}",
  "seller": {
    "@type": "Organization",
    "name": "{$shop.name|escape:'javascript'}",
    "url": "{$urls.base_url|escape:'javascript'}"
  },
  "customer": {
    "@type": "Person",
    "email": "{$customer.email|escape:'javascript'}"
  },
  "priceCurrency": "UAH",
  "price": "{$order.total_paid|string_format:'%.2f'|escape:'javascript'}",
  "acceptedOffer": [
    {foreach from=$order.products item=product name=products_loop}
    {if !$smarty.foreach.products_loop.first},{/if}
    {
      "@type": "Offer",
      "itemOffered": {
        "@type": "Product",
        "name": "{$product.name|strip_tags|trim|escape:'javascript'}"
      },
      "price": "{$product.price|string_format:'%.2f'|escape:'javascript'}",
      "priceCurrency": "UAH"
    }
    {/foreach}
  ]
}
</script>
```

---

## 6. МОБІЛЬНА ВЕРСІЯ — ЧЕКАУТ

### 6.1 Пріоритети для mobile

- **Order Summary** — зверху, до форми. Покупець бачить що купує перш ніж заповнювати форму.
- **Кнопка «Підтвердити»** — повна ширина, великий padding (min 56px висота).
- **Поля форми** — `font-size: 16px` мінімум, щоб iOS не збільшував масштаб при фокусі.
- **Клавіатура** — правильні `type` і `autocomplete` для кожного поля.

### 6.2 Типи полів і autocomplete

| Поле | `type` | `autocomplete` | `inputmode` |
|---|---|---|---|
| Ім'я | `text` | `given-name` | — |
| Прізвище | `text` | `family-name` | — |
| Email | `email` | `email` | `email` |
| Телефон | `tel` | `tel` | `tel` |
| Індекс | `text` | `postal-code` | `numeric` |
| Місто | `text` | `address-level2` | — |
| Номер відділення НП | `text` | `off` | `numeric` |
| Картка (через шлюз) | — | Handled by payment gateway | — |

**⚠️ Автозаповнення:** правильні `autocomplete` атрибути — iOS/Android заповнюють форму автоматично з Keychain/Google Passwords. Це зменшує час заповнення на 60–70% (Baymard 2025).

### 6.3 Sticky кнопка підтвердження на mobile

```css
@media (max-width: 767px) {
  .checkout-confirm__submit {
    position: sticky;
    bottom: calc(var(--mobile-bottom-nav-height) + 0.75rem);
    left: 0;
    right: 0;
    width: 100%;
    z-index: 50;
    box-shadow: 0 -4px 16px oklch(22% 0.02 145 / 0.15);
  }
}
```

---

## 7. CORE WEB VITALS — ЧЕКАУТ

| Метрика | Ціль | Що впливає | Рішення |
|---|---|---|---|
| LCP | ≤ 2.5s | Order Summary з зображеннями товарів | `loading="lazy"` для cart images |
| CLS | ≤ 0.1 | Форми платіжного шлюзу | `min-height` на контейнері форми |
| INP | ≤ 200ms | Перемикання методів доставки/оплати | Легкий JS toggle без перезавантаження |
| FCP | ≤ 1.8s | Спрощений checkout header | Без зовнішніх шрифтів у чекауті |

**Важливо для чекауту:** платіжні шлюзи (WayForPay, LiqPay) підключають зовнішні JS-скрипти. Використовувати `async` або `defer` де можливо. Якщо шлюз вимагає синхронного JS — прийнятно тільки для поля картки.

---

## 8. БЕЗПЕКА ТА ПРАВОВІ ВИМОГИ

### 8.1 GDPR / PSGDPR

- Чекбокс згоди на обробку персональних даних — **обов'язково** на кроці підтвердження.
- Посилання на Політику конфіденційності — відкривати в `target="_blank"`.
- Модуль `psgdpr` вже встановлений у PS9 — переконатись що підключений.

### 8.2 Закон України про захист персональних даних

На сторінці чекауту обов'язково:
- Повідомлення «Ваші дані використовуються виключно для обробки замовлення»
- Посилання на Політику конфіденційності
- Чекбокс згоди (якщо збираєте для маркетингу — окремий чекбокс)

### 8.3 HTTPS і PCI DSS

- Весь чекаут — тільки HTTPS. `<meta name="robots" content="noindex, nofollow">` — обов'язково.
- Дані картки **ніколи** не проходять через PS9 — тільки через платіжний шлюз (WayForPay/LiqPay). Це PCI DSS Compliant за замовчуванням при правильному підключенні.

---

## 9. ФАЙЛИ ДЛЯ СТВОРЕННЯ В v0.8.0

```
templates/checkout/
├── checkout.tpl                    ⬜ one-page чекаут
├── cart.tpl                        ⬜ сторінка кошика
└── order-confirmation.tpl          ⬜ сторінка підтвердження

assets/css/pages/
└── checkout.css                    ⬜ v0.14.0 (спільно для cart + checkout)

assets/js/pages/
└── checkout.js                     ⬜ v0.14.0
    — accordion кроків
    — toggle адресних форм доставки
    — toggle форм оплати
    — qty stepper в кошику (переиспользати cart.js)
    — voucher form toggle
    — guest password toggle

templates/_partials/microdata/
└── (inline в order-confirmation.tpl)  ⬜ Schema Order
```

**Залежності v0.8.0:**
```
catalog/listing/product-miniature.tpl    ✅ v0.6.0 — cross-sell в кошику
catalog/listing/_partials/rating-stars.tpl ✅ v0.6.0
_partials/breadcrumb.tpl                  ✅ v0.5.1
_partials/notifications.tpl               ✅ v0.5.1
assets/css/theme.css                      ✅ v0.6.1
psgdpr                                    ← перевірити підключення
ps_cashondelivery                         ← накладений платіж
ps_wirepayment                            ← банківський переказ
WayForPay або LiqPay модуль              ← встановити + налаштувати
novaposhta модуль                         ← встановити для API відділень
```

---

## 10. ЗВЕДЕНА ТАБЛИЦЯ РІШЕНЬ

| Питання | Рішення | Обґрунтування |
|---|---|---|
| Тип чекауту | One-page (accordion) | −21% відмов на mobile (Baymard 2025) |
| Реєстрація | Guest checkout + пропозиція після | Обов'язкова = причина №1 відмов (37%) |
| Cross-sell | Тільки в кошику | В чекауті = +14% відмов (NNG 2024) |
| Порядок оплати | G.Pay/A.Pay → Картка → Частини → НП | Від найшвидшого до найповільнішого |
| Порядок доставки | НП відділення → НП кур'єр → НП поштомат → Укрпошта → Кур'єр Київ → Самовивіз | За популярністю в Україні |
| Header у чекауті | Спрощений (лого + замок) | +17% completion rate (Baymard 2025) |
| Order Summary | Sticky aside desktop / зверху mobile | Покупець бачить що купує |
| Autocomplete | Всі поля з правильними атрибутами | −60% часу заповнення (Baymard 2025) |
| Нова Пошта | API інтеграція (автодоповнення) | Без API → помилки у адресах |
| HTTPS | Обов'язково + noindex | PCI DSS + SEO (чекаут не індексується) |

---

*Документ складено на основі: Baymard Institute Checkout UX Benchmark (2025),
Baymard Cart UX (2025), Nielsen Norman Group (2024),
Google Core Web Vitals (2025–2026), W3C WCAG 2.2,
Закон України «Про захист персональних даних»,
GDPR / psgdpr PrestaShop,
аналізу платіжних шлюзів України (WayForPay, LiqPay, Fondy),
специфіки Нової Пошти API,
PROJECT.md, CATALOG-0.6.0, PRODUCT-0.7.0, HOME-0.5.x (березень 2026).*
