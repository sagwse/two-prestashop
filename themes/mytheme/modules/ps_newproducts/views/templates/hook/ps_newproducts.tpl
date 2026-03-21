{**
 * ps_newproducts — Новинки на главной
 * Версия темы : mytheme v0.6.0
 * Bootstrap    : 5.3
 * Файл         : modules/ps_newproducts/views/templates/hook/ps_newproducts.tpl
 *}
<section class="new-products featured-section py-5 bg-light">
  <div class="container-fluid px-0">
    <div class="featured-section__header d-flex align-items-center justify-content-between mb-4">
      <h2 class="featured-section__title h3 mb-0">
        {l s='New products' d='Shop.Theme.Catalog'}
      </h2>
      <a href="{$allNewProductsLink}" class="btn btn-outline-primary btn-sm">
        {l s='All new products' d='Shop.Theme.Global'}
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
