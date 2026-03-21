{**
 * product-list.tpl — Сетка товаров каталога
 *
 * Версия темы : mytheme v0.6.0
 * PrestaShop  : 9.0.x
 * PHP         : 8.4.x
 * Шаблонизатор: Smarty
 *
 * Назначение:
 *   Выводит сетку карточек товаров. Подключается из category.tpl через:
 *   {include file='catalog/listing/product-list.tpl' products=$products}
 *   Также используется search.tpl, manufacturer.tpl, supplier.tpl — универсальный.
 *
 * Переменные, получаемые извне:
 *   $products        — массив товаров текущей страницы (обязателен)
 *   $listing         — объект листинга PS9 (sort_orders, pagination, active_filters и т.д.)
 *   $urls            — глобальный объект URL магазина (для CTA в empty-state)
 *
 * Структура файла:
 *   1. Список активных фильтров (теги-пилюли) — если есть $listing.active_filters
 *   2. Сетка карточек товаров — Bootstrap row + foreach $products
 *      — product-miniature.tpl для каждого товара (v0.6.0)
 *      — staggered fade-in анимация через CSS nth-child
 *      — LCP-оптимизация: первые 4 карточки eager + fetchpriority="high"
 *   3. Пустое состояние — если $products пуст
 *
 * Сетка (Bootstrap responsive):
 *   Mobile  <768px   : 2 колонки (row-cols-2)
 *   Tablet  768–991px: 2 колонки (row-cols-md-2), фильтры в offcanvas
 *   Desktop ≥992px   : 3 колонки (row-cols-lg-3), с aside фильтров 260px
 *   Wide    ≥1200px  : 4 колонки (row-cols-xl-4)
 *   Gap: g-3 mobile → g-md-4 desktop
 *
 * Режимы отображения (Grid / List):
 *   Класс .product-list--grid (по умолчанию) или .product-list--list
 *   Переключается через JS (category.js v0.14.0).
 *   В List-режиме CSS переопределяет grid на одну колонку + горизонтальный layout карточки.
 *   Состояние сохраняется в localStorage ключ 'catalog-view'.
 *
 * LCP (Largest Contentful Paint):
 *   Первые 4 фото: loading="eager" + fetchpriority="high" (above the fold).
 *   Остальные: loading="lazy".
 *   Логика реализована через $smarty.foreach.products_loop.index < 4.
 *   Цель: LCP < 2.5s согласно Google CWV 2026.
 *
 * CLS (Cumulative Layout Shift):
 *   aspect-ratio: 1/1 на .product-miniature__img-wrapper резервирует место
 *   до загрузки изображений — CLS = 0 для фото.
 *   Анимации используют только transform + opacity (не влияют на layout).
 *
 * Анимации:
 *   card-fade-in — staggered появление карточек при загрузке страницы.
 *   Задержки: nth-child(1)=0.05s ... nth-child(6+)=0.30s.
 *   Все анимации обёрнуты в prefers-reduced-motion в category.css.
 *
 * Зависимости:
 *   catalog/listing/product-miniature.tpl     ⬜ v0.6.0 (следующий файл)
 *   catalog/listing/_partials/empty-state.tpl ⬜ v0.6.0
 *
 * Не содержит:
 *   — H1/H2/H3 заголовков (они в category.tpl — нарушает SEO-иерархию)
 *   — Pagination (подключается в category.tpl после этого include)
 *   — Toolbar (подключается в category.tpl перед основной областью)
 *   — JSON-LD (в category.tpl через hook displaySchemaMarkup)
 *}


{* ─────────────────────────────────────────────────────────────────────────────
   1. АКТИВНЫЕ ФИЛЬТРЫ — теги-пилюли
   Показываем над сеткой если пользователь применил фильтры.
   Каждый тег: название фильтра + кнопка × для сброса конкретного фильтра.
   Кнопка "Скинути всі" — сброс всех сразу.
   aria-label на кнопке × содержит что именно сбрасывается — для скринридеров.
   Весь блок имеет aria-live="polite" — обновляется при AJAX-фильтрации.
   ───────────────────────────────────────────────────────────────────────────── *}
{if isset($listing.active_filters) && $listing.active_filters|@count > 0}
  <div
    class="catalog-active-filters-bar"
    aria-live="polite"
    aria-label="{l s='Активні фільтри' d='Shop.Theme.Catalog'}"
  >

    {* Заголовок блока активных фильтров *}
    <span class="catalog-active-filters-bar__label" aria-hidden="true">
      <i class="fa-solid fa-filter-circle-xmark" aria-hidden="true"></i>
      {l s='Фільтри:' d='Shop.Theme.Catalog'}
    </span>

    {* Список активных фильтров в виде тегов-пилюль *}
    <ul class="catalog-active-filters-bar__list" role="list">
      {foreach from=$listing.active_filters item='active_filter'}
        <li class="catalog-active-filters-bar__item">
          {* Фильтр отображается как: "Тип: Капсули ×"
             URL для сброса берём из объекта активного фильтра PS9 *}
          <a
            href="{$active_filter.url_clean|escape:'html':'UTF-8'}"
            class="catalog-active-filters-bar__tag"
            aria-label="{l s='Видалити фільтр: %label%' sprintf=['%label%' => $active_filter.label|escape:'html':'UTF-8'] d='Shop.Theme.Catalog'}"
            data-filter-remove
          >
            {* Название группы фильтра (если есть) *}
            {if isset($active_filter.name) && $active_filter.name}
              <span class="catalog-active-filters-bar__tag-group">
                {$active_filter.name|escape:'html':'UTF-8'}:
              </span>
            {/if}

            {* Значение фильтра *}
            <span class="catalog-active-filters-bar__tag-value">
              {$active_filter.label|escape:'html':'UTF-8'}
            </span>

            {* Иконка удаления *}
            <i class="fa-solid fa-xmark catalog-active-filters-bar__tag-remove" aria-hidden="true"></i>
          </a>
        </li>
      {/foreach}
    </ul>

    {* Кнопка сброса всех фильтров.
       URL без фильтров — $listing.reset_filters_url если доступен,
       иначе fallback на URL категории. *}
    <a
      href="{$listing.reset_filters_url|default:$urls.current_url|escape:'html':'UTF-8'}"
      class="catalog-active-filters-bar__reset-all"
      aria-label="{l s='Скинути всі фільтри' d='Shop.Theme.Catalog'}"
      data-filter-reset-all
    >
      <i class="fa-solid fa-rotate-left" aria-hidden="true"></i>
      {l s='Скинути всі' d='Shop.Theme.Catalog'}
    </a>

  </div>{* /.catalog-active-filters-bar *}
{/if}


{* ─────────────────────────────────────────────────────────────────────────────
   2. СЕТКА КАРТОЧЕК ТОВАРОВ
   ───────────────────────────────────────────────────────────────────────────── *}
{if isset($products) && $products|@count > 0}

  {* Обёртка сетки.
     Класс .product-list — BEM-блок верхнего уровня.
     Модификатор --grid / --list управляется через JS (category.js v0.14.0).
     По умолчанию: --grid (PS_GRID_PRODUCT_DEFAULT: 1 в theme.yml).

     data-product-list — якорь для JS-манипуляций.
     data-view — текущий режим отображения, синхронизируется с localStorage. *}
  <div
    class="product-list product-list--grid"
    id="js-product-list-grid"
    data-product-list
    data-view="grid"
  >

    {* Bootstrap row — адаптивная сетка.
       Breakpoints согласно рекомендациям (раздел 4.1 артефакта):
         row-cols-2    : mobile <768px   — 2 колонки (оптимально для упаковок БАДов)
         row-cols-md-2 : tablet 768–991px — 2 колонки (фильтры в offcanvas)
         row-cols-lg-3 : desktop ≥992px  — 3 колонки (с aside 260px фильтров)
         row-cols-xl-4 : wide ≥1200px    — 4 колонки
       g-3 / g-md-4 — gutters между карточками. *}
    <div class="row row-cols-2 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-3 g-md-4">

      {* Итерация по товарам.
         foreach с именем products_loop — чтобы можно было обращаться
         к $smarty.foreach.products_loop.index для LCP-оптимизации. *}
      {foreach from=$products item='product' name='products_loop'}

        {* Колонка Bootstrap.
           data-product-item — якорь для JS (skeleton, анимации).
           Каждый <div class="col"> — отдельная ячейка сетки. *}
        <div class="col" data-product-item>

          {* ── LCP-оптимизация ───────────────────────────────────────────────
             Первые 4 карточки находятся above the fold на большинстве экранов.
             Для них передаём в product-miniature.tpl параметр $is_above_fold=true,
             который переключает loading="eager" + fetchpriority="high" на фото.
             Остальные карточки: loading="lazy" (по умолчанию).
             Цель: LCP < 2.5s (Google CWV 2026).
             Порог 4 — компромисс: desktop (3–4 колонки) × 1 строка.
             ─────────────────────────────────────────────────────────────────── *}
          {if $smarty.foreach.products_loop.index < 4}
            {assign var='is_above_fold' value=true}
          {else}
            {assign var='is_above_fold' value=false}
          {/if}

          {* Подключаем карточку товара.
             Передаём:
               product       — объект товара PS9
               is_above_fold — управляет loading/fetchpriority фото (LCP)
             Все остальные переменные (urls, currency и т.д.) доступны
             глобально через Smarty — не нужно передавать явно. *}
          {include
            file='catalog/listing/product-miniature.tpl'
            product=$product
            is_above_fold=$is_above_fold
          }

        </div>{* /.col *}

      {/foreach}{* /products_loop *}

    </div>{* /.row *}

  </div>{* /.product-list *}


{* ─────────────────────────────────────────────────────────────────────────────
   3. ПУСТОЕ СОСТОЯНИЕ — нет товаров
   Показывается если:
     — категория пуста (нет товаров вообще)
     — фильтры отсеяли все товары
   Два разных сообщения в зависимости от наличия активных фильтров.
   CTA "В каталог" — ведёт на страницу всех категорий.
   ───────────────────────────────────────────────────────────────────────────── *}
{else}

  <div class="product-list-empty" role="status">
    <div class="product-list-empty__inner">

      {* Иконка — FA7 Solid, цвет --color-primary-light *}
      <i
        class="fa-solid fa-box-open product-list-empty__icon"
        aria-hidden="true"
      ></i>

      {* Заголовок и текст — зависят от контекста (фильтры или пустая категория).
         ВАЖНО: используем <p> а не H2/H3 — H1 уже занят названием категории,
         вторичные заголовки в пустом состоянии нарушают SEO-иерархию. *}
      {if isset($listing.active_filters) && $listing.active_filters|@count > 0}

        {* Фильтры применены, но товаров нет — предлагаем сбросить *}
        <p class="product-list-empty__title">
          {l s='За обраними фільтрами товарів не знайдено' d='Shop.Theme.Catalog'}
        </p>
        <p class="product-list-empty__text">
          {l s='Спробуйте змінити або скинути фільтри' d='Shop.Theme.Catalog'}
        </p>

        {* Кнопка сброса фильтров — первичный CTA *}
        <a
          href="{$listing.reset_filters_url|default:$urls.current_url|escape:'html':'UTF-8'}"
          class="btn btn-primary product-list-empty__btn"
        >
          <i class="fa-solid fa-rotate-left me-2" aria-hidden="true"></i>
          {l s='Скинути фільтри' d='Shop.Theme.Catalog'}
        </a>

        {* Вторичный CTA — перейти в корень каталога *}
        <a
          href="{$urls.pages.index|escape:'html':'UTF-8'}"
          class="btn btn-outline-secondary product-list-empty__btn-secondary"
        >
          {l s='До всього каталогу' d='Shop.Theme.Catalog'}
        </a>

      {else}

        {* Категория пуста — товаров нет вообще *}
        <p class="product-list-empty__title">
          {l s='У цій категорії поки немає товарів' d='Shop.Theme.Catalog'}
        </p>
        <p class="product-list-empty__text">
          {l s='Зайдіть пізніше або перегляньте інші розділи' d='Shop.Theme.Catalog'}
        </p>

        {* CTA — перейти в каталог *}
        <a
          href="{$urls.pages.index|escape:'html':'UTF-8'}"
          class="btn btn-primary product-list-empty__btn"
        >
          <i class="fa-solid fa-store me-2" aria-hidden="true"></i>
          {l s='Перейти до каталогу' d='Shop.Theme.Catalog'}
        </a>

      {/if}

    </div>{* /.product-list-empty__inner *}
  </div>{* /.product-list-empty *}

{/if}{* /if products *}
