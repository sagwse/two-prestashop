{**
 * ps_languageselector — Перемикач мов
 * Версія теми : mytheme v0.6.0 > v0.7.5
 * Файл         : modules/ps_languageselector/ps_languageselector.tpl
 *}

{* Десктопний дизайн — такий самий як в оригінальному prototype/header.html *}
<div class="top-bar__lang d-none d-md-flex">
  {$current_language.iso_code|upper} <i class="fa-solid fa-chevron-down" aria-hidden="true"></i>
  <div class="top-bar__lang-dropdown">
    {foreach from=$languages item=language name="langs"}
      <a href="{$link->getLanguageLink($language.id_lang)}" class="{if $language.id_lang == $current_language.id_lang}active{/if}">
        {if $language.iso_code|lower == 'uk' || $language.iso_code|lower == 'ua'}🇺🇦{elseif $language.iso_code|lower == 'ru'}🇷🇺{elseif $language.iso_code|lower == 'en'}🇬🇧{/if}
        {$language.name_simple}
      </a>
      {if !$smarty.foreach.langs.last}<hr>{/if}
    {/foreach}
  </div>
</div>

{* Мобільний дизайн для drawer-меню *}
<div class="drawer-lang-buttons d-md-none" style="display:flex; justify-content:center; gap: 0.5rem; width:100%;">
  {foreach from=$languages item=language}
    <a href="{$link->getLanguageLink($language.id_lang)}" 
       class="lang-btn {if $language.id_lang == $current_language.id_lang}active{/if}"
       style="padding: 0.5rem 1rem; border: 1px solid var(--color-border); border-radius: var(--radius-base); color: {if $language.id_lang == $current_language.id_lang}var(--color-primary){else}var(--color-text){/if}; font-weight: {if $language.id_lang == $current_language.id_lang}700{else}500{/if}; background: {if $language.id_lang == $current_language.id_lang}var(--color-primary-subtle){else}transparent{/if}; text-decoration: none;">
      {$language.iso_code|upper}
    </a>
  {/foreach}
</div>
