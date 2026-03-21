{**
 * order-follow.tpl — Отслеживание заказа
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Відстеження замовлення' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {if isset($ordersReturn) && $ordersReturn|@count > 0}
    {foreach from=$ordersReturn item=return}
      <p>{$return.reference} — {$return.state_name}</p>
    {/foreach}
  {else}
    <p>{l s='Немає повернень для відстеження.' d='Shop.Theme.Customeraccount'}</p>
  {/if}
{/block}
