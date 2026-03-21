{**
 * cart.tpl — Страница корзины
 * mytheme v0.7.1 — PS9 stub (полная реализация → v0.8.0)
 *}
{extends file=$layout}

{block name='content'}
  <div class="cart-grid">
    <div class="container">
      <div class="row">

        {* Левая часть: товары в корзине *}
        <div class="cart-grid__body col-12 col-lg-8">
          <h1>{l s='Кошик' d='Shop.Theme.Checkout'}</h1>

          <div class="cart-container">
            <div class="js-cart-update-alert"
                 data-alert="{l s='було видалено з кошика.' d='Shop.Theme.Actions' js=1}"></div>

            {block name='cart_overview'}
              {include file='checkout/_partials/cart-detailed.tpl' cart=$cart}
            {/block}

            {block name='continue_shopping'}
              <a class="btn btn-outline-primary" href="{$urls.pages.index}">
                <i class="fa-solid fa-chevron-left me-2" aria-hidden="true"></i>
                {l s='Продовжити покупки' d='Shop.Theme.Actions'}
              </a>
            {/block}

            {block name='hook_shopping_cart_footer'}
              {hook h='displayShoppingCartFooter'}
            {/block}
          </div>
        </div>

        {* Правая часть: итого *}
        <div class="cart-grid__right col-12 col-lg-4">
          <h2>{l s='Підсумок замовлення' d='Shop.Theme.Checkout'}</h2>

          {block name='cart_summary'}
            <div class="cart-summary">
              {block name='hook_shopping_cart'}
                {hook h='displayShoppingCart'}
              {/block}

              {block name='cart_totals'}
                {include file='checkout/_partials/cart-detailed-totals.tpl' cart=$cart}
              {/block}

              {block name='cart_actions'}
                {include file='checkout/_partials/cart-detailed-actions.tpl' cart=$cart}
              {/block}
            </div>
          {/block}

          {block name='hook_reassurance'}
            {hook h='displayReassurance'}
          {/block}
        </div>

      </div>
    </div>
  </div>

  {hook h='displayCrossSellingShoppingCart'}
{/block}
