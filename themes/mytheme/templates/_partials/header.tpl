{**
* header.tpl — шапка сайта mytheme
* PrestaShop 9.0 / Smarty / Bootstrap 5.3 / Vanilla JS / Font Awesome 7
*
* СТРУКТУРА:
* 1. Announcement Bar — акционная плашка (статичная, управляется через хук displayBanner)
* 2. Top Bar (только десктоп) — язык, валюта
* 3. Main Header — лого, поиск, иконки (wishlist, аккаунт, корзина)
* 4. Desktop Navigation — горизонтальное меню с dropdown
* 5. Mobile Top Bar — поисковое поле + кнопка "Связаться" (fixed top, mobile only)
* 6. Mobile Bottom Nav Bar — 5 иконок (fixed bottom, mobile only)
* 7. Offcanvas: мобильное меню (placement: start)
* 8. Offcanvas: "Связаться" (placement: bottom)
* 9. Offcanvas: Mini-Cart (placement: bottom на mobile / end на desktop)
* 10. Offcanvas: Mini-Wishlist (placement: bottom)
* 11. Overlay backdrop
*
* ПОВЕДЕНИЕ STICKY (Smart Sticky / JS IntersectionObserver):
* — Скролл вниз → announcement bar скрывается первым, затем шапка прячется
* — Скролл вверх → вся шапка целиком возвращается (включая announcement bar)
* — CSS классы: .site-header--hidden, .site-header--compact
*
* ПЕРЕОПРЕДЕЛЕНИЯ МОДУЛЕЙ:
* — ps_searchbar → themes/mytheme/modules/ps_searchbar/
* — ps_shoppingcart → themes/mytheme/modules/ps_shoppingcart/
* — blockwishlist → themes/mytheme/modules/blockwishlist/
* — ps_mainmenu → themes/mytheme/modules/ps_mainmenu/
*
* BEM-классы: .site-header, .announcement-bar, .top-bar, .main-header,
* .site-nav, .mobile-top-bar, .mobile-bottom-nav
*}

{* ============================================================================
1. ANNOUNCEMENT BAR
Контент управляется через BO → Дизайн → Позиции → displayBanner
Если хук пустой — блок не рендерится (нет пустой полосы)
============================================================================ *}
{capture name="announcement_content"}{hook h='displayBanner'}{/capture}
{if $smarty.capture.announcement_content|trim != ''}
  <div class="announcement-bar" role="region" aria-label="{l s='Promotional announcement' d='Shop.Theme.Global'}">
    <div class="container-fluid announcement-bar__inner">
      {$smarty.capture.announcement_content nofilter}
    </div>
  </div>
{/if}

{* ============================================================================
2. TOP BAR — только десктоп (скрыт на мобиле через CSS d-none d-lg-block)
Язык, валюта — лёгкая тонкая полоса
============================================================================ *}
{capture name="top_bar_content"}
  {hook h='displayTop'}
{/capture}

{if $smarty.capture.top_bar_content|trim != '' || {hook h='displayNav2'}|trim != ''}
  <div class="top-bar d-none d-lg-block" role="navigation" aria-label="{l s='Utility navigation' d='Shop.Theme.Global'}">
    <div class="container top-bar__inner d-flex align-items-center justify-content-between">
      {* Используем класс top-bar__selector-zone для фильтрации ненужных модулей в CSS *}
      <div class="top-bar__left top-bar__selector-zone d-flex align-items-center gap-2">
        {$smarty.capture.top_bar_content nofilter}
      </div>
      <div class="top-bar__right ms-auto">
        {hook h='displayNav2'}
      </div>
    </div>
  </div>
{/if}

{capture name="nav_full_width"}{hook h='displayNavFullWidth'}{/capture}
{capture name="nav_default"}{hook h='displayNav'}{/capture}
{capture name="nav_top"}{hook h='displayTop'}{/capture}

{if $smarty.capture.nav_full_width|trim != ''}
  {assign var="main_menu_content" value=$smarty.capture.nav_full_width}
{elseif $smarty.capture.nav_default|trim != ''}
  {assign var="main_menu_content" value=$smarty.capture.nav_default}
{else}
  {assign var="main_menu_content" value=$smarty.capture.nav_top}
{/if}

{* ============================================================================
3. MAIN HEADER (десктоп) + обёртка site-header для sticky
============================================================================ *}
<header class="site-header" id="site-header" role="banner">
  <div class="main-header d-none d-lg-flex align-items-center">
    <div class="container main-header__inner d-flex align-items-center gap-4 w-100">

      {* --- Логотип + название магазина --- *}
      <a href="{$urls.base_url}" class="main-header__logo" aria-label="{l s='Home' d='Shop.Theme.Global'}">
        {if $shop.logo}
          <img src="{$shop.logo}" alt="{$shop.name|escape:'html'}" class="main-header__logo-img" width="140" height="40"
            loading="eager">
        {/if}
        {if $shop.name}
          <span class="main-header__shop-name visually-hidden">{$shop.name|escape:'html'}</span>
        {/if}
      </a>

      {* --- Поиск — всегда открытое поле --- *}
      <div class="main-header__search flex-grow-1">
        {hook h='displaySearch'}
        {* Переопределение: themes/mytheme/modules/ps_searchbar/ps_searchbar.tpl *}
      </div>

      {* --- Иконки справа: wishlist | аккаунт | корзина --- *}
      <div class="main-header__actions d-flex align-items-center gap-3" role="navigation"
        aria-label="{l s='Header actions' d='Shop.Theme.Global'}">

        {* Wishlist (blockwishlist) *}
        <button class="main-header__action-btn main-header__wishlist-btn" type="button" data-bs-toggle="offcanvas"
          data-bs-target="#offcanvasWishlist" aria-controls="offcanvasWishlist"
          aria-label="{l s='My wishlist' d='Shop.Theme.Global'}">
          <i class="fa-regular fa-heart" aria-hidden="true"></i>
          {* Счётчик — рендерится модулем blockwishlist через хук *}
          {hook h='displayWishlistTop'}
        </button>

        {* Аккаунт *}
        {if isset($logged) && $logged}
          <a href="{$urls.pages.my_account}" class="main-header__action-btn main-header__account-btn"
            aria-label="{l s='My account' d='Shop.Theme.Global'}">
            <i class="fa-solid fa-user" aria-hidden="true"></i>
          </a>
        {else}
          <a href="{$urls.pages.authentication}" class="main-header__action-btn main-header__account-btn"
            aria-label="{l s='Sign in' d='Shop.Theme.Global'}">
            <i class="fa-solid fa-user" aria-hidden="true"></i>
          </a>
        {/if}

        {* Корзина (ps_shoppingcart) *}
        <button class="main-header__action-btn main-header__cart-btn" type="button" data-bs-toggle="offcanvas"
          data-bs-target="#offcanvasCart" aria-controls="offcanvasCart" aria-label="{l s='Cart' d='Shop.Theme.Global'}">
          <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i>
          {* Счётчик рендерится модулем ps_shoppingcart *}
          {hook h='displayShoppingCart'}
        </button>

      </div>{* /.main-header__actions *}
    </div>{* /.main-header__inner *}
  </div>{* /.main-header *}

  {* ============================================================================
  4. DESKTOP NAVIGATION — горизонтальное меню с dropdown
  Управляется через: BO → Дизайн → Позиции → displayNav
  Переопределение: themes/mytheme/modules/ps_mainmenu/
  ============================================================================ *}
  <nav class="site-nav d-none d-lg-block" role="navigation" aria-label="{l s='Main navigation' d='Shop.Theme.Global'}">
    <div class="container site-nav__inner">
      {$main_menu_content nofilter}
    </div>
  </nav>

</header>{* /.site-header *}

{* ============================================================================
5. MOBILE TOP BAR — поиск + кнопка связи (fixed top, только мобиле/планшет)
============================================================================ *}
<header class="mobile-top-bar d-lg-none" role="banner" aria-label="{l s='Mobile header' d='Shop.Theme.Global'}">
  <div class="mobile-top-bar__inner">

    {* Лого (скрытый, но для семантики) *}
    <a href="{$urls.base_url}" class="mobile-top-bar__logo" aria-label="{l s='Home' d='Shop.Theme.Global'}">
      {if $shop.logo}
        <img src="{$shop.logo}" alt="{$shop.name|escape:'html'}" class="mobile-top-bar__logo-img" width="32" height="32"
          loading="eager">
      {/if}
    </a>

    {* Поиск — широкое поле на всю оставшуюся ширину *}
    <div class="mobile-top-bar__search flex-grow-1">
      {hook h='displaySearch'}
    </div>

    {* Кнопка "Связаться" — открывает offcanvas снизу *}
    <button class="mobile-top-bar__contact-btn" type="button" data-bs-toggle="offcanvas"
      data-bs-target="#offcanvasContact" aria-controls="offcanvasContact"
      aria-label="{l s='Contact us' d='Shop.Theme.Global'}">
      <i class="fa-solid fa-headset" aria-hidden="true"></i>
    </button>

  </div>
</header>

{* ============================================================================
6. MOBILE BOTTOM NAV BAR — 5 иконок (fixed bottom, только мобиле/планшет)
============================================================================ *}
<nav class="mobile-bottom-nav d-lg-none" role="navigation" aria-label="{l s='Mobile navigation' d='Shop.Theme.Global'}">
  <ul class="mobile-bottom-nav__list" role="list">

    {* Главная *}
    <li class="mobile-bottom-nav__item">
      <a href="{$urls.base_url}"
        class="mobile-bottom-nav__link{if $page.page_name == 'index'} mobile-bottom-nav__link--active{/if}"
        aria-label="{l s='Home' d='Shop.Theme.Global'}" {if $page.page_name == 'index'}aria-current="page" {/if}>
        <i class="fa-solid fa-house" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Home' d='Shop.Theme.Global'}</span>
      </a>
    </li>

    {* Каталог — открывает мобильное меню offcanvas *}
    <li class="mobile-bottom-nav__item">
      <button class="mobile-bottom-nav__link" type="button" data-bs-toggle="offcanvas"
        data-bs-target="#offcanvasMobileMenu" aria-controls="offcanvasMobileMenu"
        aria-label="{l s='Catalog' d='Shop.Theme.Global'}">
        <i class="fa-solid fa-layer-group" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Catalog' d='Shop.Theme.Global'}</span>
      </button>
    </li>

    {* Корзина — открывает mini-cart offcanvas *}
    <li class="mobile-bottom-nav__item">
      <button class="mobile-bottom-nav__link mobile-bottom-nav__cart" type="button" data-bs-toggle="offcanvas"
        data-bs-target="#offcanvasCart" aria-controls="offcanvasCart" aria-label="{l s='Cart' d='Shop.Theme.Global'}">
        <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Cart' d='Shop.Theme.Global'}</span>
        {* Счётчик корзины — inject через JS из данных модуля *}
        <span class="mobile-bottom-nav__badge cart-count" aria-live="polite" aria-atomic="true"></span>
      </button>
    </li>

    {* Избранное (Wishlist) — открывает mini-wishlist offcanvas *}
    <li class="mobile-bottom-nav__item">
      <button class="mobile-bottom-nav__link" type="button" data-bs-toggle="offcanvas"
        data-bs-target="#offcanvasWishlist" aria-controls="offcanvasWishlist"
        aria-label="{l s='My wishlist' d='Shop.Theme.Global'}">
        <i class="fa-regular fa-heart" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Wishlist' d='Shop.Theme.Global'}</span>
      </button>
    </li>

    {* Меню — открывает мобильное drawer-меню offcanvas *}
    <li class="mobile-bottom-nav__item">
      <button class="mobile-bottom-nav__link" type="button" data-bs-toggle="offcanvas"
        data-bs-target="#offcanvasMobileMenu" aria-controls="offcanvasMobileMenu"
        aria-label="{l s='Menu' d='Shop.Theme.Global'}">
        <i class="fa-solid fa-bars" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Menu' d='Shop.Theme.Global'}</span>
      </button>
    </li>

  </ul>
</nav>

{* ============================================================================
7. OFFCANVAS: МОБИЛЬНОЕ МЕНЮ (placement: start — выезжает слева)
Содержит: поиск вверху, категории аккордеон, lang/currency, ссылки
============================================================================ *}
<div class="offcanvas offcanvas-start offcanvas-mobile-menu" tabindex="-1" id="offcanvasMobileMenu"
  aria-labelledby="offcanvasMobileMenuLabel">
  <div class="offcanvas-header">
    <a href="{$urls.base_url}" class="offcanvas-mobile-menu__logo">
      {if $shop.logo}
        <img src="{$shop.logo}" alt="{$shop.name|escape:'html'}" width="120" height="36" loading="lazy">
      {elseif $shop.name}
        <span class="offcanvas-mobile-menu__shop-name">{$shop.name|escape:'html'}</span>
      {/if}
    </a>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
      aria-label="{l s='Close menu' d='Shop.Theme.Global'}"></button>
  </div>

  <div class="offcanvas-body offcanvas-mobile-menu__body">

    {* Навигация — категории с аккордеоном подкатегорий *}
    <nav class="offcanvas-mobile-menu__nav" aria-label="{l s='Mobile menu' d='Shop.Theme.Global'}">
      {$main_menu_content nofilter}
    </nav>

    {* Разделитель *}
    <hr class="offcanvas-mobile-menu__divider">

    {* Утилитарные ссылки *}
    <ul class="offcanvas-mobile-menu__utils" role="list">
      {if isset($logged) && $logged}
        <li>
          <a href="{$urls.pages.my_account}" class="offcanvas-mobile-menu__util-link">
            <i class="fa-solid fa-user" aria-hidden="true"></i>
            {l s='My account' d='Shop.Theme.Global'}
          </a>
        </li>
        <li>
          <a href="{$urls.pages.order_history}" class="offcanvas-mobile-menu__util-link">
            <i class="fa-solid fa-clock-rotate-left" aria-hidden="true"></i>
            {l s='Order history' d='Shop.Theme.Global'}
          </a>
        </li>
        <li>
          <a href="{$urls.pages.logout}" class="offcanvas-mobile-menu__util-link">
            <i class="fa-solid fa-right-from-bracket" aria-hidden="true"></i>
            {l s='Sign out' d='Shop.Theme.Global'}
          </a>
        </li>
      {else}
        <li>
          <a href="{$urls.pages.authentication}" class="offcanvas-mobile-menu__util-link">
            <i class="fa-solid fa-user" aria-hidden="true"></i>
            {l s='Sign in' d='Shop.Theme.Global'}
          </a>
        </li>
        <li>
          <a href="{$urls.pages.register}" class="offcanvas-mobile-menu__util-link">
            <i class="fa-solid fa-user-plus" aria-hidden="true"></i>
            {l s='Create account' d='Shop.Theme.Global'}
          </a>
        </li>
      {/if}
    </ul>

    <hr class="offcanvas-mobile-menu__divider">

    {* Язык и валюта — прямые виджеты без лишних модулей *}
    <div class="offcanvas-mobile-menu__locale">
      {widget name="ps_languageselector"}
      {widget name="ps_currencyselector"}
    </div>

  </div>{* /.offcanvas-body *}
</div>{* /#offcanvasMobileMenu *}

{* ============================================================================
8. OFFCANVAS: СВЯЗАТЬСЯ (placement: bottom — выезжает снизу)
Способы связи: чат, Telegram, Viber, WhatsApp, телефон
============================================================================ *}
<div class="offcanvas offcanvas-bottom offcanvas-contact" tabindex="-1" id="offcanvasContact"
  aria-labelledby="offcanvasContactLabel">
  <div class="offcanvas-header offcanvas-contact__header">
    <h2 class="offcanvas-title offcanvas-contact__title" id="offcanvasContactLabel">
      {l s='Contact us' d='Shop.Theme.Global'}
    </h2>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
      aria-label="{l s='Close' d='Shop.Theme.Global'}"></button>
  </div>

  <div class="offcanvas-body offcanvas-contact__body">
    <p class="offcanvas-contact__subtitle">{l s='Choose a convenient way to contact us' d='Shop.Theme.Global'}</p>
    <ul class="offcanvas-contact__channels" role="list">

      {* Telegram *}
      <li class="offcanvas-contact__channel">
        <a href="https://t.me/{$shop.telegram|default:''|escape:'html'}"
          class="offcanvas-contact__channel-link offcanvas-contact__channel-link--telegram" target="_blank"
          rel="noopener noreferrer" aria-label="Telegram">
          <i class="fa-brands fa-telegram offcanvas-contact__channel-icon" aria-hidden="true"></i>
          <span class="offcanvas-contact__channel-name">Telegram</span>
        </a>
      </li>

      {* Viber *}
      <li class="offcanvas-contact__channel">
        <a href="viber://chat?number={$shop.viber|default:''|escape:'html'}"
          class="offcanvas-contact__channel-link offcanvas-contact__channel-link--viber" aria-label="Viber">
          <i class="fa-brands fa-viber offcanvas-contact__channel-icon" aria-hidden="true"></i>
          <span class="offcanvas-contact__channel-name">Viber</span>
        </a>
      </li>

      {* WhatsApp *}
      <li class="offcanvas-contact__channel">
        <a href="https://wa.me/{$shop.whatsapp|default:''|escape:'html'}"
          class="offcanvas-contact__channel-link offcanvas-contact__channel-link--whatsapp" target="_blank"
          rel="noopener noreferrer" aria-label="WhatsApp">
          <i class="fa-brands fa-whatsapp offcanvas-contact__channel-icon" aria-hidden="true"></i>
          <span class="offcanvas-contact__channel-name">WhatsApp</span>
        </a>
      </li>

      {* Телефон *}
      <li class="offcanvas-contact__channel">
        <a href="tel:{$shop.phone|default:''|escape:'html'|regex_replace:'/[^+0-9]/':''}"
          class="offcanvas-contact__channel-link offcanvas-contact__channel-link--phone"
          aria-label="{l s='Call us' d='Shop.Theme.Global'}">
          <i class="fa-solid fa-phone offcanvas-contact__channel-icon" aria-hidden="true"></i>
          <span class="offcanvas-contact__channel-name">{$shop.phone|default:''|escape:'html'}</span>
          <span class="offcanvas-contact__channel-hours">{l s='Mon–Sun 09:00–20:00' d='Shop.Theme.Global'}</span>
        </a>
      </li>

    </ul>
  </div>
</div>{* /#offcanvasContact *}

{* ============================================================================
9. OFFCANVAS: MINI-CART (placement: bottom на мобиле, end на десктопе)
Рендерится через хук ps_shoppingcart — переопределение шаблона в modules/
На десктопе переключается в offcanvas-end через CSS/JS responsive классы
============================================================================ *}
<div class="offcanvas offcanvas-cart" tabindex="-1" id="offcanvasCart" aria-labelledby="offcanvasCartLabel"
  data-cart-offcanvas="true">
  <div class="offcanvas-header offcanvas-cart__header">
    <h2 class="offcanvas-title offcanvas-cart__title" id="offcanvasCartLabel">
      <i class="fa-solid fa-cart-shopping me-2" aria-hidden="true"></i>
      {l s='My Cart' d='Shop.Theme.Global'}
    </h2>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
      aria-label="{l s='Close cart' d='Shop.Theme.Global'}"></button>
  </div>
  <div class="offcanvas-body offcanvas-cart__body">
    {* Содержимое рендерится через AJAX при открытии — ps_shoppingcart *}
    {hook h='displayShoppingCartDetailed'}
  </div>
  <div class="offcanvas-cart__footer">
    <a href="{$urls.pages.cart}" class="btn btn-primary w-100 offcanvas-cart__checkout-btn">
      {l s='Go to checkout' d='Shop.Theme.Global'}
      <i class="fa-solid fa-arrow-right ms-2" aria-hidden="true"></i>
    </a>
  </div>
</div>{* /#offcanvasCart *}

{* ============================================================================
10. OFFCANVAS: MINI-WISHLIST (placement: bottom)
Рендерится через blockwishlist — переопределение в modules/
============================================================================ *}
<div class="offcanvas offcanvas-bottom offcanvas-wishlist" tabindex="-1" id="offcanvasWishlist"
  aria-labelledby="offcanvasWishlistLabel">
  <div class="offcanvas-header offcanvas-wishlist__header">
    <h2 class="offcanvas-title offcanvas-wishlist__title" id="offcanvasWishlistLabel">
      <i class="fa-regular fa-heart me-2" aria-hidden="true"></i>
      {l s='My Wishlist' d='Shop.Theme.Global'}
    </h2>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
      aria-label="{l s='Close wishlist' d='Shop.Theme.Global'}"></button>
  </div>
  <div class="offcanvas-body offcanvas-wishlist__body">
    {hook h='displayWishlist'}
    {* blockwishlist рендерит список сохранённых товаров *}
  </div>
  <div class="offcanvas-wishlist__footer">
    <a href="{$urls.pages.wishlist|default:'#'}" class="btn btn-outline-primary w-100">
      {l s='View full wishlist' d='Shop.Theme.Global'}
    </a>
  </div>
</div>{* /#offcanvasWishlist *}

{* ============================================================================
11. BACKDROP OVERLAY (для всех offcanvas — один общий)
Backdrop рендерит Bootstrap автоматически через data-bs-backdrop
Дополнительный оверлей не нужен — Bootstrap 5.3 управляет им сам
============================================================================ *}