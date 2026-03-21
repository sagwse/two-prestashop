{**
 * authentication.tpl — Вход в аккаунт
 * mytheme v0.7.1 — PS9 stub (полная реализация → v0.9.0)
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Увійти' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  <div class="login-form">
    {render file='customer/_partials/login-form.tpl' ui=$login_form}

    <hr>

    {hook h='displayCustomerLoginFormAfter'}

    <div class="login-form__register">
      <h2>{l s='Немає акаунту?' d='Shop.Theme.Customeraccount'}</h2>
      <a href="{$urls.pages.register}" class="btn btn-outline-primary" data-link-action="display-register-form">
        {l s='Створити акаунт' d='Shop.Theme.Actions'}
      </a>
    </div>
  </div>
{/block}
