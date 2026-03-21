{**
 * ps_languageselector — Переключатель языков
 * Версия темы : mytheme v0.6.0
 * Bootstrap    : 5.3 Dropdown
 * Файл         : modules/ps_languageselector/ps_languageselector.tpl
 *}
<div class="language-selector dropdown">
  <button 
    class="btn btn-sm btn-link text-white dropdown-toggle d-flex align-items-center gap-1 py-1 px-2 border-0" 
    type="button" 
    data-bs-toggle="dropdown" 
    data-bs-display="static"
    aria-expanded="false"
  >
    <span class="language-selector__label d-none d-md-inline">{l s='Language:' d='Shop.Theme.Global'}</span>
    <span class="language-selector__current">{$current_language.name_simple}</span>
  </button>
  <ul class="dropdown-menu dropdown-menu-dark shadow" style="z-index: 2000;">

    {foreach from=$languages item=language}
      <li>
        <a 
          class="dropdown-item {if $language.id_lang == $current_language.id_lang} active {/if}" 
          href="{$link->getLanguageLink($language.id_lang)}"
        >
          {$language.name_simple}
        </a>
      </li>
    {/foreach}
  </ul>
</div>
