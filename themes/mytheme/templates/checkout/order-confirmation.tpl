{**
 * order-confirmation.tpl — Подтверждение заказа
 * mytheme v0.7.1 — PS9 stub (полная реализация → v0.8.0)
 *}
{extends file=$layout}

{block name='content'}
  <div class="order-confirmation">
    <div class="container py-4">

      {block name='order_confirmation_header'}
        <h1>
          <i class="fa-solid fa-circle-check me-2" style="color: oklch(55% 0.17 145)" aria-hidden="true"></i>
          {l s='Ваше замовлення підтверджено' d='Shop.Theme.Checkout'}
        </h1>
      {/block}

      {block name='order_details'}
        {if isset($order)}
          <p>{l s='Номер замовлення' d='Shop.Theme.Checkout'}: <strong>{$order.details.reference}</strong></p>
        {/if}
      {/block}

      {hook h='displayOrderConfirmation'}
      {hook h='displayOrderConfirmation2'}

    </div>
  </div>
{/block}
