{**
 * errors/restricted-country.tpl — Ограничение по стране
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Обмежений доступ' d='Shop.Theme.Global'}
{/block}

{block name='page_content'}
  <div class="text-center py-5">
    <i class="fa-solid fa-earth-americas fa-3x mb-3" style="color: oklch(65% 0 0)" aria-hidden="true"></i>
    <p>{l s='На жаль, цей магазин недоступний у вашому регіоні.' d='Shop.Theme.Global'}</p>
  </div>
{/block}
