{**
 * templates/_partials/pagination.tpl
 * v0.5.1 — Пагинация страниц каталога
 *
 * Переменные PS9 (из ProductListingFrontController):
 *   $pagination.current_page  — номер текущей страницы (int)
 *   $pagination.pages_count   — общее количество страниц (int)
 *   $pagination.pages         — массив объектов страниц:
 *     .page                   — номер страницы или null (разделитель)
 *     .url                    — URL страницы
 *     .current                — bool: текущая страница?
 *
 * Специальные элементы в $pagination.pages:
 *   Элементы с .page == null — разделители (многоточие «…»).
 *   PS9 сам формирует массив с разделителями по алгоритму «скользящего окна».
 *
 * Кнопки Предыдущая / Следующая:
 *   Генерируются отдельно на основе $pagination.current_page.
 *   URL строится через {url entity='category' ... params=['page' => N]} или
 *   берётся из первого/последнего элемента $pagination.pages.
 *   Проще и надёжнее — искать элемент с нужным номером страницы в массиве.
 *
 * Доступность:
 *   — <nav aria-label="..."> обёртка.
 *   — aria-current="page" на текущей странице.
 *   — aria-disabled="true" + tabindex="-1" на неактивных кнопках Prev/Next.
 *   — Текст «Предыдущая» / «Следующая» скрыт визуально (.visually-hidden),
 *     иконка aria-hidden="true" — screen readers читают текст, не иконку.
 *
 * Подключение в страничных шаблонах (listing/category.tpl, product-list.tpl):
 *   {if isset($pagination) && $pagination.pages_count > 1}
 *     {include file='_partials/pagination.tpl'}
 *   {/if}
 *}

{if isset($pagination) && $pagination.pages_count > 1}

  {* Вычисляем prev/next страницы *}
  {assign var='prev_page' value=$pagination.current_page - 1}
  {assign var='next_page' value=$pagination.current_page + 1}
  {assign var='has_prev'  value=($pagination.current_page > 1)}
  {assign var='has_next'  value=($pagination.current_page < $pagination.pages_count)}

  {* Находим URL для prev/next из массива страниц *}
  {assign var='prev_url' value=''}
  {assign var='next_url' value=''}
  {foreach from=$pagination.pages item='p'}
    {if $p.page == $prev_page}{assign var='prev_url' value=$p.url}{/if}
    {if $p.page == $next_page}{assign var='next_url' value=$p.url}{/if}
  {/foreach}

  <nav class="pagination-nav" aria-label="{l s='Page navigation' d='Shop.Theme.Global'}">
    <ul class="pagination pagination-nav__list justify-content-center mb-0">

      {* ── Кнопка «Предыдущая» ───────────────────────────────────────── *}
      <li class="page-item pagination-nav__item pagination-nav__item--prev{if !$has_prev} disabled{/if}">
        {if $has_prev && $prev_url}
          <a href="{$prev_url}" class="page-link pagination-nav__link" rel="prev"
            aria-label="{l s='Previous page' d='Shop.Theme.Global'}">
            <i class="fas fa-chevron-left" aria-hidden="true"></i>
            <span class="visually-hidden">{l s='Previous' d='Shop.Theme.Global'}</span>
          </a>
        {else}
          <span class="page-link pagination-nav__link" aria-disabled="true" tabindex="-1">
            <i class="fas fa-chevron-left" aria-hidden="true"></i>
            <span class="visually-hidden">{l s='Previous' d='Shop.Theme.Global'}</span>
          </span>
        {/if}
      </li>

      {* ── Нумерованные страницы ──────────────────────────────────────── *}
      {foreach from=$pagination.pages item='page_item'}

        {if $page_item.page === null}
          {* Разделитель — многоточие *}
          <li class="page-item pagination-nav__item pagination-nav__item--spacer disabled" aria-hidden="true">
            <span class="page-link pagination-nav__link pagination-nav__link--spacer">&hellip;</span>
          </li>

        {elseif $page_item.current}
          {* Текущая страница — не ссылка *}
          <li class="page-item pagination-nav__item active" aria-current="page">
            <span class="page-link pagination-nav__link">
              {$page_item.page}
              <span class="visually-hidden">{l s='(current)' d='Shop.Theme.Global'}</span>
            </span>
          </li>

        {else}
          {* Обычная страница — ссылка *}
          <li class="page-item pagination-nav__item">
            <a href="{$page_item.url}" class="page-link pagination-nav__link"
              aria-label="{l s='Page %page%' d='Shop.Theme.Global' sprintf=['%page%' => $page_item.page]}">
              {$page_item.page}
            </a>
          </li>

        {/if}

      {/foreach}

      {* ── Кнопка «Следующая» ─────────────────────────────────────────── *}
      <li class="page-item pagination-nav__item pagination-nav__item--next{if !$has_next} disabled{/if}">
        {if $has_next && $next_url}
          <a href="{$next_url}" class="page-link pagination-nav__link" rel="next"
            aria-label="{l s='Next page' d='Shop.Theme.Global'}">
            <span class="visually-hidden">{l s='Next' d='Shop.Theme.Global'}</span>
            <i class="fas fa-chevron-right" aria-hidden="true"></i>
          </a>
        {else}
          <span class="page-link pagination-nav__link" aria-disabled="true" tabindex="-1">
            <span class="visually-hidden">{l s='Next' d='Shop.Theme.Global'}</span>
            <i class="fas fa-chevron-right" aria-hidden="true"></i>
          </span>
        {/if}
      </li>

    </ul>

    {* Счётчик «Страница X из Y» — вспомогательный текст для ориентации *}
    <p class="pagination-nav__counter text-center mt-2 mb-0">
      <small class="text-muted">
        {l s='Page %current% of %total%' d='Shop.Theme.Global' sprintf=[
            '%current%' => $pagination.current_page,
            '%total%'   => $pagination.pages_count
          ]}
      </small>
    </p>

  </nav>

{/if}