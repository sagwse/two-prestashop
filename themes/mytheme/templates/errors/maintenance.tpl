{**
 * errors/maintenance.tpl — Режим обслуживания
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Технічне обслуговування' d='Shop.Theme.Global'}
{/block}

{block name='page_content'}
  <div class="maintenance text-center py-5">
    <i class="fa-solid fa-wrench fa-3x mb-3" style="color: oklch(70% 0.15 85)" aria-hidden="true"></i>
    <h2>{l s='Магазин тимчасово зачинено на обслуговування.' d='Shop.Theme.Global'}</h2>
    <p>{l s='Ми скоро повернемося. Дякуємо за терпіння!' d='Shop.Theme.Global'}</p>
    {hook h='displayMaintenance'}
  </div>
{/block}
