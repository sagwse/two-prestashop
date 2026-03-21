{**
 * cms/sitemap.tpl — Карта сайта
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Карта сайту' d='Shop.Theme.Global'}
{/block}

{block name='page_content'}
  {hook h='displaySitemapContent'}
{/block}
