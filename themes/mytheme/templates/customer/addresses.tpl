{**
 * addresses.tpl — Список адресов
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Мої адреси' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {if isset($customer.addresses) && $customer.addresses|@count > 0}
    {foreach from=$customer.addresses item=address}
      <div class="address-card">
        <p>{$address.formatted|nl2br nofilter}</p>
        <a href="{$address.update_url}" class="btn btn-sm btn-outline-primary">{l s='Редагувати' d='Shop.Theme.Actions'}</a>
        <a href="{$address.delete_url}" class="btn btn-sm btn-outline-danger" data-link-action="delete-address">{l s='Видалити' d='Shop.Theme.Actions'}</a>
      </div>
    {/foreach}
  {/if}
  <a href="{$urls.pages.address}" class="btn btn-primary">
    <i class="fa-solid fa-plus me-2" aria-hidden="true"></i>
    {l s='Додати нову адресу' d='Shop.Theme.Actions'}
  </a>
{/block}
