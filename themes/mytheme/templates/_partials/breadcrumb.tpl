{**
 * templates/_partials/breadcrumb.tpl
 * v0.5.1 — Хлебные крошки
 *
 * Переменные PS9 (из FrontController):
 *   $breadcrumb.links — массив элементов крошек.
 *   Каждый элемент:
 *     .title — название страницы (уже экранировано PS9)
 *     .url   — URL страницы
 *
 * Поведение:
 *   — На главной странице breadcrumb.links пустой → partial не выводится.
 *     Включение/исключение на уровне страничного шаблона через условие.
 *   — Последний элемент (текущая страница) — текст без ссылки,
 *     aria-current="page", не кликабелен.
 *   — Все предыдущие элементы — ссылки <a>.
 *
 * JSON-LD BreadcrumbList:
 *   Подключается глобально в head.tpl через schema-breadcrumb.tpl.
 *   Здесь только HTML — микроразметку не дублировать.
 *
 * Подключение в страничном шаблоне:
 *   {if isset($breadcrumb.links) && $breadcrumb.links|@count > 1}
 *     {include file='_partials/breadcrumb.tpl'}
 *   {/if}
 *
 * Пример вывода:
 *   Главная / Каталог / Смартфоны / iPhone 15 Pro
 *}

<nav class="breadcrumb-nav" aria-label="{l s='Breadcrumb' d='Shop.Theme.Global'}">
  <div class="container">
    <ol class="breadcrumb breadcrumb-nav__list mb-0" itemscope itemtype="https://schema.org/BreadcrumbList">

      {foreach from=$breadcrumb.links item='link' key='i'}

        {assign var='is_last' value=($i === $breadcrumb.links|@count - 1)}

        <li
          class="breadcrumb-item breadcrumb-nav__item{if $is_last} active{/if}"
          itemprop="itemListElement"
          itemscope
          itemtype="https://schema.org/ListItem"
        >
          {if $is_last}
            {* Текущая страница — не ссылка *}
            <span
              class="breadcrumb-nav__current"
              aria-current="page"
              itemprop="name"
            >
              {$link.title}
            </span>
          {else}
            {* Кликабельный элемент *}
            <a
              href="{$link.url}"
              class="breadcrumb-nav__link"
              itemprop="item"
            >
              <span itemprop="name">{$link.title}</span>
            </a>
          {/if}

          {* Скрытый порядковый номер для schema.org — не виден пользователю *}
          <meta itemprop="position" content="{$i + 1}">

        </li>

      {/foreach}

    </ol>
  </div>
</nav>
