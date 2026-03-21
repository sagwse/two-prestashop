{**
 * identity.tpl — Профиль пользователя
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Особисті дані' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {render file='customer/_partials/customer-form.tpl' ui=$customer_form}
{/block}
