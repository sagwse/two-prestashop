{**
 * schema-category.tpl
 * MyShop — PrestaShop 9.0 Theme · v0.4.0
 *
 * Schema   : ItemList (список товаров категории)
 * Где      : catalog/listing/category.tpl (страница категории)
 * Хук      : displaySchemaMarkup — добавить в category.tpl:
 *              {hook h='displaySchemaMarkup'}
 *            ИЛИ напрямую:
 *              {include file='_partials/microdata/schema-category.tpl'}
 *
 * PS9 Smarty-переменные:
 *   $category.name           — название категории
 *   $category.description    — описание категории (HTML)
 *   $category.image.large.url — изображение категории (опц.)
 *   $listing.products[]      — массив товаров на текущей странице
 *     ._product.name         — название товара
 *     ._product.url          — URL товара
 *     ._product.cover.medium.url — изображение (миниатюра)
 *     ._product.price_amount — числовая цена
 *   $urls.current_url        — URL текущей страницы
 *   $currency.iso_code       — код валюты
 *
 * Примечание по ItemList:
 *   Google рекомендует 2 варианта ItemList для интернет-магазинов:
 *   1. Summary page (ItemList с URL-only) — минимальные данные, Google сам обходит страницы.
 *   2. Carousel (ItemList с вложенными Product) — полные данные прямо в листинге.
 *   Здесь используется вариант 1 (URL-only) как наиболее безопасный и лёгкий.
 *   Для варианта 2 (carousel) раскомментируйте блок ниже и уберите "url"-only вариант.
 *}

{if isset($listing.products) && $listing.products|@count > 0}
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "ItemList",
      "name": "{$category.name|escape:'javascript'}",
      "url": "{$urls.current_url|escape:'javascript'}"{if isset($category.description) && $category.description},
      "description": "{$category.description|strip_tags|trim|escape:'javascript'}"{/if},

      "numberOfItems": {$listing.products|@count},

      "itemListElement": [
        {foreach from=$listing.products item=_product name=_cat_list}
          {
            "@type": "ListItem",
            "position": {$smarty.foreach._cat_list.index + 1},
            "url": "{$_product.url|escape:'javascript'}"

            {*
            ──ВАРИАНТ 2: Carousel(Product embedded)──
            Раскомментируйте блок ниже и удалите строку "url": выше,
            если нужен
            расширенный вариант с вложенными Product - объектами.
            Внимание: увеличивает размер страницы при большом кол - ве товаров.

              ,
            "item": {
              "@type": "Product",
              "name": "{$_product.name|escape:'javascript'}",
              "url": "{$_product.url|escape:'javascript'}",
              "image": "{$_product.cover.medium.url|escape:'javascript'}",
              "offers": {
                "@type": "Offer",
                "price": "{$_product.price_amount}",
                "priceCurrency": "{$currency.iso_code|escape:'javascript'}",
                "availability": "https://schema.org/InStock"
              }
            }
            *
          }
          }{if !$smarty.foreach._cat_list.last},{/if}
        {/foreach}
      ]
    }
  </script>
{/if}