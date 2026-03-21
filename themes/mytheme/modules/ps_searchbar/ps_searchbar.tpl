{**
 * ps_searchbar — Поиск в шапке
 * Версия темы : mytheme v0.6.0
 * FontAwesome  : 7 (FAS)
 * Файл         : modules/ps_searchbar/ps_searchbar.tpl
 *}

{**
 * ps_searchbar — Поиск в шапке
 * Версия темы : mytheme v0.6.2
 * FontAwesome  : 7 (FAS)
 * Файл         : modules/ps_searchbar/ps_searchbar.tpl
 *}

<div id="search_widget" class="search-widget" data-search-controller-url="{$search_controller_url}">
  <form
    method="get"
    action="{$search_controller_url}"
    class="search-widget__form"
    role="search"
  >
    <input type="hidden" name="controller" value="search">
    <div class="search-widget__inner">
      <i class="fa-solid fa-magnifying-glass search-widget__icon" aria-hidden="true"></i>
      <input
        id="search_query_top"
        class="search-widget__input js-search-input"
        type="search"
        name="s"
        placeholder="{l s='Пошук у нашому каталозі...' d='Shop.Theme.Catalog'}"
        value="{$search_string|default:''|escape:'html':'UTF-8'}"
        autocomplete="off"
        aria-label="{l s='Search' d='Shop.Theme.Global'}"
        data-search-url="{$search_controller_url}"
        aria-haspopup="listbox"
        aria-autocomplete="list"
        aria-controls="search-results-dropdown"
      >
    </div>
    {* Кнопка убрана — поиск работает по Enter и через AJAX *}
  </form>
  {* Контейнер для результатов живого поиска *}
  <div id="search-results-dropdown" class="search-dropdown" role="listbox" hidden></div>
</div>
