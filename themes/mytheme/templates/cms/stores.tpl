{**
 * cms/stores.tpl — Магазины
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Наші магазини' d='Shop.Theme.Global'}
{/block}

{block name='page_content'}
  {hook h='displayStoreContent'}
{/block}
