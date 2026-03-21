{**
 * cart-summary.tpl — Сводка корзины (checkout sidebar)
 * mytheme v0.7.1 — PS9 stub
 *}
<div class="cart-summary" id="js-checkout-summary">
  {if isset($cart.products_count)}
    <p>{l s='Товарів у кошику' d='Shop.Theme.Checkout'}: {$cart.products_count}</p>
  {/if}
  {if isset($cart.totals.total)}
    <p class="cart-summary__total">
      <strong>{$cart.totals.total.label}:</strong> {$cart.totals.total.value}
    </p>
  {/if}
</div>
