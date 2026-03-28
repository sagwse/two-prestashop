{**
 * product-add-to-cart.tpl — Кнопка «До кошика» + количество + sticky bar
 *
 * Версия темы : mytheme v0.7.0
 * PrestaShop  : 9.0.x
 * PHP         : 8.4.x
 * Шаблонизатор: Smarty
 *
 * Вызывается из:
 *   catalog/product.tpl (v0.7.0) — покупательская панель (правая колонка)
 *
 * Получаемые параметры (из product.tpl, переменная $product):
 *   $product.id_product            — ID товара
 *   $product.id_product_attribute  — ID комбинации (0 если простой товар)
 *   $product.quantity              — доступное количество
 *   $product.minimal_quantity      — минимальный заказ
 *   $product.availability          — 'available' | 'last_remaining_items' | 'unavailable'
 *   $product.add_to_cart_url       — URL для AJAX добавления
 *   $product.name                  — название (для aria-label)
 *   $product.price                 — текущая цена (для sticky bar)
 *   $product.has_combinations      — есть ли варианты
 *
 * Анатомия:
 *
 *   Desktop (в потоке покупательской панели):
 *   ┌──────────────┬─────────────────────────────────────┐
 *   │  [ - ] 1 [ + ]  │    [  🛒  До кошика  ]          │
 *   │  qty stepper     │    (полная ширина кнопки)       │
 *   └──────────────┴─────────────────────────────────────┘
 *
 *   Mobile (sticky bottom bar):
 *   ┌─────────────────────────────────────────────────────┐
 *   │   980 грн    │          До кошика                   │
 *   │  (текущая)   │          (70% ширины)                │
 *   └─────────────────────────────────────────────────────┘
 *        ↑ safe-area-inset-bottom (iPhone notch)
 *
 * Qty stepper:
 *   Минус / поле / плюс — три элемента в строку
 *   Минимум: $product.minimal_quantity (минимум 1)
 *   Максимум: $product.quantity (если ограничен)
 *   type="number", inputmode="numeric" (мобильная клавиатура)
 *   Touch targets: min 44×44px
 *
 * Кнопка «До кошика»:
 *   data-button-action="add-to-cart" — стандартный PS9 атрибут
 *   Высота: 52px (крупнее чем в листинге — главный CTA страницы)
 *   Иконка: fa-cart-plus + текст
 *   После добавления: текст «✓ Додано до кошика» на 2s (JS v0.14.0)
 *
 * Sticky bar (mobile):
 *   position: fixed, z-index: 1025
 *   bottom: calc(var(--mobile-bottom-nav-height) + env(safe-area-inset-bottom))
 *   Появление: JS IntersectionObserver на #product-add-to-cart-form
 *   Класс .is-visible: transform: translateY(0)
 *
 * CSS: product.css (v0.14.0)
 * JS:  product.js (v0.14.0)
 *}


{* ─────────────────────────────────────────────────────────────────────────────
   ПРЕДВАРИТЕЛЬНЫЕ ВЫЧИСЛЕНИЯ
   ───────────────────────────────────────────────────────────────────────────── *}

{* Флаг товара «не в наличии» *}
{assign var='out_of_stock' value=false}
{if isset($product.availability) && $product.availability === 'unavailable'}
  {assign var='out_of_stock' value=true}
{/if}

{* Минимальное количество для заказа *}
{assign var='min_qty' value=1}
{if isset($product.minimal_quantity) && $product.minimal_quantity > 1}
  {assign var='min_qty' value=$product.minimal_quantity|intval}
{/if}

{* Максимальное количество (если ограничено) *}
{assign var='max_qty' value=''}
{if isset($product.quantity) && $product.quantity > 0}
  {assign var='max_qty' value=$product.quantity|intval}
{/if}

{* Последние единицы на складе *}
{assign var='last_remaining' value=false}
{if isset($product.availability) && $product.availability === 'last_remaining_items'}
  {assign var='last_remaining' value=true}
{/if}


{* ═══════════════════════════════════════════════════════════════════════════
   ФОРМА ДОБАВЛЕНИЯ В КОРЗИНУ
   Стандартная PS9 форма — prestashop.js перехватывает submit.
   id="product-add-to-cart-form" — используется JS для IntersectionObserver.
   ═══════════════════════════════════════════════════════════════════════════ *}
<form action="{$product.add_to_cart_url|escape:'html':'UTF-8'}" method="post" id="product-add-to-cart-form"
  class="product-add-to-cart">

  {* Hidden fields — обязательны для PS9 *}
  <input type="hidden" name="token" value="{$static_token|escape:'html':'UTF-8'}">
  <input type="hidden" name="id_product" value="{$product.id_product|intval}" id="product_page_product_id">
  <input type="hidden" name="id_product_attribute" value="{$product.id_product_attribute|intval|default:0}"
    id="product_page_product_attribute_id">
  <input type="hidden" name="id_customization"
    value="{if isset($product.id_customization)}{$product.id_customization|intval}{else}0{/if}"
    id="product_customization_id">


  {* ── QUANTITY STEPPER ───────────────────────────────────────────────────
     Три элемента в строку: [-] [input] [+].
     Скрыт если товар not available.
     Touch targets: 44×44px минимум (Apple HIG / Material You).
     ─────────────────────────────────────────────────────────────────────── *}
  {if !$out_of_stock}
    <div class="product-add-to-cart__qty" id="js-qty-stepper">

      <label for="quantity_wanted" class="visually-hidden">
        {l s='Кількість' d='Shop.Theme.Catalog'}
      </label>

      {* Кнопка минус *}
      <button class="product-add-to-cart__qty-btn product-add-to-cart__qty-btn--minus" type="button"
        data-action="qty-decrease" aria-label="{l s='Зменшити кількість' d='Shop.Theme.Catalog'}" {if $min_qty >= 1}
        disabled{/if}>
        <i class="fa-solid fa-minus" aria-hidden="true"></i>
      </button>

      {* Поле ввода количества *}
      <input class="product-add-to-cart__qty-input" type="number" name="qty" id="quantity_wanted" value="{$min_qty}"
        min="{$min_qty}" {if $max_qty}max="{$max_qty}" {/if} inputmode="numeric" pattern="[0-9]*"
        aria-label="{l s='Кількість' d='Shop.Theme.Catalog'}">

      {* Кнопка плюс *}
      <button class="product-add-to-cart__qty-btn product-add-to-cart__qty-btn--plus" type="button"
        data-action="qty-increase" aria-label="{l s='Збільшити кількість' d='Shop.Theme.Catalog'}">
        <i class="fa-solid fa-plus" aria-hidden="true"></i>
      </button>

    </div>{* /.product-add-to-cart__qty *}
  {/if}


  {* ── КНОПКА «ДО КОШИКА» ────────────────────────────────────────────────
     Три состояния:
       1. В наличии (простой): data-button-action="add-to-cart"
       2. Не в наличии: disabled
       3. Останнє — «Останні одиниці» (last_remaining_items): обычная кнопка + badge
     Высота: 52px — крупнее листинга, главный CTA страницы.
     ─────────────────────────────────────────────────────────────────────── *}

  {if $out_of_stock}

    {* Товар не в наличии *}
    <button class="product-add-to-cart__btn product-add-to-cart__btn--unavailable" type="button" disabled
      aria-disabled="true">
      <i class="fa-solid fa-ban me-2" aria-hidden="true"></i>
      {l s='Немає в наявності' d='Shop.Theme.Catalog'}
    </button>

  {else}

    {* Товар в наличии — добавление в корзину *}
    <button class="product-add-to-cart__btn" type="submit" data-button-action="add-to-cart"
      aria-label="{l s='Додати до кошика: %name%' sprintf=['%name%' => $product.name|escape:'html':'UTF-8'] d='Shop.Theme.Catalog'}">
      {* Иконка корзины — CSS: .is-animating { transform: scale(1.2) } *}
      <i class="fa-solid fa-cart-plus product-add-to-cart__cart-icon me-2" aria-hidden="true"></i>

      {* Текст кнопки — JS меняет на «✓ Додано до кошика» на 2s *}
      <span class="product-add-to-cart__btn-text">
        {l s='До кошика' d='Shop.Theme.Catalog'}
      </span>

      {* Скрытый текст подтверждения для скринридера *}
      <span class="product-add-to-cart__confirm visually-hidden" role="status" aria-live="polite"
        aria-atomic="true"></span>
    </button>

    {* Предупреждение «Останні одиниці» *}
    {if $last_remaining}
      <p class="product-add-to-cart__last-items" role="status">
        <i class="fa-solid fa-triangle-exclamation me-1" aria-hidden="true"></i>
        {l s='Залишилось кілька одиниць!' d='Shop.Theme.Catalog'}
      </p>
    {/if}

  {/if}

</form>{* /#product-add-to-cart-form *}


{* ═══════════════════════════════════════════════════════════════════════════
   STICKY BOTTOM BAR (mobile)
   Фиксированная панель внизу экрана: цена + кнопка «До кошика».
   bottom: calc(var(--mobile-bottom-nav-height) + env(safe-area-inset-bottom))
   — отображается НАД контентом страницы, но ПОД навигационным баром.
   Появление: JS добавляет .is-visible (IntersectionObserver на #product-add-to-cart-form).
   По умолчанию: transform: translateY(100%) — скрыт.
   ═══════════════════════════════════════════════════════════════════════════ *}
{if !$out_of_stock}
  <div class="product-sticky-bar" id="js-product-sticky-bar" aria-hidden="true">

    {* Текущая цена *}
    <span class="product-sticky-bar__price" id="js-sticky-price">
      {$product.price}
    </span>

    {* Кнопка — дублирует основную, упрощённая версия *}
    <button class="product-sticky-bar__btn" type="button" data-button-action="add-to-cart"
      data-product-id="{$product.id_product|intval}"
      data-product-attribute-id="{$product.id_product_attribute|intval|default:0}"
      aria-label="{l s='Додати до кошика' d='Shop.Theme.Catalog'}">
      <i class="fa-solid fa-cart-plus me-2" aria-hidden="true"></i>
      <span class="product-sticky-bar__btn-text">
        {l s='До кошика' d='Shop.Theme.Catalog'}
      </span>
    </button>

  </div>{* /.product-sticky-bar *}
{/if}