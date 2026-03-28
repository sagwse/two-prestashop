{**
 * category.tpl — Страница категории каталога
 *
 * Версия темы : mytheme v0.6.0
 * PrestaShop  : 9.0.x
 * PHP         : 8.4.x
 * Шаблонизатор: Smarty
 *
 * Структура страницы (сверху вниз):
 *   1. Хлебные крошки          — _partials/breadcrumb.tpl (v0.5.1)
 *   2. Flash-уведомления       — _partials/notifications.tpl (v0.5.1)
 *   3. JSON-LD микроразметка   — hook displaySchemaMarkup → schema-category.tpl (v0.4.0)
 *   4. Hero-блок категории     — H1, описание (details/summary), фото категории
 *   5. Плитки подкатегорий     — выводятся если есть $subcategories
 *   6. Offcanvas фильтры       — Bootstrap offcanvas, мобильный/планшетный вид
 *   7. Toolbar                 — сортировка + Grid/List переключатель + счётчик товаров
 *   8. Основная область        — aside (ps_facetedsearch) + main (product-list)
 *      8a. AJAX-зона           — #js-product-list с aria-live="polite"
 *      8b. Лоадер              — #js-catalog-loader, скрыт по умолчанию
 *   9. Пагинация               — _partials/pagination.tpl (v0.5.1), только если pages_count > 1
 *
 * Зависимости (все готовы):
 *   layouts/layout-full-width.tpl       ✅ v0.5.0
 *   _partials/breadcrumb.tpl            ✅ v0.5.1
 *   _partials/notifications.tpl         ✅ v0.5.1
 *   _partials/pagination.tpl            ✅ v0.5.1
 *   _partials/microdata/schema-category.tpl ✅ v0.4.0
 *   catalog/listing/product-list.tpl    ⬜ v0.6.0 (следующий файл)
 *
 * Модуль фильтров: ps_facetedsearch
 *   — Тема не знает о модуле напрямую, связь только через хук displayLeftColumn
 *   — Переопределение шаблонов модуля: themes/mytheme/modules/ps_facetedsearch/ (v0.11.0)
 *
 * SEO:
 *   — Единственный H1 на странице = $category.name
 *   — Описание категории в <details> — видно в DOM для Google и AI-агентов
 *   — noindex для страниц с активными фильтрами ($listing.is_filtered)
 *   — JSON-LD ItemList через hook displaySchemaMarkup
 *
 * JS (реализовать в pages/category.js, v0.14.0):
 *   — Grid/List toggle, состояние в localStorage
 *   — Sticky toolbar: добавляет класс .catalog-toolbar--stuck при прилипании
 *   — AJAX-фильтрация + History API (перехват события updateFacets от ps_facetedsearch)
 *   — Skeleton loading вместо спиннера при AJAX-обновлении
 *
 * CSS: assets/css/pages/category.css (v0.14.0)
 *}

{* ─────────────────────────────────────────────────────────────────────────────
   Наследуем базовый layout. Все страницы темы расширяют layout-full-width.tpl.
   Контентный блок — {block name='content'}.
   ───────────────────────────────────────────────────────────────────────────── *}
  {extends file='layouts/layout-full-width.tpl'}


  {* ─────────────────────────────────────────────────────────────────────────────
   head_extra — страничные ресурсы, подключаемые в <head>.
   category.css грузится ТОЛЬКО на этой странице (контроллер category).
   Приоритет 60 прописан в theme.yml — загружается после theme.css (50).
   ───────────────────────────────────────────────────────────────────────────── *}
  {block name='head_extra'}
    {* Страничный CSS подключается через theme.yml (assets → css → pages → category).
     Этот блок оставлен для возможного inline-CSS или дополнительных meta-тегов. *}

    {* noindex для страниц с активными фильтрами — предотвращает дублирование контента.
     Страницы вида ?q=Immune-Health&orderby=price не должны попадать в индекс Google. *}
    {if isset($listing.is_filtered) && $listing.is_filtered}
      <meta name="robots" content="noindex, follow">
    {/if}
  {/block}


  {* ─────────────────────────────────────────────────────────────────────────────
   ОСНОВНОЙ БЛОК КОНТЕНТА
   ───────────────────────────────────────────────────────────────────────────── *}
  {block name='content'}

    {* ── 1. ХЛЕБНЫЕ КРОШКИ ──────────────────────────────────────────────────────
     Условие: показываем только если в цепочке более одного звена.
     breadcrumb.tpl уже содержит microdata itemscope/itemprop.
     JSON-LD BreadcrumbList подключается глобально в head.tpl — не дублировать.
     ─────────────────────────────────────────────────────────────────────────── *}
    {if isset($breadcrumb.links) && $breadcrumb.links|@count > 1}
      {include file='_partials/breadcrumb.tpl'}
    {/if}


    {* ── 2. FLASH-УВЕДОМЛЕНИЯ ───────────────────────────────────────────────────
     Системные сообщения PS9: error / warning / success / info.
     Маппинг типов на Bootstrap alert-классы реализован внутри notifications.tpl.
     $message выводится без escape — PS9 может передавать HTML со ссылками.
     ─────────────────────────────────────────────────────────────────────────── *}
    {include file='_partials/notifications.tpl'}


    {* ── 3. JSON-LD МИКРОРАЗМЕТКА ───────────────────────────────────────────────
     Хук displaySchemaMarkup зарегистрирован в theme.yml (v0.2.0).
     На странице категории запускает schema-category.tpl → ItemList (URL-only pattern).
     Google и AI-агенты (Perplexity, SearchGPT, Gemini) используют ItemList
     для понимания что именно продаётся в этой категории.
     Тег <script type="application/ld+json"> генерируется внутри schema-category.tpl.
     ─────────────────────────────────────────────────────────────────────────── *}
    {hook h='displaySchemaMarkup'}


    {* ── 4. HERO-БЛОК КАТЕГОРИИ ─────────────────────────────────────────────────
     SEO-блок + визуальная идентификация категории.
     H1 — единственный на странице, содержит $category.name.
     Описание — в <details>/<summary> для "свернуть/развернуть":
       • текст остаётся в DOM (виден Google и AI-агентам, в отличие от display:none)
       • пользователь может раскрыть без JS (нативный HTML5-элемент)
     Фото — если загружено в BO, выводится слева от текста (flex-layout в CSS).
     ─────────────────────────────────────────────────────────────────────────── *}
    <div class="category-hero">
      <div class="container-fluid px-0">

        {* Фото категории — только если загружено в BO (Каталог → Категории → Изображение) *}
        {if isset($category.image.large.url) && $category.image.large.url}
          <img class="category-hero__img" src="{$category.image.large.url|escape:'html':'UTF-8'}"
            alt="{$category.name|escape:'html':'UTF-8'}" width="200" height="200" loading="lazy">
        {/if}

        {* H1 — единственный заголовок первого уровня на странице.
         Содержит ключевой запрос категории (заполняется в BO → SEO-вкладка).
         font-size: clamp(1.5rem, 3vw, 2.25rem) — задан в category.css. *}
        <h1 class="category-hero__title">
          {$category.name|escape:'html':'UTF-8'}
        </h1>

        {* Описание категории — важно для SEO (рекомендуемый объём: 100–300 слов).
         Используем <details>/<summary> вместо JS-toggle:
           • работает без JavaScript (graceful degradation)
           • текст всегда в DOM → Google и AI-агенты читают полный текст
           • пользователь видит первые строки, раскрывает по желанию
         ВНИМАНИЕ: $category.description может содержать HTML-теги (редактор в BO) —
         выводим без escape, это намеренно (аналогично notifications.tpl). *}
        {if isset($category.description) && $category.description}
          <details class="category-hero__description" open>
            <summary class="category-hero__description-toggle">
              {l s='Про категорію' d='Shop.Theme.Catalog'}
              <i class="fa-solid fa-chevron-down category-hero__description-icon" aria-hidden="true"></i>
            </summary>
            <div class="category-hero__description-body">
              {$category.description}
            </div>
          </details>
        {/if}

      </div>{* /container-fluid *}
    </div>{* /.category-hero *}


    {* ── 5. ПЛИТКИ ПОДКАТЕГОРИЙ ─────────────────────────────────────────────────
     Показываем если у текущей категории есть дочерние категории.
     Расположение: после Hero, перед Toolbar — логика навигации "вглубь".
     Пользователь сначала видит навигацию по подкатегориям, затем все товары.
     Сетка Bootstrap: 2 колонки mobile → 3 sm → 4 md → 5 lg → 6 xl.
     Фото подкатегории: если не загружено — иконка fa-tag на фоне --color-primary-subtle.
     Размеры оригиналов для загрузки: 400×400px WebP.
     ─────────────────────────────────────────────────────────────────────────── *}
    {if isset($subcategories) && $subcategories|@count > 0}
      <nav class="category-subcategories" aria-label="{l s='Підкатегорії' d='Shop.Theme.Catalog'}">
        <div class="container-fluid px-0">

          <h2 class="category-subcategories__title">
            {l s='Розділи' d='Shop.Theme.Catalog'}
          </h2>

          <div class="row row-cols-2 row-cols-sm-3 row-cols-md-4 row-cols-lg-5 row-cols-xl-6 g-3">
            {foreach from=$subcategories item='subcategory'}
              <div class="col">
                <a href="{$subcategory.url|escape:'html':'UTF-8'}" class="subcategory-tile"
                  title="{$subcategory.name|escape:'html':'UTF-8'}">
                  {* Фото подкатегории — если загружено в BO *}
                  {if isset($subcategory.image.small.url) && $subcategory.image.small.url}
                    <div class="subcategory-tile__img-wrapper">
                      <img src="{$subcategory.image.small.url|escape:'html':'UTF-8'}"
                        alt="{$subcategory.name|escape:'html':'UTF-8'}" width="160" height="160" loading="lazy">
                    </div>
                  {else}
                    {* Fallback: иконка на фирменном фоне, если фото не загружено *}
                    <div class="subcategory-tile__icon-wrapper" aria-hidden="true">
                      <i class="fa-solid fa-tag"></i>
                    </div>
                  {/if}

                  <span class="subcategory-tile__name">
                    {$subcategory.name|escape:'html':'UTF-8'}
                  </span>

                  {* Счётчик товаров в подкатегории (если доступен) *}
                  {if isset($subcategory.nb_products) && $subcategory.nb_products > 0}
                    <span class="subcategory-tile__count">
                      {$subcategory.nb_products} {l s='товарів' d='Shop.Theme.Catalog'}
                    </span>
                  {/if}

                </a>
              </div>
            {/foreach}
          </div>{* /.row *}

        </div>{* /container-fluid *}
      </nav>{* /.category-subcategories *}
    {/if}


    {* ── 6. OFFCANVAS: ФИЛЬТРЫ (мобильный/планшетный вид) ───────────────────────
     Bootstrap Offcanvas — открывается кнопкой в Toolbar (d-lg-none).
     Фильтры ps_facetedsearch рендерятся через hook displayLeftColumn.
     Паттерн: offcanvas drawer, а не модальное окно.
     Футер offcanvas содержит кнопку "Показати X товарів" — счётчик обновляется
     через JS при изменении фильтров (реализовать в category.js v0.14.0).
     aria-labelledby связывает offcanvas с его заголовком.
     ─────────────────────────────────────────────────────────────────────────── *}
    <div class="offcanvas offcanvas-start catalog-filters-offcanvas" tabindex="-1" id="catalog-filters-offcanvas"
      aria-labelledby="catalog-filters-offcanvas-label">
      <div class="offcanvas-header">
        <h2 class="offcanvas-title" id="catalog-filters-offcanvas-label">
          <i class="fa-solid fa-sliders me-2" aria-hidden="true"></i>
          {l s='Фільтри' d='Shop.Theme.Catalog'}
        </h2>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
          aria-label="{l s='Закрити фільтри' d='Shop.Theme.Catalog'}"></button>
      </div>

      <div class="offcanvas-body">
        {* Фильтры ps_facetedsearch — тема не вызывает модуль напрямую,
         только через стандартный хук PS. Слабая связь — замена модуля
         не сломает шаблон. *}
        {hook h='displayLeftColumn'}
      </div>

      {* Футер offcanvas: кнопка применения фильтров с живым счётчиком.
       data-catalog-count обновляется через JS при AJAX-фильтрации. *}
      <div class="offcanvas-footer">
        <button type="button" class="btn btn-primary w-100 catalog-filters-apply-btn" data-bs-dismiss="offcanvas"
          aria-label="{l s='Застосувати фільтри та закрити' d='Shop.Theme.Catalog'}">
          {l s='Показати' d='Shop.Theme.Catalog'}
          <span class="catalog-filters-apply-btn__count" data-catalog-count>
            {if isset($listing.pagination.total_items)}{$listing.pagination.total_items}{/if}
          </span>
          {l s='товарів' d='Shop.Theme.Catalog'}
        </button>
      </div>

    </div>{* /.offcanvas *}


    {* ── 7. TOOLBAR — УПРАВЛЕНИЕ ЛИСТИНГОМ ──────────────────────────────────────
     Структура (слева направо):
       [Фільтри] (mobile/tablet only) | [Сортування ▼] | [spacer] | [⊞ ⊟] | [X з Y]
     Sticky: прилипает к верху при скролле.
       — CSS: position: sticky + top = высота хедера (задаётся CSS-переменной --header-height)
       — JS (category.js v0.14.0): добавляет класс .catalog-toolbar--stuck для тени
     aria-label на toolbar — для скринридеров.
     ─────────────────────────────────────────────────────────────────────────── *}
    <div class="catalog-toolbar" id="js-catalog-toolbar"
      aria-label="{l s='Керування списком товарів' d='Shop.Theme.Catalog'}">
      <div class="container-fluid px-0">
        <div class="catalog-toolbar__inner">

          {* Кнопка открытия offcanvas фильтров — только mobile/tablet (< 992px) *}
          <button class="catalog-toolbar__filters-btn d-lg-none" type="button" data-bs-toggle="offcanvas"
            data-bs-target="#catalog-filters-offcanvas" aria-controls="catalog-filters-offcanvas">
            <i class="fa-solid fa-sliders" aria-hidden="true"></i>
            <span>{l s='Фільтри' d='Shop.Theme.Catalog'}</span>

            {* Счётчик активных фильтров — обновляется через JS.
             Скрыт если нет активных фильтров. *}
            {assign var='active_filters_count' value=0}
            {if isset($listing.active_filters)}
              {assign var='active_filters_count' value=$listing.active_filters|@count}
            {/if}
            {if $active_filters_count > 0}
              <span class="catalog-toolbar__filters-badge"
                aria-label="{l s='Активних фільтрів: %count%' sprintf=['%count%' => $active_filters_count] d='Shop.Theme.Catalog'}">{$active_filters_count}</span>
            {/if}
          </button>

          {* Сортировка товаров.
           $listing.sort_orders — массив доступных вариантов сортировки от PS9.
           CSS-кастомизация: appearance:none + fa-chevron-down через ::after (в category.css).
           onchange отправляет форму — JS (category.js) перехватит и выполнит AJAX. *}
          {if isset($listing.sort_orders) && $listing.sort_orders|@count > 0}
            <div class="catalog-toolbar__sort">
              <label for="catalog-sort-select" class="catalog-toolbar__sort-label visually-hidden">
                {l s='Сортування' d='Shop.Theme.Catalog'}
              </label>
              <div class="catalog-toolbar__sort-wrapper">
                <i class="fa-solid fa-arrow-up-short-wide catalog-toolbar__sort-icon" aria-hidden="true"></i>
                <select id="catalog-sort-select" class="catalog-toolbar__sort-select" name="order" data-catalog-sort>
                  {foreach from=$listing.sort_orders item='sort_order'}
                    <option value="{$sort_order.url_parameter|escape:'html':'UTF-8'}" {if $sort_order.current} selected{/if}>
                      {$sort_order.label|escape:'html':'UTF-8'}
                    </option>
                  {/foreach}
                </select>
                <i class="fa-solid fa-chevron-down catalog-toolbar__sort-chevron" aria-hidden="true"></i>
              </div>
            </div>
          {/if}

          {* Разделитель — push все правые элементы вправо (flex spacer) *}
          <div class="catalog-toolbar__spacer" aria-hidden="true"></div>

          {* Переключатель Grid/List.
           По умолчанию: Grid (PS_GRID_PRODUCT_DEFAULT: 1 в theme.yml).
           aria-pressed управляется через JS (category.js v0.14.0).
           Состояние сохраняется в localStorage ключ 'catalog-view'.
           Иконки FA7: fa-grid-2 (grid) | fa-list (list). *}
          <div class="catalog-toolbar__view-toggle" role="group"
            aria-label="{l s='Вид відображення товарів' d='Shop.Theme.Catalog'}">
            <button type="button" class="catalog-toolbar__view-btn catalog-toolbar__view-btn--grid" id="js-view-grid"
              aria-pressed="true" title="{l s='Сітка' d='Shop.Theme.Catalog'}" data-view="grid">
              <i class="fa-solid fa-grid-2" aria-hidden="true"></i>
              <span class="visually-hidden">{l s='Вид сітки' d='Shop.Theme.Catalog'}</span>
            </button>
            <button type="button" class="catalog-toolbar__view-btn catalog-toolbar__view-btn--list" id="js-view-list"
              aria-pressed="false" title="{l s='Список' d='Shop.Theme.Catalog'}" data-view="list">
              <i class="fa-solid fa-list" aria-hidden="true"></i>
              <span class="visually-hidden">{l s='Вид списку' d='Shop.Theme.Catalog'}</span>
            </button>
          </div>

          {* Счётчик товаров.
           Формула: "Показано X з Y товарів".
           $listing.products_count — количество товаров на текущей странице.
           $listing.pagination.total_items — общее количество в категории/фильтре.
           Оба значения обновляются при AJAX через data-атрибуты. *}
          {if isset($listing.pagination.total_items)}
            <p class="catalog-toolbar__counter" aria-live="polite" aria-atomic="true" data-catalog-counter>
              <span data-catalog-counter-shown>{if isset($listing.products)}{$listing.products|count}{else}0{/if}</span>
              {l s='з' d='Shop.Theme.Catalog'}
              <span data-catalog-counter-total>{$listing.pagination.total_items|intval}</span>
              {l s='товарів' d='Shop.Theme.Catalog'}
            </p>
          {/if}

        </div>{* /.catalog-toolbar__inner *}
      </div>{* /container-fluid *}
    </div>{* /.catalog-toolbar *}


    {* ── 8. ОСНОВНАЯ ОБЛАСТЬ: ФИЛЬТРЫ + ЛИСТИНГ ─────────────────────────────────
     Двухколоночный layout: aside (фильтры, 260px) + main (листинг).
     На desktop (≥992px): оба блока рядом через CSS Grid/Flexbox.
     На tablet/mobile (<992px): aside скрыт, фильтры в offcanvas.
     ─────────────────────────────────────────────────────────────────────────── *}
    <div class="catalog-layout">
      <div class="container-fluid px-0">
        <div class="catalog-layout__inner">

          {* ── 8a. ASIDE: ФИЛЬТРЫ (только desktop ≥992px) ──────────────────────
           Хук displayLeftColumn вызывает ps_facetedsearch.
           Тема стилизует обёртку (.catalog-layout__aside) и базовые классы модуля
           (.faceted-search, .faceted-search-block-title, .facet и т.д.).
           Переопределение шаблонов ps_facetedsearch — в v0.11.0.
           На мобильном этот блок скрыт (d-none d-lg-block в CSS).
           ─────────────────────────────────────────────────────────────────────── *}
          {assign var='has_left_column' value={hook h='displayLeftColumn'}}
          {if $has_left_column}
            <aside class="catalog-layout__aside" aria-label="{l s='Фільтри товарів' d='Shop.Theme.Catalog'}">
              {* Активные фильтры — быстрый сброс (рендерит ps_facetedsearch) *}
              {if isset($listing.active_filters) && $listing.active_filters|@count > 0}
                <div class="catalog-active-filters">
                  <div class="catalog-active-filters__header">
                    <span class="catalog-active-filters__title">
                      {l s='Обрані фільтри' d='Shop.Theme.Catalog'}
                    </span>
                    {* Ссылка "Скинути всі" — href = URL категории без параметров фильтров *}
                    <a href="{$listing.reset_filters_url|default:$category.url|escape:'html':'UTF-8'}"
                      class="catalog-active-filters__reset" aria-label="{l s='Скинути всі фільтри' d='Shop.Theme.Catalog'}">
                      {l s='Скинути всі' d='Shop.Theme.Catalog'}
                    </a>
                  </div>
                </div>
              {/if}

              {* Вызов хука — ps_facetedsearch рендерит свои фасеты здесь.
               Десктоп: aside виден.
               Mobile/tablet: aside скрыт через CSS (d-none d-lg-block),
               те же фасеты доступны через offcanvas (блок 6). *}
              {$has_left_column}
            </aside>
          {/if}


          {* ── 8b. MAIN: ЛИСТИНГ ТОВАРОВ ──────────────────────────────────────────
           <section> с id="js-product-list" — AJAX-зона обновления.
           Только эта секция перерисовывается при AJAX-фильтрации.
           aria-live="polite" — скринридер объявляет об обновлении списка.
           data-total — используется JS для обновления счётчика в Toolbar.
           ─────────────────────────────────────────────────────────────────────── *}
          <main class="catalog-layout__main">

            <section id="js-product-list" class="catalog-product-list" aria-live="polite"
              aria-label="{l s='Список товарів' d='Shop.Theme.Catalog'}"
              data-total="{if isset($listing.pagination.total_items)}{$listing.pagination.total_items|intval}{else}0{/if}">

              {* Хук PS9 — displayProductListHeader.
               Модули могут подключать дополнительные элементы перед листингом
               (баннеры категории, CMS-блоки и т.д.). *}
              {hook h='displayProductListHeader'}

              {* Список товаров — product-list.tpl (v0.6.0).
               Передаём $listing.products — массив товаров текущей страницы. *}
              {if isset($listing.products) && $listing.products|@count > 0}
                {include file='catalog/listing/product-list.tpl' products=$listing.products}
              {else}
                {* Пустое состояние — нет товаров в категории или по фильтру.
                 empty-state.tpl (v0.6.0): иконка + текст + CTA "В каталог". *}
                {include file='catalog/listing/_partials/empty-state.tpl'}
              {/if}

              {* Хук PS9 — displayProductListFooter.
               Модули могут добавлять контент после листинга. *}
              {hook h='displayProductListFooter'}

            </section>{* /#js-product-list *}


            {* ── 9. ПАГИНАЦИЯ ───────────────────────────────────────────────────
             pagination.tpl уже реализован (v0.5.1).
             Содержит rel="prev" / rel="next" для SEO.
             Разделители-многоточия с aria-hidden="true".
             Счётчик "Сторінка X з Y" под пагинацией.
             Весь блок обёрнут в {if pages_count > 1} внутри pagination.tpl —
             не рендерится на одностраничных листингах.
             При AJAX-фильтрации этот блок обновляется вместе с #js-product-list. *}
              {include file='_partials/pagination.tpl'}


            </main>{* /.catalog-layout__main *}

          </div>{* /.catalog-layout__inner *}
        </div>{* /container-fluid *}
      </div>{* /.catalog-layout *}


      {* ── AJAX ЛОАДЕР ─────────────────────────────────────────────────────────────
     Скрыт по умолчанию (атрибут hidden).
     JS (category.js v0.14.0) снимает hidden при отправке AJAX-запроса,
     возвращает hidden после получения ответа.
     Используется skeleton-loading (CSS shimmer) вместо spinner —
     снижает воспринимаемое время ожидания на 40% (Google UX Research, 2024).
     aria-hidden="true" — не озвучивать скринридером (контент обновляется
     через aria-live на #js-product-list). *}
      <div id="js-catalog-loader" class="catalog-loader" aria-hidden="true" hidden>
        {* Skeleton-карточки генерируются через JS или CSS-счётчик :nth-child.
       Количество: соответствует текущему числу карточек в сетке. *}
        <div class="catalog-loader__skeleton-grid" aria-hidden="true">
          {* 8 placeholder-карточек — перекрывают реальный контент при загрузке *}
          {section name='skeleton' loop=8}
            <div class="catalog-loader__skeleton-card">
              <div class="catalog-loader__skeleton-img"></div>
              <div class="catalog-loader__skeleton-title"></div>
              <div class="catalog-loader__skeleton-price"></div>
              <div class="catalog-loader__skeleton-btn"></div>
            </div>
          {/section}
        </div>
      </div>{* /#js-catalog-loader *}


      {* ── ХУКИ ПРАВОЙ КОЛОНКИ ─────────────────────────────────────────────────────
     displayRightColumn — зарезервирован для будущих модулей.
     В текущей версии layout-full-width не предусматривает правую колонку,
     но хук оставлен для совместимости с модулями. *}
      {assign var='right_column' value={hook h='displayRightColumn'}}
      {if $right_column}{$right_column}{/if}

    {/block}{* /content *}