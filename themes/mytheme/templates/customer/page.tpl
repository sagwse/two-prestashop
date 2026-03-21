{**
 * customer/page.tpl — Базовый шаблон customer pages
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_content'}
  {block name='customer_page_content'}
    {$smarty.block.child}
  {/block}
{/block}
