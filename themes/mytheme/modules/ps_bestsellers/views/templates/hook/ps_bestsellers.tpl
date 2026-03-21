{**
 * ps_bestsellers — Хиты продаж на главной
 * Версия темы : mytheme v0.6.0
 * Bootstrap    : 5.3
 * Файл         : modules/ps_bestsellers/views/templates/hook/ps_bestsellers.tpl
 *}
<section class="featured-products featured-section py-5">
  <div class="container-fluid px-0">
    <div class="featured-section__header d-flex align-items-center justify-content-between mb-4">
      <h2 class="featured-section__title h3 mb-0">
        {l s='Best Sellers' d='Shop.Theme.Catalog'}
      </h2>
      <a href="{$allBestSellersLink}" class="btn btn-outline-primary btn-sm">
        {l s='All best sellers' d='Shop.Theme.Global'}
        <i class="fa-solid fa-arrow-right ms-2" aria-hidden="true"></i>
      </a>
    </div>

    <div class="products row row-cols-2 row-cols-md-3 row-cols-lg-4 g-3 g-md-4">
      {foreach from=$products item="product"}
        <div class="col">
          {include file="catalog/_partials/miniatures/product.tpl" product=$product}
        </div>
      {/foreach}
    </div>
  </div>
</section>
