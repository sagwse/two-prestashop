{**
 * empty-state.tpl — Пустое состояние листинга
 *
 * Версия темы : mytheme v0.6.0
 * PrestaShop  : 9.0.x
 * Шаблонизатор: Smarty
 *
 * Вызывается из:
 *   catalog/listing/product-list.tpl — когда $products пуст
 *
 * Два контекста (определяются автоматически):
 *   A) Активные фильтры + нет товаров
 *      → «За фільтрами нічого не знайдено»
 *      → Кнопка «Скинути фільтри» (primary)
 *      → Ссылка «До всього каталогу» (secondary)
 *
 *   B) Категория пуста (нет товаров вообще)
 *      → «У цій категорії поки немає товарів»
 *      → Кнопка «До каталогу» (primary)
 *
 * Семантика:
 *   role="status" — скринридер озвучивает блок как статусное сообщение.
 *   aria-live="polite" — при AJAX-обновлении скринридер дочитает текущее
 *   и затем объявит об изменении (не перебивает).
 *   <p> вместо <h2>/<h3> — H1 занят названием категории, вторичные
 *   заголовки в пустом состоянии нарушают SEO-иерархию.
 *
 * Переменные из контекста (глобальные Smarty, не передаются явно):
 *   $listing.active_filters      — массив активных фильтров
 *   $listing.reset_filters_url   — URL сброса фильтров
 *   $urls.pages.index            — главная страница / каталог
 *   $urls.current_url            — fallback для сброса фильтров
 *}


<div class="product-list-empty" role="status" aria-live="polite" aria-atomic="true">
  <div class="product-list-empty__inner">

    {* ── Иконка ─────────────────────────────────────────────────────────────
       Контекстная: при фильтрах — лупа с крестом, при пустой категории — коробка.
       aria-hidden — чисто декоративная, текст ниже несёт смысл.
       Цвет через CSS: color: var(--color-primary-light).
       ─────────────────────────────────────────────────────────────────────── *}
    {if isset($listing.active_filters) && $listing.active_filters|@count > 0}
      <i class="fa-solid fa-magnifying-glass-minus product-list-empty__icon" aria-hidden="true"></i>
    {else}
      <i class="fa-solid fa-box-open product-list-empty__icon" aria-hidden="true"></i>
    {/if}


    {* ── Текст и кнопки — два контекста ─────────────────────────────────── *}
    {if isset($listing.active_filters) && $listing.active_filters|@count > 0}

      {* ── КОНТЕКСТ A: Фильтры применены, товаров нет ──────────────────────
         Пользователь сам сузил выдачу — объясняем это явно.
         Два CTA: сбросить фильтры (решает проблему сразу)
                  или перейти в каталог (альтернативный путь).
         ─────────────────────────────────────────────────────────────────── *}
      <p class="product-list-empty__title">
        {l s='За обраними фільтрами товарів не знайдено' d='Shop.Theme.Catalog'}
      </p>

      <p class="product-list-empty__text">
        {l s='Спробуйте розширити пошук — зніміть один або кілька фільтрів' d='Shop.Theme.Catalog'}
      </p>

      {* Показываем активные фильтры компактно — пользователь понимает что именно мешает *}
      {assign var='shown_filters' value=0}
      <p class="product-list-empty__active-filters-hint">
        {l s='Зараз активні:' d='Shop.Theme.Catalog'}
        {foreach from=$listing.active_filters item='af'}
          {if $shown_filters < 3}
            <span class="product-list-empty__filter-tag">
              {$af.label|escape:'html':'UTF-8'}
            </span>
            {assign var='shown_filters' value=$shown_filters+1}
          {/if}
        {/foreach}
        {* Если фильтров больше 3 — показываем «+N» *}
        {if $listing.active_filters|@count > 3}
          <span class="product-list-empty__filter-more">
            +{$listing.active_filters|@count - 3}
          </span>
        {/if}
      </p>

      {* CTA 1: Сбросить все фильтры — основное действие *}
      <a href="{$listing.reset_filters_url|default:$urls.current_url|escape:'html':'UTF-8'}"
        class="btn btn-primary product-list-empty__btn" data-filter-reset-all>
        <i class="fa-solid fa-rotate-left me-2" aria-hidden="true"></i>
        {l s='Скинути всі фільтри' d='Shop.Theme.Catalog'}
      </a>

      {* CTA 2: Перейти в корень каталога — запасной путь *}
      <a href="{$urls.pages.index|escape:'html':'UTF-8'}" class="product-list-empty__link-secondary">
        {l s='Або переглянути весь каталог' d='Shop.Theme.Catalog'}
        <i class="fa-solid fa-arrow-right ms-1" aria-hidden="true"></i>
      </a>


    {else}

      {* ── КОНТЕКСТ B: Категория пуста совсем ──────────────────────────────
         Товаров нет по объективной причине — категория не наполнена.
         Один CTA: перейти в каталог.
         Не говорим «попробуйте фильтры» — фильтры здесь ни при чём.
         ─────────────────────────────────────────────────────────────────── *}
      <p class="product-list-empty__title">
        {l s='У цій категорії поки немає товарів' d='Shop.Theme.Catalog'}
      </p>

      <p class="product-list-empty__text">
        {l s='Зайдіть пізніше або перегляньте інші розділи каталогу' d='Shop.Theme.Catalog'}
      </p>

      <a href="{$urls.pages.index|escape:'html':'UTF-8'}" class="btn btn-primary product-list-empty__btn">
        <i class="fa-solid fa-store me-2" aria-hidden="true"></i>
        {l s='До всього каталогу' d='Shop.Theme.Catalog'}
      </a>

    {/if}

  </div>{* /.product-list-empty__inner *}
</div>{* /.product-list-empty *}