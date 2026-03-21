{**
 * history.tpl — История заказов
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Історія замовлень' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {if isset($orders) && $orders|@count > 0}
    <table class="table">
      <thead>
        <tr>
          <th>{l s='Номер' d='Shop.Theme.Customeraccount'}</th>
          <th>{l s='Дата' d='Shop.Theme.Customeraccount'}</th>
          <th>{l s='Сума' d='Shop.Theme.Customeraccount'}</th>
          <th>{l s='Статус' d='Shop.Theme.Customeraccount'}</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        {foreach from=$orders item=order}
          <tr>
            <td>{$order.details.reference}</td>
            <td>{$order.details.order_date}</td>
            <td>{$order.totals.total.value}</td>
            <td>{$order.history.current.ostate_name}</td>
            <td>
              <a href="{$order.details.details_url}" class="btn btn-sm btn-outline-primary">
                {l s='Деталі' d='Shop.Theme.Actions'}
              </a>
            </td>
          </tr>
        {/foreach}
      </tbody>
    </table>
  {else}
    <p>{l s='У вас ще немає замовлень.' d='Shop.Theme.Customeraccount'}</p>
  {/if}
{/block}
