{**
 * schema-product.tpl
 * MyShop — PrestaShop 9.0 Theme · v0.4.0
 *
 * Schema   : Product · Offer · AggregateRating (если есть отзывы)
 * Где      : catalog/product.tpl (страница товара)
 * Хук      : displaySchemaMarkup — добавить в product.tpl:
 *              {hook h='displaySchemaMarkup'}
 *            ИЛИ напрямую:
 *              {include file='_partials/microdata/schema-product.tpl'}
 *
 * PS9 Smarty-переменные:
 *   $product.id, $product.name, $product.description_short
 *   $product.reference (SKU), $product.ean13, $product.isbn, $product.upc, $product.mpn
 *   $product.manufacturer_name (бренд)
 *   $product.cover.large.url     — главное изображение
 *   $product.cover.id_image      — id главного изображения (для дедупликации)
 *   $product.images[]            — все изображения (id_image, large.url, ...)
 *   $product.price_amount        — числовая цена float, с налогами (B2C)
 *   $product.has_discount (bool), $product.reduction_from, $product.reduction_to ('Y-m-d')
 *   $product.availability        — 'available' | 'last_remaining_items' | 'out_of_stock'
 *   $product.condition           — 'new' | 'used' | 'refurbished'
 *   $product.url                 — канонический URL
 *   $product.comment_count       — кол-во отзывов (ps_productcomments)
 *   $product.comment_average     — средняя оценка (ps_productcomments)
 *   $currency.iso_code           — напр. 'UAH'
 *   $urls.base_url
 *
 * ЗАВИСИМОСТИ:
 *   aggregateRating — ТОЛЬКО при наличии модуля ps_productcomments.
 *   Блок безопасно пропускается если $product.comment_count == 0 или не задан.
 *}

{* ── Маппинг доступности PS9 → schema.org ── *}
{if $product.availability == 'available' || $product.availability == 'last_remaining_items'}
  {assign var='_avail' value='https://schema.org/InStock'}
{elseif $product.availability == 'out_of_stock'}
  {assign var='_avail' value='https://schema.org/OutOfStock'}
{else}
  {assign var='_avail' value='https://schema.org/InStock'}
{/if}

{* ── Маппинг состояния товара → schema.org ── *}
{if $product.condition == 'used'}
  {assign var='_cond' value='https://schema.org/UsedCondition'}
{elseif $product.condition == 'refurbished'}
  {assign var='_cond' value='https://schema.org/RefurbishedCondition'}
{else}
  {assign var='_cond' value='https://schema.org/NewCondition'}
{/if}

<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Product",
    "@id": "{$product.url|escape:'javascript'}#product",
    "name": "{$product.name|escape:'javascript'}",
    "description": "{$product.description_short|strip_tags|trim|escape:'javascript'}",
    "url": "{$product.url|escape:'javascript'}",

    "image": [
      "{$product.cover.large.url|escape:'javascript'}"
      {foreach from=$product.images item=_img}
        {if $_img.id_image != $product.cover.id_image}
          , "{$_img.large.url|escape:'javascript'}"
        {/if}
      {/foreach}
    ],

    "sku": "{$product.reference|escape:'javascript'}"{if $product.ean13 && $product.ean13 != ''},
      "gtin13": "{$product.ean13|escape:'javascript'}"{/if}{if $product.isbn && $product.isbn != ''},
      "isbn": "{$product.isbn|escape:'javascript'}"{/if}{if $product.upc && $product.upc != ''},
      "gtin12": "{$product.upc|escape:'javascript'}"{/if}{if $product.mpn && $product.mpn != ''},
      "mpn": "{$product.mpn|escape:'javascript'}"{/if}{if $product.manufacturer_name},
      "brand": {
        "@type": "Brand",
        "name": "{$product.manufacturer_name|escape:'javascript'}"
      }{/if},

      "itemCondition": "{$_cond}",

      "offers": {
        "@type": "Offer",
        "@id": "{$product.url|escape:'javascript'}#offer",
        "url": "{$product.url|escape:'javascript'}",
        "priceCurrency": "{$currency.iso_code|escape:'javascript'}",
        "price": "{$product.price_amount}",
        {*
        price_amount— float c налогами для B2C магазина.
        Для B2B(цены без НДС) замените на $product.price_amount_without_tax.
        priceValidUntil нужен ТОЛЬКО при акции с конкретной датой окончания.*
      }
      "availability": "{$_avail}",
      "itemCondition": "{$_cond}",
      "seller": {
        "@id": "{$urls.base_url}#organization"
        }{if $product.has_discount && $product.reduction_to && $product.reduction_to != ''},
        "priceValidUntil": "{$product.reduction_to|escape:'javascript'}",
        "priceSpecification": {
          "@type": "UnitPriceSpecification",
          "price": "{$product.price_amount}",
          "priceCurrency": "{$currency.iso_code|escape:'javascript'}",
          "validFrom": "{$product.reduction_from|escape:'javascript'}",
          "validThrough": "{$product.reduction_to|escape:'javascript'}"
          }{/if}
        }

        {* ── AggregateRating — только если есть отзывы (зависимость: ps_productcomments) ── *}
        {if isset($product.comment_count) && $product.comment_count > 0},
          "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "{$product.comment_average}",
            "reviewCount": "{$product.comment_count}",
            "bestRating": "5",
            "worstRating": "1"
          }
        {/if}

      }
</script>