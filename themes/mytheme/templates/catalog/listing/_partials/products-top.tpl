{**
 * products-top.tpl — Строка результатов внутри AJAX-зоны
 *
 * Версия темы : mytheme v0.6.0
 * PrestaShop  : 9.0.x
 * Шаблонизатор: Smarty
 *
 * Назначение:
 *   Информационная строка ВНУТРИ зоны #js-product-list.
 *   Перерисовывается при каждом AJAX-запросе (фильтры / пагинация / сортировка)
 *   вместе со всей сеткой товаров.
 *
 * НЕ дублирует toolbar из category.tpl:
 *   category.tpl  → .catalog-toolbar (sticky, снаружи AJAX-зоны):
 *                   кнопка фильтров + выбор сортировки + grid/list toggle
 *   products-top.tpl → .products-top (внутри AJAX-зоны):
 *                   актуальный счётчик + per-page + текущая сортировка (текст)
 *
 * Почему нужен отдельный файл:
 *   Счётчик «Показано X з Y» должен обновляться при AJAX —
 *   он находится внутри #js-product-list и перерисовывается автоматически.
 *   Toolbar в category.tpl находится СНАРУЖИ AJAX-зоны и не перерисовывается,
 *   его счётчик обновляется отдельно через JS (data-catalog-counter атрибуты).
 *   products-top.tpl — SSR-версия счётчика, всегда актуальная после AJAX.
 *
 * Содержимое:
 *   — Счётчик товаров: «Показано X–Y з Z товарів» с диапазоном страницы
 *   — Переключатель кол-ва товаров на странице (per-page): 12 / 24 / 48
 *   — Текущая сортировка (текстовый лейбл) — информирует при AJAX-навигации
 *
 * Переменные из контекста PS9:
 *   $listing.pagination.total_items   — всего товаров в категории/фильтре
 *   $listing.pagination.current_page  — текущая страница
 *   $listing.pagination.pages_count   — всего страниц
 *   $listing.products_count           — товаров на текущей странице
 *   $listing.sort_orders              — массив вариантов сортировки
 *   $ps_products_per_page             — текущее значение per-page
 *
 * Доступность:
 *   aria-live="polite" на счётчике — скринридер объявит об изменении числа
 *   после AJAX-обновления (полный блок обёрнут в aria-live в product-list.tpl).
 *   role="status" — статусная информация, не требует немедленного внимания.
 *}


{* ─────────────────────────────────────────────────────────────────────────────
   ВЫЧИСЛЕНИЯ диапазона «показано X–Y из Z»
   Пример: страница 2, 24 товара/страницу, всего 87 → «Показано 25–48 з 87»
   ───────────────────────────────────────────────────────────────────────────── *}

{* Текущая страница (fallback: 1) *}
{assign var='current_page' value=1}
{if isset($listing.pagination.current_page) && $listing.pagination.current_page > 0}
  {assign var='current_page' value=$listing.pagination.current_page|intval}
{/if}

{* Кол-во товаров на странице *}
{assign var='per_page' value=24}
{if isset($listing.products) && $listing.products|@count > 0}
  {assign var='per_page' value=$listing.products|@count}
{/if}

{* Всего товаров *}
{assign var='total_items' value=0}
{if isset($listing.pagination.total_items) && $listing.pagination.total_items}
  {assign var='total_items' value=$listing.pagination.total_items|intval}
{/if}

{* Первый товар диапазона: (страница-1) × кол-во + 1 *}
{math assign='range_from' equation="(p - 1) * n + 1" p=$current_page n=$per_page}
{if $range_from < 1}{assign var='range_from' value=1}{/if}

{* Последний товар диапазона: страница × кол-во (но не больше total) *}
{math assign='range_to' equation="p * n" p=$current_page n=$per_page}
{if $range_to > $total_items}{assign var='range_to' value=$total_items}{/if}

{* Текущий вариант сортировки (метка для отображения) *}
{assign var='current_sort_label' value=''}
{if isset($listing.sort_orders) && $listing.sort_orders|@count > 0}
  {foreach from=$listing.sort_orders item='sort_order'}
    {if isset($sort_order.current) && $sort_order.current}
      {assign var='current_sort_label' value=$sort_order.label}
    {/if}
  {/foreach}
{/if}


{* ═══════════════════════════════════════════════════════════════════════════
   РАЗМЕТКА
   ═══════════════════════════════════════════════════════════════════════════ *}

{* Не рендерим блок если товаров нет — пустое состояние выводит product-list.tpl *}
{if $total_items > 0}

  <div class="products-top">


    {* ── СЧЁТЧИК РЕЗУЛЬТАТОВ ─────────────────────────────────────────────────
     Формат: «Показано 1–24 з 87 товарів»
     Диапазон помогает пользователю понять где он находится в каталоге.
     aria-live="polite" + aria-atomic="true" — скринридер зачитает
     обновлённое значение целиком после AJAX (не по частям).
     role="status" — не прерывает текущее чтение скринридером.
     ─────────────────────────────────────────────────────────────────────── *}
    <p class="products-top__counter" role="status" aria-live="polite" aria-atomic="true">
      {if $total_items > $per_page}
        {* Многостраничный листинг — показываем диапазон *}
        {l s='Показано %from%–%to% з %total% товарів'
             sprintf=[
               '%from%'  => $range_from,
               '%to%'    => $range_to,
               '%total%' => $total_items
             ]
             d='Shop.Theme.Catalog'
          }
      {else}
        {* Все товары на одной странице — упрощённый формат *}
        {l s='%total% товарів' sprintf=['%total%' => $total_items] d='Shop.Theme.Catalog'}
      {/if}
    </p>


    {* ── ТЕКУЩАЯ СОРТИРОВКА (текстовый лейбл) ───────────────────────────────
     Показываем только если выбрана нестандартная сортировка.
     Помогает пользователю понять порядок после AJAX-обновления
     без необходимости смотреть в select (который снаружи AJAX-зоны).
     Пример: «Сортування: Ціна: за зростанням»
     Скрываем если метка пуста или соответствует сортировке по умолчанию.
     ─────────────────────────────────────────────────────────────────────── *}
    {if $current_sort_label}
      <p class="products-top__sort-label" aria-live="polite">
        <span class="visually-hidden">
          {l s='Поточне сортування:' d='Shop.Theme.Catalog'}
        </span>
        <i class="fa-solid fa-arrow-up-short-wide products-top__sort-icon" aria-hidden="true"></i>
        {$current_sort_label|escape:'html':'UTF-8'}
      </p>
    {/if}


    {* ── ПЕРЕКЛЮЧАТЕЛЬ КОЛИЧЕСТВА ТОВАРОВ НА СТРАНИЦЕ (per-page) ─────────────
     Варианты: 12 / 24 / 48.
     Текущее значение — активная кнопка (aria-pressed="true").
     При выборе — JS (category.js v0.14.0) добавляет параметр ?ipp=N к URL
     и выполняет AJAX-обновление.
     Параметр ipp (items per page) — стандартный для ps_facetedsearch.
     На мобильном — скрываем (d-none d-md-flex) — экономим место,
     мобильные пользователи редко меняют per-page.
     ─────────────────────────────────────────────────────────────────────── *}
    <div class="products-top__per-page d-none d-md-flex" role="group"
      aria-label="{l s='Кількість товарів на сторінці' d='Shop.Theme.Catalog'}">
      <span class="products-top__per-page-label" aria-hidden="true">
        {l s='Показувати:' d='Shop.Theme.Catalog'}
      </span>

      {foreach from=[12, 24, 48] item='ipp_value'}

        {* Определяем активное значение:
         Сравниваем с текущим per_page (кол-во товаров на странице).
         Если значения совпадают — кнопка активна. *}
        {assign var='is_active_ipp' value=false}
        {if $ipp_value == $per_page}
          {assign var='is_active_ipp' value=true}
        {/if}

        <button type="button" class="products-top__per-page-btn{if $is_active_ipp} products-top__per-page-btn--active{/if}"
          aria-pressed="{if $is_active_ipp}true{else}false{/if}" data-ipp="{$ipp_value}"
          {if $is_active_ipp}aria-current="true" {/if}>
          {$ipp_value}
        </button>

      {/foreach}

    </div>{* /.products-top__per-page *}


  </div>{* /.products-top *}

{/if}{* /if total_items > 0 *}