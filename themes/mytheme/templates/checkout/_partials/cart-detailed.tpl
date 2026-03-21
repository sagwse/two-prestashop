{**
 * cart-detailed.tpl — Детали корзины (список товаров)
 * mytheme v0.7.1 — PS9 stub
 *}
{if isset($cart.products) && $cart.products|@count > 0}
  <div class="cart-detailed" id="js-cart-detailed">
    {foreach from=$cart.products item=product}
      <div class="cart-item" data-product-id="{$product.id_product}">
        <div class="cart-item__img">
          <img src="{$product.cover.medium.url}" alt="{$product.name|escape:'html':'UTF-8'}" loading="lazy">
        </div>
        <div class="cart-item__info">
          <a href="{$product.url}" class="cart-item__name">{$product.name|escape:'html':'UTF-8'}</a>
          <span class="cart-item__price">{$product.price}</span>
          <span class="cart-item__qty">{l s='Кількість' d='Shop.Theme.Checkout'}: {$product.quantity}</span>
        </div>
        <div class="cart-item__total">
          {$product.total}
        </div>
      </div>
    {/foreach}
  </div>
{/if}
