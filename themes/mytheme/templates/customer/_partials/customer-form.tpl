{**
 * customer-form.tpl — Форма регистрации/профиля
 * mytheme v0.7.1 — PS9 stub
 *}
{block name='customer_form'}
  <form action="{$action}" method="post">
    <div>
      {foreach from=$formFields item="field"}
        {block name='form_field'}
          {include file='_partials/form-fields.tpl' field=$field}
        {/block}
      {/foreach}
    </div>

    {block name='customer_form_footer'}
      <button class="btn btn-primary" type="submit" data-link-action="save-customer">
        {l s='Зберегти' d='Shop.Theme.Actions'}
      </button>
    {/block}
  </form>
{/block}
