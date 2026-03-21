{**
 * ps_currencyselector — Переключатель валют
 * Версия темы : mytheme v0.6.0
 * Bootstrap    : 5.3 Dropdown
 * Файл         : modules/ps_currencyselector/ps_currencyselector.tpl
 *}
<div class="currency-selector dropdown ms-2">
  <button 
    class="btn btn-sm btn-link text-white dropdown-toggle d-flex align-items-center gap-1 py-1 px-2 border-0" 
    type="button" 
    data-bs-toggle="dropdown" 
    data-bs-display="static"
    aria-expanded="false"
  >
    <span class="currency-selector__label d-none d-md-inline">{l s='Currency:' d='Shop.Theme.Global'}</span>
    <span class="currency-selector__current">
      {$current_currency.iso_code}{if $current_currency.sign !== $current_currency.iso_code} {$current_currency.sign}{/if}
    </span>
  </button>
  <ul class="dropdown-menu dropdown-menu-dark shadow" style="z-index: 2000;">

    {foreach from=$currencies item=currency}
      <li>
        <a 
          class="dropdown-item {if $currency.current} active {/if}" 
          rel="nofollow" 
          href="{$currency.url}"
        >
          {$currency.iso_code} {if $currency.sign !== $currency.iso_code}{$currency.sign}{/if}
        </a>
      </li>
    {/foreach}
  </ul>
</div>
