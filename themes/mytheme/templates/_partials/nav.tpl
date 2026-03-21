{**
 * templates/_partials/nav.tpl
 * v0.5.2 — Навигационная полоса (utility nav / secondary nav)
 *
 * Назначение:
 *   Рендерит хуки навигационной полосы PS9: displayNav1, displayNav2,
 *   displayNavFullWidth. Стандартные модули на этих хуках:
 *     displayNav1        — ps_languageselector, ps_currencyselector
 *     displayNav2        — ps_customersignin, blockwishlist, ps_shoppingcart
 *     displayNavFullWidth — ps_mainmenu (горизонтальное меню)
 *
 * Архитектура в этой теме:
 *   header.tpl уже содержит десктопную навигацию (секция 4) и все offcanvas.
 *   nav.tpl — изолированный partial для случаев когда нужно подключить
 *   навигационные хуки отдельно (например, в будущих layout-вариантах
 *   или при переопределении порядка хуков без правки header.tpl).
 *
 *   displayNav1 / displayNav2 на десктопе дублируют секции 2–3 header.tpl,
 *   поэтому в layout-full-width.tpl этот partial НЕ подключается напрямую —
 *   хуки уже вызваны внутри header.tpl. Partial готов для использования
 *   в альтернативных layout-файлах (например, layout-checkout.tpl в 0.8.0,
 *   где шапка упрощена и нет мобильного offcanvas).
 *
 * Хуки PS9:
 *   displayNav1         — левая зона nav bar (язык, валюта)
 *   displayNav2         — правая зона nav bar (аккаунт, корзина, wishlist)
 *   displayNavFullWidth — полноширинная зона (главное меню ps_mainmenu)
 *   displayTop          — над nav bar (анонс-баннеры модулей)
 *
 * Подключение (пример для альтернативного layout):
 *   {include file='_partials/nav.tpl'}
 *}

{* ── displayTop — над навигацией (анонс-баннеры, сообщения модулей) ────── *}
{if hook_exists('displayTop')}
  {assign var='hook_displayTop' value={hook h='displayTop'}}
  {if $hook_displayTop}
    <div class="nav-top-bar" role="banner">
      <div class="container">
        {$hook_displayTop nofilter}
      </div>
    </div>
  {/if}
{/if}

{* ── Utility nav bar: язык/валюта слева, аккаунт/корзина справа ────────── *}
{assign var='hook_nav1' value={hook h='displayNav1'}}
{assign var='hook_nav2' value={hook h='displayNav2'}}

{if $hook_nav1 || $hook_nav2}
  <nav class="nav-utility" aria-label="{l s='Utility navigation' d='Shop.Theme.Global'}">
    <div class="container">
      <div class="nav-utility__inner d-flex align-items-center justify-content-between">

        {* Левая зона: язык, валюта *}
        {if $hook_nav1}
          <div class="nav-utility__left d-flex align-items-center gap-2">
            {$hook_nav1 nofilter}
          </div>
        {/if}

        {* Правая зона: аккаунт, wishlist, корзина *}
        {if $hook_nav2}
          <div class="nav-utility__right d-flex align-items-center gap-2 ms-auto">
            {$hook_nav2 nofilter}
          </div>
        {/if}

      </div>
    </div>
  </nav>
{/if}

{* ── displayNavFullWidth — главное горизонтальное меню (ps_mainmenu) ───── *}
{assign var='hook_nav_full' value={hook h='displayNavFullWidth'}}

{if $hook_nav_full}
  <nav class="nav-main" aria-label="{l s='Main navigation' d='Shop.Theme.Global'}">
    <div class="container">
      {$hook_nav_full nofilter}
    </div>
  </nav>
{/if}
