{**
 * registration.tpl — Регистрация
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Створити акаунт' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {render file='customer/_partials/customer-form.tpl' ui=$register_form}
{/block}
