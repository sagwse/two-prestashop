{**
 * address.tpl — Добавление/редактирование адреса
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Адреса' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {render file='customer/_partials/address-form.tpl' ui=$address_form}
{/block}
