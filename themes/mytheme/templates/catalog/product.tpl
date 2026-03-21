{**
 * product.tpl — Страница товара (карточка товара)
 *
 * Версия темы : mytheme v0.7.0
 * PrestaShop  : 9.0.x
 * PHP         : 8.4.x
 * Шаблонизатор: Smarty
 *
 * Структура страницы (сверху вниз — секция 18 рекомендаций):
 *   1. Хлебные крошки           — _partials/breadcrumb.tpl (v0.5.1)
 *   2. Flash-уведомления        — _partials/notifications.tpl (v0.5.1)
 *   3. Двухколоночный layout (.product-layout):
 *      3a. Галерея (55%, sticky desktop) — _partials/product-images.tpl
 *      3b. Покупательская панель (45%):
 *          — H1: $product.name
 *          — Рейтинг + ссылка на #product-reviews
 *          — Идентификация (артикул, Product Code)
 *          — Цены: _partials/product-prices.tpl
 *          — Метки доверия (Made in England, нотифікація ДПСС)
 *          — Варианты: _partials/product-variants.tpl
 *          — Кнопка: _partials/product-add-to-cart.tpl
 *          — Wishlist + Share
 *          — Доставка / наличие
 *          — Гарантии (иконки)
 *   4. Информационные секции (full width, collapsed sections):
 *      — Опис, Склад, Спосіб застосування, Обов'язкові застереження (закон),
 *        Деталі та характеристики, Виробник, Сертифікати, FAQ
 *   5. Відгуки (full width) — #product-reviews, hook displayProductTabContent
 *   6. Схожі товари (full width) — hook displayFooterProduct, scroll-snap
 *   7. Хуки PS9 (displayFooterProduct)
 *   8. Sticky bottom bar (mobile) — в product-add-to-cart.tpl
 *
 * Зависимости (все готовы):
 *   layouts/layout-full-width.tpl       ✅ v0.5.0
 *   _partials/breadcrumb.tpl            ✅ v0.5.1
 *   _partials/notifications.tpl         ✅ v0.5.1
 *   _partials/microdata/schema-product.tpl ✅ v0.4.0
 *   _partials/microdata/schema-faq.tpl  ✅ v0.4.0
 *   catalog/listing/_partials/rating-stars.tpl ✅ v0.6.0
 *   catalog/listing/product-miniature.tpl ✅ v0.6.0
 *   catalog/_partials/product-images.tpl ✅ v0.7.0
 *   catalog/_partials/product-prices.tpl ✅ v0.7.0
 *   catalog/_partials/product-variants.tpl ✅ v0.7.0
 *   catalog/_partials/product-add-to-cart.tpl ✅ v0.7.0
 *
 * SEO:
 *   — Единственный H1 на странице = $product.name
 *   — Заголовки секций: H2 (Опис, Склад, Спосіб, Деталі, Відгуки, Схожі)
 *   — JSON-LD: Product + Offer + AggregateRating (schema-product.tpl)
 *   — JSON-LD: FAQPage (schema-faq.tpl, если есть FAQ)
 *   — Canonical URL уже в head.tpl
 *
 * Юридические требования Украины (Закон № 4122-IX від 05.12.2024):
 *   — Обов'язкові застереження: дієтична добавка, не є лікарським засобом
 *   — Вся информация на украинском языке
 *   — Штраф за нарушения: 640 000 грн
 *
 * CSS: assets/css/pages/product.css (v0.14.0)
 * JS:  assets/js/pages/product.js  (v0.14.0)
 *}


{* ─────────────────────────────────────────────────────────────────────────────
   Наследуем базовый layout. Все страницы темы расширяют layout-full-width.tpl.
   ───────────────────────────────────────────────────────────────────────────── *}
{extends file='layouts/layout-full-width.tpl'}


{* ─────────────────────────────────────────────────────────────────────────────
   head_extra — JSON-LD микроразметка и страничные ресурсы.
   ───────────────────────────────────────────────────────────────────────────── *}
{block name='head_extra'}

  {* JSON-LD Product + Offer + AggregateRating.
     schema-product.tpl (v0.4.0) — подключаем напрямую для надёжности.
     Хук displaySchemaMarkup может не сработать если не зарегистрирован модулем. *}
  {include file='_partials/microdata/schema-product.tpl'}

{/block}


{* ─────────────────────────────────────────────────────────────────────────────
   ОСНОВНОЙ БЛОК КОНТЕНТА
   ───────────────────────────────────────────────────────────────────────────── *}
{block name='content'}


  {* ── 1. ХЛЕБНЫЕ КРОШКИ ──────────────────────────────────────────────────── *}
  {if isset($breadcrumb.links) && $breadcrumb.links|@count > 1}
    {include file='_partials/breadcrumb.tpl'}
  {/if}


  {* ── 2. FLASH-УВЕДОМЛЕНИЯ ───────────────────────────────────────────────── *}
  {include file='_partials/notifications.tpl'}


  {* ═══════════════════════════════════════════════════════════════════════════
     3. ДВУХКОЛОНОЧНЫЙ LAYOUT: ГАЛЕРЕЯ + ПОКУПАТЕЛЬСКАЯ ПАНЕЛЬ
     Desktop ≥992px: 55% галерея (sticky) | 45% панель
     Mobile <992px:  full-width галерея → full-width панель
     ═══════════════════════════════════════════════════════════════════════════ *}
  <div class="product-layout" id="js-product-layout">
    <div class="container-fluid px-0">
      <div class="product-layout__inner">


        {* ── 3a. ГАЛЕРЕЯ (левая колонка, sticky на desktop) ─────────────── *}
        <div class="product-layout__gallery">
          {include file='catalog/_partials/product-images.tpl'}
        </div>


        {* ── 3b. ПОКУПАТЕЛЬСКАЯ ПАНЕЛЬ (правая колонка) ─────────────────── *}
        <div class="product-layout__panel">


          {* ── H1: НАЗВАНИЕ ТОВАРА ───────────────────────────────────────
             Единственный H1 на странице.
             Не содержит «купити» — анти-паттерн для нутрицевтики.
             $product.name — на украинском (требование закона).
             ─────────────────────────────────────────────────────────────── *}
          <h1 class="product-layout__title" id="js-product-title">
            {$product.name|escape:'html':'UTF-8'}
          </h1>


          {* ── РЕЙТИНГ + ССЫЛКА НА ОТЗЫВЫ ───────────────────────────────
             Три состояния (аналогично product-miniature.tpl):
               0 отзывов:  ссылка «Залишити перший відгук»
               1–4:        звёзды + счётчик (без балла)
               5+:         звёзды + балл + счётчик
             Ссылка <a href="#product-reviews"> — smooth scroll к секции.
             ─────────────────────────────────────────────────────────────── *}
          {assign var='comment_count' value=0}
          {if isset($product.comment_count) && $product.comment_count}
            {assign var='comment_count' value=$product.comment_count|intval}
          {/if}

          {assign var='stars_rating' value=0}
          {if isset($product.stars_ratings) && $product.stars_ratings}
            {assign var='stars_rating' value=$product.stars_ratings}
          {/if}

          <div class="product-layout__rating">

            {if $comment_count === 0}

              <a
                href="#product-reviews"
                class="product-layout__rating-cta"
              >
                {l s='Залишити перший відгук' d='Shop.Theme.Catalog'}
              </a>

            {elseif $comment_count < 5}

              <a
                href="#product-reviews"
                class="product-layout__rating-link"
                aria-label="{l s='%count% відгуків' sprintf=['%count%' => $comment_count] d='Shop.Theme.Catalog'}"
              >
                {include
                  file='catalog/listing/_partials/rating-stars.tpl'
                  rating=$stars_rating
                  show_score=false
                }
                <span class="product-layout__rating-count">
                  ({$comment_count|intval} {l s='відгуків' d='Shop.Theme.Catalog'})
                </span>
              </a>

            {else}

              {assign var='avg_score' value=0}
              {if isset($product.averaged_note) && $product.averaged_note}
                {assign var='avg_score' value=$product.averaged_note}
              {/if}

              <a
                href="#product-reviews"
                class="product-layout__rating-link"
                aria-label="{l s='Рейтинг %score% з 5, %count% відгуків' sprintf=['%score%' => $avg_score, '%count%' => $comment_count] d='Shop.Theme.Catalog'}"
              >
                {include
                  file='catalog/listing/_partials/rating-stars.tpl'
                  rating=$stars_rating
                  show_score=true
                  score=$avg_score
                }
                <span class="product-layout__rating-count">
                  ({$comment_count|intval} {l s='відгуків' d='Shop.Theme.Catalog'})
                </span>
              </a>

            {/if}

          </div>{* /.product-layout__rating *}


          {* ── ИДЕНТИФИКАЦИЯ ТОВАРА ──────────────────────────────────────
             Артикул (reference) и Product Code (reference используется для G&G).
             ─────────────────────────────────────────────────────────────── *}
          <div class="product-identity">
            {if isset($product.reference) && $product.reference}
              <span class="product-identity__reference">
                {l s='Артикул' d='Shop.Theme.Catalog'}: {$product.reference|escape:'html':'UTF-8'}
              </span>
            {/if}
            {if isset($product.ean13) && $product.ean13}
              <span class="product-identity__ean">
                EAN: {$product.ean13|escape:'html':'UTF-8'}
              </span>
            {/if}
          </div>


          {* ── ЦЕНЫ ──────────────────────────────────────────────────────── *}
          {include file='catalog/_partials/product-prices.tpl'}


          {* ── МЕТКИ ДОВЕРИЯ ─────────────────────────────────────────────
             Made in England badge + нотификация ДПСС.
             Источник: features PS9 (Характеристики).
             ─────────────────────────────────────────────────────────────── *}
          <div class="product-trust">
            {* Made in England — статичный badge *}
            <span class="product-trust__badge">
              <i class="fa-solid fa-flag me-1" aria-hidden="true"></i>
              {l s='Вироблено у Великій Британії' d='Shop.Theme.Catalog'}
            </span>

            {* Нотификация ДПСС — из features (если есть) *}
            {if isset($product.features) && $product.features|@count > 0}
              {foreach from=$product.features item='feature'}
                {if $feature.name === 'Нотифікація ДПСС' && $feature.value}
                  <span class="product-trust__badge product-trust__badge--notification">
                    <i class="fa-solid fa-shield-check me-1" aria-hidden="true"></i>
                    {$feature.value|escape:'html':'UTF-8'}
                  </span>
                {/if}
              {/foreach}
            {/if}
          </div>


          {* ── ВАРИАНТЫ (кнопки-пилюли) ─────────────────────────────────── *}
          {include file='catalog/_partials/product-variants.tpl'}


          {* ── КНОПКА «ДО КОШИКА» + КОЛИЧЕСТВО ─────────────────────────── *}
          {include file='catalog/_partials/product-add-to-cart.tpl'}


          {* ── WISHLIST + SHARE ──────────────────────────────────────────
             Wishlist: hook displayProductActions — blockwishlist.
             Share: ссылки на соцсети / кнопка «Поділитися».
             ─────────────────────────────────────────────────────────────── *}
          <div class="product-wishlist-share">
            {* Wishlist (blockwishlist) *}
            <div class="product-wishlist-share__wishlist">
              {hook h='displayProductActions'}
            </div>

            {* Кнопка «Поділитися» — нативный Web Share API или dropdown *}
            <button
              class="product-wishlist-share__share-btn"
              type="button"
              data-action="share"
              aria-label="{l s='Поділитися товаром' d='Shop.Theme.Catalog'}"
            >
              <i class="fa-solid fa-share-nodes me-1" aria-hidden="true"></i>
              {l s='Поділитися' d='Shop.Theme.Catalog'}
            </button>
          </div>


          {* ── ДОСТАВКА / НАЛИЧИЕ ────────────────────────────────────────
             Краткий блок с информацией о доставке.
             Модуль: hook displayProductAdditionalInfo.
             + статичная информация для всех товаров.
             ─────────────────────────────────────────────────────────────── *}
          <div class="product-delivery" id="js-product-delivery">

            {* Наличие *}
            {if isset($product.availability_message) && $product.availability_message}
              <p class="product-delivery__availability{if $product.availability === 'available'} product-delivery__availability--in-stock{elseif $product.availability === 'last_remaining_items'} product-delivery__availability--last{else} product-delivery__availability--out{/if}">
                {if $product.availability === 'available'}
                  <i class="fa-solid fa-circle-check me-1" aria-hidden="true"></i>
                {elseif $product.availability === 'last_remaining_items'}
                  <i class="fa-solid fa-triangle-exclamation me-1" aria-hidden="true"></i>
                {else}
                  <i class="fa-solid fa-circle-xmark me-1" aria-hidden="true"></i>
                {/if}
                {$product.availability_message|escape:'html':'UTF-8'}
              </p>
            {/if}

            {* Хук PS9 — модули могут добавить информацию о доставке *}
            {hook h='displayProductAdditionalInfo'}

          </div>


          {* ── ГАРАНТИИ (иконки) ─────────────────────────────────────────
             Три гарантийные метки для повышения доверия.
             ─────────────────────────────────────────────────────────────── *}
          <div class="product-guarantees">
            <div class="product-guarantees__item">
              <i class="fa-solid fa-rotate-left" aria-hidden="true"></i>
              <span>{l s='14 днів на повернення' d='Shop.Theme.Catalog'}</span>
            </div>
            <div class="product-guarantees__item">
              <i class="fa-solid fa-lock" aria-hidden="true"></i>
              <span>{l s='Безпечна оплата' d='Shop.Theme.Catalog'}</span>
            </div>
            <div class="product-guarantees__item">
              <i class="fa-solid fa-headset" aria-hidden="true"></i>
              <span>{l s='Підтримка 24/7' d='Shop.Theme.Catalog'}</span>
            </div>
          </div>


        </div>{* /.product-layout__panel *}


      </div>{* /.product-layout__inner *}
    </div>{* /container-fluid *}
  </div>{* /.product-layout *}


  {* ═══════════════════════════════════════════════════════════════════════════
     4. ИНФОРМАЦИОННЫЕ СЕКЦИИ (full width)
     Вертикально раскрытые (НЕ горизонтальные табы!):
       — 27% пользователей пропускают контент в табах (Baymard, 2025)
       — Desktop: все раскрыты по умолчанию
       — Mobile: accordion (закрыты, открываются по клику)
     Каждая секция: <section> + <h2> + <div>
     ═══════════════════════════════════════════════════════════════════════════ *}
  <div class="product-info-sections" id="js-product-info-sections">
    <div class="container-fluid px-0">


      {* ── СЕКЦИЯ 1: ОПИС ──────────────────────────────────────────────────
         $product.description — полное описание товара (HTML из BO).
         ─────────────────────────────────────────────────────────────────── *}
      {if isset($product.description) && $product.description}
        <section class="product-section product-section--open" id="product-description">
          <h2 class="product-section__title">
            <button
              class="product-section__toggle"
              type="button"
              aria-expanded="true"
              aria-controls="product-description-body"
            >
              <i class="fa-solid fa-file-lines product-section__icon" aria-hidden="true"></i>
              {l s='Опис' d='Shop.Theme.Catalog'}
              <i class="fa-solid fa-chevron-down product-section__chevron" aria-hidden="true"></i>
            </button>
          </h2>
          <div class="product-section__body" id="product-description-body">
            {$product.description nofilter}
          </div>
        </section>
      {/if}


      {* ── СЕКЦИЯ 2: СКЛАД ТА ХАРЧОВА ЦІННІСТЬ ────────────────────────────
         Источник: $product.description_short (переименовано логически в BO).
         Или кастомный атрибут / feature.
         ─────────────────────────────────────────────────────────────────── *}
      {if isset($product.description_short) && $product.description_short}
        <section class="product-section" id="product-composition">
          <h2 class="product-section__title">
            <button
              class="product-section__toggle"
              type="button"
              aria-expanded="false"
              aria-controls="product-composition-body"
            >
              <i class="fa-solid fa-flask product-section__icon" aria-hidden="true"></i>
              {l s='Склад та харчова цінність' d='Shop.Theme.Catalog'}
              <i class="fa-solid fa-chevron-down product-section__chevron" aria-hidden="true"></i>
            </button>
          </h2>
          <div class="product-section__body" id="product-composition-body" hidden>
            {$product.description_short nofilter}
          </div>
        </section>
      {/if}


      {* ── СЕКЦИЯ 3: СПОСІБ ЗАСТОСУВАННЯ ТА ДОЗУВАННЯ ─────────────────────
         Источник: Features PS9 с именем «Спосіб застосування».
         Обход лимита 255 символов — текст может быть в description_short.
         ─────────────────────────────────────────────────────────────────── *}
      {assign var='usage_text' value=''}
      {if isset($product.features) && $product.features|@count > 0}
        {foreach from=$product.features item='feature'}
          {if $feature.name === 'Спосіб застосування' && $feature.value}
            {assign var='usage_text' value=$feature.value}
          {/if}
        {/foreach}
      {/if}

      {if $usage_text}
        <section class="product-section" id="product-usage">
          <h2 class="product-section__title">
            <button
              class="product-section__toggle"
              type="button"
              aria-expanded="false"
              aria-controls="product-usage-body"
            >
              <i class="fa-solid fa-capsules product-section__icon" aria-hidden="true"></i>
              {l s='Спосіб застосування та дозування' d='Shop.Theme.Catalog'}
              <i class="fa-solid fa-chevron-down product-section__chevron" aria-hidden="true"></i>
            </button>
          </h2>
          <div class="product-section__body" id="product-usage-body" hidden>
            <p>{$usage_text|escape:'html':'UTF-8'}</p>
          </div>
        </section>
      {/if}


      {* ── СЕКЦИЯ 4: ОБОВ'ЯЗКОВІ ЗАСТЕРЕЖЕННЯ (закон) ──────────────────────
         Закон № 4122-IX від 05.12.2024 (вступил в силу 27.09.2025).
         Жёсткий текст — нельзя менять содержание.
         Штраф за отсутствие: 640 000 грн для юридических лиц.
         ВСЕГДА показывается — не зависит от наличия данных в BO.
         ─────────────────────────────────────────────────────────────────── *}
      <section class="product-section product-section--warning" id="product-warnings">
        <h2 class="product-section__title">
          <button
            class="product-section__toggle"
            type="button"
            aria-expanded="false"
            aria-controls="product-warnings-body"
          >
            <i class="fa-solid fa-triangle-exclamation product-section__icon" aria-hidden="true"></i>
            {l s='Обов\'язкові застереження' d='Shop.Theme.Catalog'}
            <i class="fa-solid fa-chevron-down product-section__chevron" aria-hidden="true"></i>
          </button>
        </h2>
        <div class="product-section__body" id="product-warnings-body" hidden>
          <div class="product-warnings">
            <p class="product-warnings__title">
              <i class="fa-solid fa-triangle-exclamation me-1" aria-hidden="true"></i>
              <strong>{l s='ОБОВ\'ЯЗКОВІ ЗАСТЕРЕЖЕННЯ (за законодавством України):' d='Shop.Theme.Catalog'}</strong>
            </p>
            <ul class="product-warnings__list">
              <li>{l s='Дієтична добавка. Не є лікарським засобом.' d='Shop.Theme.Catalog'}</li>
              <li>{l s='Не замінює повноцінного раціону харчування.' d='Shop.Theme.Catalog'}</li>
              <li>{l s='Не перевищуйте рекомендовану добову дозу.' d='Shop.Theme.Catalog'}</li>
              <li>{l s='Зберігати у недоступному для дітей місці.' d='Shop.Theme.Catalog'}</li>
              <li>{l s='Перед застосуванням проконсультуйтеся з лікарем.' d='Shop.Theme.Catalog'}</li>
            </ul>
          </div>
        </div>
      </section>


      {* ── СЕКЦИЯ 5: ДЕТАЛІ ТА ХАРАКТЕРИСТИКИ ─────────────────────────────
         Features из PS9 ($product.features[]).
         Таблица: Назва характеристики | Значення.
         Исключаем «Спосіб застосування» (уже в секции 3) и
         «Нотифікація ДПСС» (уже в метках доверия).
         ─────────────────────────────────────────────────────────────────── *}
      {if isset($product.features) && $product.features|@count > 0}
        <section class="product-section" id="product-details">
          <h2 class="product-section__title">
            <button
              class="product-section__toggle"
              type="button"
              aria-expanded="false"
              aria-controls="product-details-body"
            >
              <i class="fa-solid fa-list-check product-section__icon" aria-hidden="true"></i>
              {l s='Деталі та характеристики' d='Shop.Theme.Catalog'}
              <i class="fa-solid fa-chevron-down product-section__chevron" aria-hidden="true"></i>
            </button>
          </h2>
          <div class="product-section__body" id="product-details-body" hidden>
            <table class="product-details-table">
              <tbody>
                {foreach from=$product.features item='feature'}
                  {* Исключаем характеристики, уже отображённые в других секциях *}
                  {if $feature.name !== 'Спосіб застосування' && $feature.name !== 'Нотифікація ДПСС'}
                    <tr class="product-details-table__row">
                      <th class="product-details-table__name">
                        {$feature.name|escape:'html':'UTF-8'}
                      </th>
                      <td class="product-details-table__value">
                        {$feature.value|escape:'html':'UTF-8'}
                      </td>
                    </tr>
                  {/if}
                {/foreach}
              </tbody>
            </table>
          </div>
        </section>
      {/if}


      {* ── СЕКЦИЯ 6: ВИРОБНИК ТА ПРЕДСТАВНИК ──────────────────────────────
         Обязательная юридическая информация.
         Данные: частично из features, частично статичные.
         ─────────────────────────────────────────────────────────────────── *}
      <section class="product-section" id="product-manufacturer">
        <h2 class="product-section__title">
          <button
            class="product-section__toggle"
            type="button"
            aria-expanded="false"
            aria-controls="product-manufacturer-body"
          >
            <i class="fa-solid fa-industry product-section__icon" aria-hidden="true"></i>
            {l s='Виробник та представник' d='Shop.Theme.Catalog'}
            <i class="fa-solid fa-chevron-down product-section__chevron" aria-hidden="true"></i>
          </button>
        </h2>
        <div class="product-section__body" id="product-manufacturer-body" hidden>
          <div class="product-manufacturer">

            {* Бренд / производитель — из PS9 *}
            {if isset($product.manufacturer_name) && $product.manufacturer_name}
              <p>
                <strong>{l s='Виробник' d='Shop.Theme.Catalog'}:</strong>
                {$product.manufacturer_name|escape:'html':'UTF-8'}
              </p>
            {/if}

            {* Страна — из features или статично *}
            <p>
              <i class="fa-solid fa-flag me-1" aria-hidden="true"></i>
              {l s='Вироблено у Великій Британії' d='Shop.Theme.Catalog'}
            </p>

            {* Штрихкод EAN *}
            {if isset($product.ean13) && $product.ean13}
              <p>
                <strong>{l s='Штрихкод' d='Shop.Theme.Catalog'}:</strong>
                {$product.ean13|escape:'html':'UTF-8'}
              </p>
            {/if}

            {* Product Code *}
            {if isset($product.reference) && $product.reference}
              <p>
                <strong>Product Code:</strong>
                {$product.reference|escape:'html':'UTF-8'}
              </p>
            {/if}

          </div>
        </div>
      </section>


      {* ── СЕКЦИЯ 7: СЕРТИФІКАТИ ТА ДОКУМЕНТИ ─────────────────────────────
         Фото сертификатов + ссылки.
         Выводим через хук displayProductExtraContent (модули могут добавить).
         ─────────────────────────────────────────────────────────────────── *}
      {assign var='extra_content' value={hook h='displayProductExtraContent' product=$product}}
      {if $extra_content}
        <section class="product-section" id="product-certificates">
          <h2 class="product-section__title">
            <button
              class="product-section__toggle"
              type="button"
              aria-expanded="false"
              aria-controls="product-certificates-body"
            >
              <i class="fa-solid fa-certificate product-section__icon" aria-hidden="true"></i>
              {l s='Сертифікати та документи' d='Shop.Theme.Catalog'}
              <i class="fa-solid fa-chevron-down product-section__chevron" aria-hidden="true"></i>
            </button>
          </h2>
          <div class="product-section__body" id="product-certificates-body" hidden>
            {$extra_content nofilter}
          </div>
        </section>
      {/if}


      {* ── СЕКЦИЯ 8: FAQ ПО ТОВАРУ ────────────────────────────────────────
         Модуль ggproductfaq передаёт контент через хук displayProductFaq.
         Если модуль не установлен — секция не рендерится.
         JSON-LD FAQPage: schema-faq.tpl подключается если есть $faq_items.
         ─────────────────────────────────────────────────────────────────── *}
      {assign var='product_faq' value={hook h='displayProductFaq'}}
      {if $product_faq}
        <section class="product-section" id="product-faq">
          <h2 class="product-section__title">
            <button
              class="product-section__toggle"
              type="button"
              aria-expanded="false"
              aria-controls="product-faq-body"
            >
              <i class="fa-solid fa-circle-question product-section__icon" aria-hidden="true"></i>
              {l s='Часті запитання' d='Shop.Theme.Catalog'}
              <i class="fa-solid fa-chevron-down product-section__chevron" aria-hidden="true"></i>
            </button>
          </h2>
          <div class="product-section__body" id="product-faq-body" hidden>
            {* JSON-LD FAQPage *}
            {if isset($faq_items) && $faq_items|@count > 0}
              {include file='_partials/microdata/schema-faq.tpl'}
            {/if}
            {* HTML контент FAQ от модуля *}
            {$product_faq nofilter}
          </div>
        </section>
      {/if}


    </div>{* /container-fluid *}
  </div>{* /.product-info-sections *}


  {* ═══════════════════════════════════════════════════════════════════════════
     5. ВІДГУКИ ПОКУПЦІВ (full width)
     Отдельная полноширинная секция, не в табах.
     Google индексирует видимый контент (не скрытый в табах).
     Якорь #product-reviews — ссылка из рейтинга в панели.
     Модуль ps_productcomments рендерит через хук displayProductTabContent.
     ═══════════════════════════════════════════════════════════════════════════ *}
  <section class="product-reviews-section" id="product-reviews">
    <div class="container-fluid px-0">

      <h2 class="product-reviews-section__title">
        <i class="fa-solid fa-comments me-2" aria-hidden="true"></i>
        {l s='Відгуки покупців' d='Shop.Theme.Catalog'}
        {if $comment_count > 0}
          <span class="product-reviews-section__count">({$comment_count|intval})</span>
        {/if}
      </h2>

      {* Модуль ps_productcomments рендерит сюда:
         — Рейтинговая разбивка (distribution bar)
         — Список отзывов
         — Форма «Написати відгук»
         — Пагинация / «Завантажити ще» *}
      <div class="product-reviews-section__body" id="js-product-reviews-body">
        {hook h='displayProductTabContent'}
      </div>

    </div>
  </section>


  {* ═══════════════════════════════════════════════════════════════════════════
     6. СХОЖІ ТОВАРИ (full width)
     Горизонтальный scroll-snap из product-miniature.tpl (v0.6.0).
     Desktop: 4 карточки видны. Mobile: 2 + частично третья (scroll hint).
     Источник: hook displayFooterProduct (ps_crossselling, ps_categoryproducts).
     ═══════════════════════════════════════════════════════════════════════════ *}
  {assign var='footer_product' value={hook h='displayFooterProduct' product=$product}}
  {if $footer_product}
    <section class="product-related" id="product-related">
      <div class="container-fluid px-0">

        <h2 class="product-related__title">
          <i class="fa-solid fa-boxes-stacked me-2" aria-hidden="true"></i>
          {l s='Схожі товари' d='Shop.Theme.Catalog'}
        </h2>

        <div class="product-related__scroll" id="js-related-scroll">
          {$footer_product nofilter}
        </div>

      </div>
    </section>
  {/if}


  {* ── ХУКИ PS9 ────────────────────────────────────────────────────────────
     displayRightColumn / displayLeftColumn — зарезервированы для модулей.
     ─────────────────────────────────────────────────────────────────────── *}
  {assign var='right_column' value={hook h='displayRightColumn'}}
  {if $right_column}{$right_column nofilter}{/if}


{/block}{* /content *}
