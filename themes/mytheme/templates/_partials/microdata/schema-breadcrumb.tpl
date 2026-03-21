{**
 * schema-breadcrumb.tpl
 * MyShop — PrestaShop 9.0 Theme · v0.4.0
 *
 * Schema   : BreadcrumbList
 * Где      : _partials/head.tpl — на всех страницах, где есть хлебные крошки
 * Хук      : нет (глобальная схема, не через displaySchemaMarkup)
 *
 * PS9 Smarty-переменные:
 *   $breadcrumb.links — массив объектов [{title, url}, ...]
 *     Гарантировано доступен на всех страницах кроме главной.
 *     Главная страница: $breadcrumb.links пустой или содержит только "Home".
 *
 * Как подключается в head.tpl:
 *   {if isset($breadcrumb.links) && $breadcrumb.links|@count > 0}
 *     {include file='_partials/microdata/schema-breadcrumb.tpl'}
 *   {/if}
 *
 * Примечание по «текущей» странице:
 *   Последний элемент BreadcrumbList по спецификации Google не обязан иметь "item" (URL).
 *   Но включение URL во все элементы — допустимо и рекомендуется для полноты данных.
 *}

{if isset($breadcrumb.links) && $breadcrumb.links|@count > 0}
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {foreach from=$breadcrumb.links item=_link name=_bc}
    {
      "@type": "ListItem",
      "position": {$smarty.foreach._bc.index + 1},
      "name": "{$_link.title|escape:'javascript'}",
      "item": "{$_link.url|escape:'javascript'}"
    }{if !$smarty.foreach._bc.last},{/if}
    {/foreach}
  ]
}
</script>
{/if}
