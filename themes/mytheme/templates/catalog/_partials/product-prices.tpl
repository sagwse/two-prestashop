{**
 * product-prices.tpl — Блок цен на странице товара
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
 *   $product.price               — текущая цена (отформатирована PS9, с символом валюты)
 *   $product.regular_price        — оригинальная цена до скидки
 *   $product.has_discount (bool)  — есть ли скидка
 *   $product.discount_percentage  — процент скидки (строка: «-15%»)
 *   $product.discount_amount      — абсолютный размер скидки
 *   $product.unit_price           — цена за единицу (отформатированная)
 *   $product.unit_price_ratio     — коэффициент (>0 → показывать unit_price)
 *   $product.unit_price_unit      — единица измерения (капс., г, мл)
 *   $product.price_amount         — числовая цена float (для JSON-LD, не рендерим)
 *
 * Макет:
 *   ┌─────────────────────────────────────┐
 *   │  ~~1 200 грн~~   980 грн     -18%   │  ← старая + новая + % скидки
 *   │  ≈ 16.33 грн за капс.               │  ← цена за единицу
 *   └─────────────────────────────────────┘
 *
 * Размеры и цвета (из PRODUCT-0.7.0-recommendations.md, секция 4):
 *   Текущая цена: clamp(1.5rem, 2.5vw, 2rem), font-weight: 800
 *   Скидочная цена: var(--color-discount)
 *   Старая цена: 1rem, var(--color-text-secondary), line-through
 *   Бейдж скидки: pill, var(--color-discount-bg), border var(--color-discount)
 *   Цена за единицу: 0.8125rem, var(--color-text-muted)
 *
 * Налоги (Украина):
 *   $product.price уже включает НДС — настраивается в BO.
 *
 * CSS: product.css (v0.14.0)
 *}


{* ─────────────────────────────────────────────────────────────────────────────
   ПРЕДВАРИТЕЛЬНЫЕ ВЫЧИСЛЕНИЯ
   ───────────────────────────────────────────────────────────────────────────── *}

{* Флаг наличия скидки *}
{assign var='has_discount' value=false}
{if isset($product.has_discount) && $product.has_discount}
  {assign var='has_discount' value=true}
{/if}


{* ═══════════════════════════════════════════════════════════════════════════
   РАЗМЕТКА БЛОКА ЦЕН
   itemprop/itemscope не используем — данные есть в JSON-LD (schema-product.tpl).
   Цены выводим без escape — PS9 форматирует как безопасный текст.
   ═══════════════════════════════════════════════════════════════════════════ *}
<div class="product-prices" id="js-product-prices">

  {* ── Строка цен: [старая] [текущая] [бейдж скидки] ──────────────────── *}
  <div class="product-prices__row">

    {* Старая цена — перечёркнутая. Показываем только при скидке. *}
    {if $has_discount}
      <del class="product-prices__old">
        {$product.regular_price}
      </del>
    {/if}

    {* Текущая цена — основной CTA. Крупный шрифт, жирный.
       Модификатор --discounted окрашивает в var(--color-discount). *}
    <span class="product-prices__current{if $has_discount} product-prices__current--discounted{/if}">
      {$product.price}
    </span>

    {* Бейдж скидки — процент или текст «Знижка».
       Pill-форма: border-radius: var(--radius-pill). *}
    {if $has_discount}
      <span class="product-prices__discount-badge">
        {if isset($product.discount_percentage) && $product.discount_percentage}
          -{$product.discount_percentage|escape:'html':'UTF-8'}
        {else}
          {l s='Знижка' d='Shop.Theme.Catalog'}
        {/if}
      </span>
    {/if}

  </div>{* /.product-prices__row *}


  {* ── Цена за единицу ────────────────────────────────────────────────────
     Показываем если unit_price_ratio > 0 (заполнено в BO: Каталог → Товар → Ціни).
     Пример: «≈ 4.50 ₴ за капс.»
     ─────────────────────────────────────────────────────────────────────── *}
  {if isset($product.unit_price_ratio) && $product.unit_price_ratio > 0}
    {if isset($product.unit_price) && $product.unit_price}
      <span class="product-prices__unit">
        ≈ {$product.unit_price}
        {if isset($product.unit_price_unit) && $product.unit_price_unit}
          {l s='за' d='Shop.Theme.Catalog'} {$product.unit_price_unit|escape:'html':'UTF-8'}
        {/if}
      </span>
    {/if}
  {/if}


  {* ── Информация о налоге (опционально) ─────────────────────────────────
     Для B2C Украина — НДС включён. Можно раскомментировать при необходимости.
  {if isset($product.tax_name) && $product.tax_name}
    <span class="product-prices__tax">
      {l s='Включаючи' d='Shop.Theme.Catalog'} {$product.tax_name|escape:'html':'UTF-8'}
    </span>
  {/if}
  *}

</div>{* /.product-prices *}