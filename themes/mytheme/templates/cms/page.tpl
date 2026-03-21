{**
 * cms/page.tpl — CMS страница
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {$cms.meta_title}
{/block}

{block name='page_content'}
  {$cms.content nofilter}
{/block}
