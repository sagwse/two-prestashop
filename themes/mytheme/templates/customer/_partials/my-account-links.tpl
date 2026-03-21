{**
 * my-account-links.tpl — Меню личного кабинета
 * mytheme v0.7.1 — PS9 stub
 *}
<div class="my-account-links">
  <a href="{$urls.pages.identity}" class="my-account-links__item">
    <i class="fa-solid fa-user me-2" aria-hidden="true"></i>
    {l s='Особисті дані' d='Shop.Theme.Customeraccount'}
  </a>
  <a href="{$urls.pages.addresses}" class="my-account-links__item">
    <i class="fa-solid fa-location-dot me-2" aria-hidden="true"></i>
    {l s='Мої адреси' d='Shop.Theme.Customeraccount'}
  </a>
  <a href="{$urls.pages.history}" class="my-account-links__item">
    <i class="fa-solid fa-clock-rotate-left me-2" aria-hidden="true"></i>
    {l s='Історія замовлень' d='Shop.Theme.Customeraccount'}
  </a>
  <a href="{$urls.pages.order_follow}" class="my-account-links__item">
    <i class="fa-solid fa-truck me-2" aria-hidden="true"></i>
    {l s='Відстеження замовлення' d='Shop.Theme.Customeraccount'}
  </a>
  <a href="{$urls.pages.discount}" class="my-account-links__item">
    <i class="fa-solid fa-ticket me-2" aria-hidden="true"></i>
    {l s='Мої знижки' d='Shop.Theme.Customeraccount'}
  </a>
  <a href="{$urls.pages.order_slip}" class="my-account-links__item">
    <i class="fa-solid fa-file-invoice me-2" aria-hidden="true"></i>
    {l s='Кредитні чеки' d='Shop.Theme.Customeraccount'}
  </a>

  {hook h='displayMyAccountBlock'}

  <a href="{$urls.actions.logout}" class="my-account-links__item my-account-links__item--logout">
    <i class="fa-solid fa-right-from-bracket me-2" aria-hidden="true"></i>
    {l s='Вийти' d='Shop.Theme.Customeraccount'}
  </a>
</div>
