{**
 * errors/404.tpl — Страница 404
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Сторінку не знайдено' d='Shop.Theme.Global'}
{/block}

{block name='page_content'}
  {include file='errors/not-found.tpl'}
{/block}
