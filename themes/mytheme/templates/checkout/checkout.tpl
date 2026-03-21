{**
 * checkout.tpl — Оформление заказа
 * mytheme v0.7.1 — PS9 stub (полная реализация → v0.8.0)
 *}
{extends file=$layout}

{block name='content'}
  {include file='_partials/notifications.tpl'}

  <div class="checkout-container">
    <div class="container">
      <div class="row">

        <div class="checkout-body col-12 col-lg-7">
          {block name='checkout_process'}
            {render file='checkout/checkout-process.tpl' ui=$checkout_process}
          {/block}
        </div>

        <div class="checkout-sidebar col-12 col-lg-5">
          {block name='cart_summary'}
            {include file='checkout/_partials/cart-summary.tpl' cart=$cart}
          {/block}

          {hook h='displayReassurance'}
        </div>

      </div>
    </div>
  </div>

  {include file='checkout/_partials/modal-terms.tpl'}
{/block}
