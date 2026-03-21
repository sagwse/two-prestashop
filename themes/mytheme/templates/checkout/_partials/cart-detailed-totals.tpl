{**
 * cart-detailed-totals.tpl — Итоги корзины
 * mytheme v0.7.1 — PS9 stub
 *}
{if isset($cart.totals)}
  <div class="cart-totals">
    {foreach from=$cart.totals item=total}
      {if $total.amount > 0}
        <div class="cart-totals__row">
          <span class="cart-totals__label">{$total.label}</span>
          <span class="cart-totals__value">{$total.value}</span>
        </div>
      {/if}
    {/foreach}
  </div>
{/if}
