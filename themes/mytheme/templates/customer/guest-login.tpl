{**
 * guest-login.tpl — Гостевой вход
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Гостьовий вхід' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {render file='customer/_partials/login-form.tpl' ui=$login_form}
{/block}
