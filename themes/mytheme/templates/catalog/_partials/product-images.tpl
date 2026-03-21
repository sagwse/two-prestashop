{**
 * product-images.tpl — Галерея фотографий товара
 *
 * Версия темы : mytheme v0.7.0
 * PrestaShop  : 9.0.x
 * PHP         : 8.4.x
 * Шаблонизатор: Smarty
 *
 * Вызывается из:
 *   catalog/product.tpl (v0.7.0) — основная страница товара
 *
 * Получаемые параметры (из product.tpl):
 *   $product.images[]             — массив всех фото товара
 *   $product.cover                — главное фото (large.url, bySize.*)
 *   $product.cover.id_image       — id главного фото (для пометки активной миниатюры)
 *   $product.name                 — для alt-текста
 *
 * Desktop (≥992px):
 *   Миниатюры: вертикальная колонка слева (80px ширина, 72×72px фото)
 *   Главное фото: aspect-ratio 1:1, object-fit: contain, белый фон
 *   Hover-зум: CSS transform scale (управляется product.js v0.14.0)
 *   Клик: открывает lightbox (нативный <dialog>)
 *
 * Mobile (<992px):
 *   Swipe галерея: CSS scroll-snap-type: x mandatory
 *   Dots-индикаторы: количество = количество фото
 *   Нет миниатюр — слишком маленькие на узком экране
 *
 * Lightbox:
 *   Нативный <dialog> (HTML5) — поддержка 100% в 2026.
 *   Открытие: showModal() | Закрытие: Esc (нативно) или кнопка ×
 *   Навигация: prev/next кнопки
 *   Без сторонних библиотек.
 *
 * Core Web Vitals:
 *   LCP: главное фото loading="eager" + fetchpriority="high"
 *   CLS: aspect-ratio резервирует место
 *   Остальные фото: loading="lazy"
 *
 * CSS: product.css (v0.14.0) — стили галереи
 * JS:  product.js (v0.14.0)  — смена фото, lightbox навигация, swipe, hover-зум
 *}


{* ─────────────────────────────────────────────────────────────────────────────
   ПРЕДВАРИТЕЛЬНЫЕ ВЫЧИСЛЕНИЯ
   ───────────────────────────────────────────────────────────────────────────── *}

{* Безопасное получение массива изображений *}
{assign var='images' value=[]}
{if isset($product.images) && $product.images|@count > 0}
  {assign var='images' value=$product.images}
{/if}

{* ID главного фото — для пометки активной миниатюры *}
{assign var='cover_id' value=0}
{if isset($product.cover.id_image)}
  {assign var='cover_id' value=$product.cover.id_image}
{/if}

{* URL главного фото — large_default (800×800) *}
{assign var='main_img_url' value=''}
{if isset($product.cover.large.url) && $product.cover.large.url}
  {assign var='main_img_url' value=$product.cover.large.url}
{/if}


{* ═══════════════════════════════════════════════════════════════════════════
   DESKTOP ГАЛЕРЕЯ — миниатюры слева + главное фото
   Видна только на ≥992px. На мобильном скрыта через CSS (d-none d-lg-flex).
   ═══════════════════════════════════════════════════════════════════════════ *}
<div class="product-gallery" id="js-product-gallery">

  {* ── МИНИАТЮРЫ (вертикальная колонка, desktop) ──────────────────────────
     Ширина колонки: 80px. Фото 72×72. Gap: 6px.
     Активная миниатюра: border 2px solid var(--color-primary).
     Скрыты на мобильном (CSS).
     ─────────────────────────────────────────────────────────────────────── *}
  {if $images|@count > 1}
    <div class="product-gallery__thumbs" aria-label="{l s='Мініатюри фото товару' d='Shop.Theme.Catalog'}">
      {foreach from=$images item='image' name='thumbs_loop'}
        <button
          class="product-gallery__thumb{if $image.id_image == $cover_id} product-gallery__thumb--active{/if}"
          type="button"
          data-image-id="{$image.id_image|intval}"
          data-image-large="{if isset($image.bySize.large_default.url)}{$image.bySize.large_default.url|escape:'html':'UTF-8'}{else}{$image.large.url|escape:'html':'UTF-8'}{/if}"
          data-image-thickbox="{if isset($image.bySize.thickbox_default.url)}{$image.bySize.thickbox_default.url|escape:'html':'UTF-8'}{else}{$image.large.url|escape:'html':'UTF-8'}{/if}"
          aria-label="{l s='Фото %index% з %total%' sprintf=['%index%' => $smarty.foreach.thumbs_loop.iteration, '%total%' => $images|@count] d='Shop.Theme.Catalog'}"
          {if $image.id_image == $cover_id}aria-current="true"{/if}
        >
          <img
            src="{if isset($image.bySize.cart_default.url)}{$image.bySize.cart_default.url|escape:'html':'UTF-8'}{else}{$image.small.url|escape:'html':'UTF-8'}{/if}"
            alt="{$product.name|escape:'html':'UTF-8'} — {l s='фото' d='Shop.Theme.Catalog'} {$smarty.foreach.thumbs_loop.iteration}"
            width="72"
            height="72"
            loading="lazy"
          >
        </button>
      {/foreach}
    </div>
  {/if}


  {* ── ГЛАВНОЕ ФОТО (desktop) ────────────────────────────────────────────
     aspect-ratio: 1/1 — резервирует место (CLS = 0).
     object-fit: contain — упаковки БАДов не обрезаются.
     Белый фон: var(--color-card).
     Клик: JS открывает lightbox через showModal().
     ─────────────────────────────────────────────────────────────────────── *}
  <div class="product-gallery__main" id="js-product-gallery-main">

    {if $main_img_url}
      <div
        class="product-gallery__main-wrapper"
        data-action="open-lightbox"
        role="button"
        tabindex="0"
        aria-label="{l s='Відкрити повноекранний перегляд фото' d='Shop.Theme.Catalog'}"
      >
        <img
          class="product-gallery__main-img"
          id="js-main-product-img"
          src="{$main_img_url|escape:'html':'UTF-8'}"
          alt="{$product.name|escape:'html':'UTF-8'}"
          width="800"
          height="800"
          loading="eager"
          fetchpriority="high"
        >
      </div>
    {else}
      {* Товар без фото — заглушка *}
      <div class="product-gallery__placeholder" aria-hidden="true">
        <i class="fa-solid fa-image"></i>
      </div>
    {/if}

  </div>


  {* ── МОБИЛЬНАЯ ГАЛЕРЕЯ (swipe + dots) ──────────────────────────────────
     CSS scroll-snap-type: x mandatory.
     Скрыта на desktop (CSS d-lg-none).
     ─────────────────────────────────────────────────────────────────────── *}
  {if $images|@count > 0}
    <div class="product-gallery__mobile" aria-label="{l s='Галерея фото товару' d='Shop.Theme.Catalog'}">

      <div class="product-gallery__mobile-scroll" id="js-gallery-mobile-scroll">
        {foreach from=$images item='image' name='mobile_loop'}
          <div class="product-gallery__mobile-slide" data-slide-index="{$smarty.foreach.mobile_loop.index}">
            <img
              src="{if isset($image.bySize.large_default.url)}{$image.bySize.large_default.url|escape:'html':'UTF-8'}{else}{$image.large.url|escape:'html':'UTF-8'}{/if}"
              alt="{$product.name|escape:'html':'UTF-8'} — {l s='фото' d='Shop.Theme.Catalog'} {$smarty.foreach.mobile_loop.iteration}"
              width="800"
              height="800"
              {if $smarty.foreach.mobile_loop.first}loading="eager" fetchpriority="high"{else}loading="lazy"{/if}
            >
          </div>
        {/foreach}
      </div>

      {* Dots-индикаторы *}
      {if $images|@count > 1}
        <div class="product-gallery__dots" aria-hidden="true">
          {foreach from=$images item='image' name='dots_loop'}
            <span
              class="product-gallery__dot{if $smarty.foreach.dots_loop.first} product-gallery__dot--active{/if}"
              data-dot-index="{$smarty.foreach.dots_loop.index}"
            ></span>
          {/foreach}
        </div>
      {/if}

    </div>
  {/if}

</div>{* /.product-gallery *}


{* ═══════════════════════════════════════════════════════════════════════════
   LIGHTBOX — нативный <dialog>
   Поддержка 2026: 100% актуальных браузеров.
   Esc закрывает нативно. Backdrop через ::backdrop.
   JS (product.js v0.14.0): showModal(), close(), навигация prev/next.
   ═══════════════════════════════════════════════════════════════════════════ *}
<dialog class="product-lightbox" id="js-product-lightbox" aria-label="{l s='Повноекранний перегляд фото' d='Shop.Theme.Catalog'}">
  <div class="product-lightbox__inner">

    {* Кнопка закрытия *}
    <button class="product-lightbox__close" type="button" aria-label="{l s='Закрити' d='Shop.Theme.Catalog'}">
      <i class="fa-solid fa-xmark" aria-hidden="true"></i>
    </button>

    {* Навигация — предыдущее фото *}
    {if $images|@count > 1}
      <button class="product-lightbox__prev" type="button" aria-label="{l s='Попереднє фото' d='Shop.Theme.Catalog'}" data-lightbox-prev>
        <i class="fa-solid fa-chevron-left" aria-hidden="true"></i>
      </button>
    {/if}

    {* Главное изображение lightbox *}
    <div class="product-lightbox__stage">
      <img
        class="product-lightbox__img"
        id="js-lightbox-img"
        src=""
        alt="{$product.name|escape:'html':'UTF-8'}"
      >
    </div>

    {* Навигация — следующее фото *}
    {if $images|@count > 1}
      <button class="product-lightbox__next" type="button" aria-label="{l s='Наступне фото' d='Shop.Theme.Catalog'}" data-lightbox-next>
        <i class="fa-solid fa-chevron-right" aria-hidden="true"></i>
      </button>
    {/if}

    {* Счётчик фото в lightbox *}
    {if $images|@count > 1}
      <div class="product-lightbox__counter" aria-hidden="true">
        <span id="js-lightbox-current">1</span> / {$images|@count}
      </div>
    {/if}

  </div>
</dialog>
