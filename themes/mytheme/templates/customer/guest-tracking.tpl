{**
 * guest-tracking.tpl — Гостевое отслеживание заказа
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Відстеження замовлення' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {if isset($order)}
    <p>{l s='Номер замовлення' d='Shop.Theme.Customeraccount'}: <strong>{$order.details.reference}</strong></p>
    <p>{l s='Статус' d='Shop.Theme.Customeraccount'}: {$order.history.current.ostate_name}</p>
  {else}
    <p>{l s='Введіть номер замовлення та email для відстеження.' d='Shop.Theme.Customeraccount'}</p>
    {hook h='displayGuestTrackingForm'}
  {/if}
{/block}
