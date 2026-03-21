{**
 * order-slip.tpl — Кредитні чеки
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Кредитні чеки' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {if isset($credit_slips) && $credit_slips|@count > 0}
    {foreach from=$credit_slips item=slip}
      <p>{$slip.credit_slip_number} — {$slip.date_add} — {$slip.amount}</p>
    {/foreach}
  {else}
    <p>{l s='Немає кредитних чеків.' d='Shop.Theme.Customeraccount'}</p>
  {/if}
{/block}
