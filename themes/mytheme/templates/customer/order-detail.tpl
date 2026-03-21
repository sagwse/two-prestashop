{**
 * order-detail.tpl — Детали заказа
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Деталі замовлення' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {if isset($order)}
    <p>{l s='Номер замовлення' d='Shop.Theme.Customeraccount'}: <strong>{$order.details.reference}</strong></p>
    <p>{l s='Дата' d='Shop.Theme.Customeraccount'}: {$order.details.order_date}</p>
    {hook h='displayOrderDetail' order=$order}
  {/if}
{/block}
