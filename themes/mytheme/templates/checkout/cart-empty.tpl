{**
 * cart-empty.tpl — Пустая корзина
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file=$layout}

{block name='content'}
  <div class="cart-empty">
    <div class="container text-center py-5">
      <i class="fa-solid fa-cart-shopping fa-3x mb-3" aria-hidden="true"
         style="color: oklch(65% 0 0)"></i>
      <h1>{l s='Ваш кошик порожній' d='Shop.Theme.Checkout'}</h1>
      <p>{l s='Додайте товари до кошика для оформлення замовлення.' d='Shop.Theme.Checkout'}</p>
      <a class="btn btn-primary" href="{$urls.pages.index}">
        <i class="fa-solid fa-arrow-left me-2" aria-hidden="true"></i>
        {l s='Продовжити покупки' d='Shop.Theme.Actions'}
      </a>
    </div>
  </div>
{/block}
