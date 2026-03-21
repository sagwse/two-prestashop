{**
 * login-form.tpl — Форма входа
 * mytheme v0.7.1 — PS9 stub
 *}
{block name='login_form'}
  <form id="login-form" action="{$action}" method="post">
    <div>
      {foreach from=$formFields item="field"}
        {block name='form_field'}
          {include file='_partials/form-fields.tpl' field=$field}
        {/block}
      {/foreach}
    </div>

    {block name='login_form_footer'}
      <div class="mb-3">
        <a href="{$urls.pages.password}" rel="nofollow">
          {l s='Забули пароль?' d='Shop.Theme.Customeraccount'}
        </a>
      </div>
      <button class="btn btn-primary" type="submit" data-link-action="sign-in">
        {l s='Увійти' d='Shop.Theme.Actions'}
      </button>
    {/block}
  </form>
{/block}
