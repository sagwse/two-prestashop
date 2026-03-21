{**
 * errors/forbidden.tpl — Доступ запрещён
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Доступ заборонено' d='Shop.Theme.Global'}
{/block}

{block name='page_content'}
  <div class="text-center py-5">
    <p style="font-size: 5rem; font-weight: 800; color: oklch(65% 0 0)">403</p>
    <p>{l s='У вас немає прав для перегляду цієї сторінки.' d='Shop.Theme.Global'}</p>
  </div>
{/block}
