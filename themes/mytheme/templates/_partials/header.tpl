{**
 * header.tpl — site header
 * PrestaShop 9.0 / Smarty / Bootstrap 5.3 / Vanilla JS / Font Awesome 7
 *
 * STRUCTURE:
 *  1. Announcement Bar       — hook displayBanner
 *  2. Desktop Header (md+)
 *     2a. Top Bar            — USP text, phone, language widget
 *     2b. Main Header        — logo, search, action icons
 *     2c. Site Nav           — compact logo + megamenu (includes mega-menu.tpl)
 *                             + compact action icons (sticky scroll state)
 *  3. Mobile Top Bar (< md)  — logo, search hook, contact button
 *  4. Mobile Bottom Nav      — 5 icons (fixed bottom, d-lg-none)
 *  5. Mobile Drawer          — custom JS overlay/drawer (includes mobile-menu.tpl)
 *  6. Offcanvas: Cart        — offcanvas-end (JS switches to offcanvas-bottom on mobile)
 *  7. Offcanvas: Wishlist    — offcanvas-bottom
 *  8. Offcanvas: Contact     — offcanvas-bottom
 *
 * STICKY BEHAVIOUR (SmartSticky / JS IntersectionObserver):
 *  Scroll down → top-bar hides, then main-header hides; site-nav stays sticky.
 *  Scroll up   → full header (including top-bar) returns.
 *  CSS classes: .site-header--hidden, .site-header--compact
 *
 * MODULE OVERRIDES:
 *  ps_searchbar   → themes/mytheme/modules/ps_searchbar/
 *  ps_shoppingcart→ themes/mytheme/modules/ps_shoppingcart/
 *  blockwishlist  → themes/mytheme/modules/blockwishlist/
 *}

{* ============================================================================
   1. ANNOUNCEMENT BAR
   Content managed via BO → Design → Positions → displayBanner.
   Block is not rendered when hook is empty (no empty stripe).
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
   2. DESKTOP HEADER (visible md+)
============================================================================ *}
<header class="site-header d-none d-md-flex" id="js-site-header" role="banner">

  {* ─────────────────────────────────────────────────────────────────────────
     2a. TOP BAR — USP text · phone · language
  ───────────────────────────────────────────────────────────────────────── *}
  <div class="top-bar" id="js-top-bar">
    <div class="top-bar__inner">

      <div class="top-bar__usp">
        <i class="fa-solid fa-leaf" aria-hidden="true"></i>
        {l s='Чисті вітаміни з Великобританії · Офіційний представник G&G Vitamins' d='Shop.Theme.Global'}
      </div>

      <div class="top-bar__right">
        {if $shop.phone}
          <a href="tel:{$shop.phone|regex_replace:'/[^+0-9]/':''}" class="top-bar__phone">
            <i class="fa-solid fa-phone" aria-hidden="true"></i>
            {l s='Підтримка:' d='Shop.Theme.Global'} {$shop.phone|escape:'html'}
          </a>
        {else}
          <a href="tel:+380441234567" class="top-bar__phone">
            <i class="fa-solid fa-phone" aria-hidden="true"></i>
            {l s='Підтримка:' d='Shop.Theme.Global'} +38 (044) 123-45-67
          </a>
        {/if}

        {* Language selector widget — renders current lang + dropdown *}
        {capture name="lang_selector"}{widget name="ps_languageselector"}{/capture}
        {if $smarty.capture.lang_selector|trim}
          {$smarty.capture.lang_selector nofilter}
        {else}
          <div class="top-bar__lang d-none d-md-flex">
            UA <i class="fa-solid fa-chevron-down" aria-hidden="true"></i>
            <div class="top-bar__lang-dropdown">
              <a href="#" class="active">🇺🇦 Українська</a>
              <hr>
              <a href="#">🇷🇺 Русский</a>
            </div>
          </div>
        {/if}
      </div>

    </div>
  </div>{* /.top-bar *}

  {* ─────────────────────────────────────────────────────────────────────────
     2b. MAIN HEADER — logo · search · action icons
  ───────────────────────────────────────────────────────────────────────── *}
  <div class="main-header" id="js-main-header">
    <div class="main-header__inner">

      {* Logo *}
      <a href="{$urls.base_url}" class="logo-block" aria-label="{l s='Головна' d='Shop.Theme.Global'}">
        {if $shop.logo}
          <img src="{$shop.logo}" alt="{$shop.name|escape:'html'}"
               class="main-header__logo-img" width="140" height="40" loading="eager">
        {else}
          <div>
            <div class="logo-text">{$shop.name|escape:'html'}</div>
            {if $shop.baseline}
              <div class="logo-sub">{$shop.baseline|escape:'html'}</div>
            {/if}
          </div>
        {/if}
      </a>

      {* Search — always-open field *}
      <div class="header-search flex-grow-1">
        {hook h='displaySearch'}
        {* Override: themes/mytheme/modules/ps_searchbar/ps_searchbar.tpl *}
      </div>

      {* Action icons: wishlist · account · cart *}
      <div class="header-actions" id="js-header-actions"
           role="navigation" aria-label="{l s='Дії шапки' d='Shop.Theme.Global'}">

        {* Wishlist *}
        <button class="action-btn" type="button"
                data-bs-toggle="offcanvas" data-bs-target="#offcanvasWishlist"
                aria-controls="offcanvasWishlist"
                title="{l s='My wishlist' d='Shop.Theme.Global'}"
                aria-label="{l s='My wishlist' d='Shop.Theme.Global'}">
          <i class="fa-regular fa-heart" aria-hidden="true"></i>
          {hook h='displayWishlistTop'}
        </button>

        {* Account dropdown *}
        <div class="header-account">
          {if isset($logged) && $logged}
            <a href="{$urls.pages.my_account}" class="action-btn"
               title="{l s='Мій акаунт' d='Shop.Theme.Global'}"
               aria-label="{l s='Мій акаунт' d='Shop.Theme.Global'}">
              <i class="fa-solid fa-user" aria-hidden="true"></i>
            </a>
            <div class="account-dropdown">
              <a href="{$urls.pages.my_account}">
                <i class="fa-solid fa-user-circle" aria-hidden="true"></i>
                {l s='Profile' d='Shop.Theme.Global'}
              </a>
              <a href="{$urls.pages.order_history}">
                <i class="fa-solid fa-box" aria-hidden="true"></i>
                {l s='Мої замовлення' d='Shop.Theme.Global'}
              </a>
              <a href="#">
                <i class="fa-regular fa-heart" aria-hidden="true"></i>
                {l s='Обране' d='Shop.Theme.Global'}
              </a>
              <hr>
              <a href="{$urls.pages.logout}" class="logout-link">
                <i class="fa-solid fa-right-from-bracket" aria-hidden="true"></i>
                {l s='Вихід' d='Shop.Theme.Global'}
              </a>
            </div>
          {else}
            <a href="{$urls.pages.authentication}" class="action-btn"
               title="{l s='Увійти' d='Shop.Theme.Global'}"
               aria-label="{l s='Увійти' d='Shop.Theme.Global'}">
              <i class="fa-solid fa-user" aria-hidden="true"></i>
            </a>
          {/if}
        </div>

        {* Cart *}
        <button class="action-btn" type="button"
                data-bs-toggle="offcanvas" data-bs-target="#offcanvasCart"
                aria-controls="offcanvasCart"
                title="{l s='Кошик' d='Shop.Theme.Global'}"
                aria-label="{l s='Кошик' d='Shop.Theme.Global'}">
          <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i>
          {hook h='displayShoppingCart'}
        </button>

      </div>{* /.header-actions *}
    </div>{* /.main-header__inner *}
  </div>{* /.main-header *}

  {* ─────────────────────────────────────────────────────────────────────────
     2c. SITE NAV — compact logo (sticky) + megamenu + compact actions (sticky)
  ───────────────────────────────────────────────────────────────────────── *}
  <nav class="site-nav" id="js-site-nav"
       role="navigation" aria-label="{l s='Головна навігація' d='Shop.Theme.Global'}">
    <div class="site-nav__inner">

      {* Compact logo — visible when header collapses on scroll *}
      <div class="nav-compact-left">
        <a href="{$urls.base_url}" class="logo-block" aria-label="{l s='Головна' d='Shop.Theme.Global'}">
          {if $shop.logo}
            <img src="{$shop.logo}" alt="{$shop.name|escape:'html'}"
                 class="main-header__logo-img" width="110" height="32" loading="lazy">
          {else}
            <div>
              <div class="logo-text">{$shop.name|escape:'html'}</div>
              {if $shop.baseline}
                <div class="logo-sub">{$shop.baseline|escape:'html'}</div>
              {/if}
            </div>
          {/if}
        </a>
      </div>

      {* Megamenu nav list *}
      {include file='_partials/mega-menu.tpl'}

      {* Compact action icons — visible when header collapses on scroll *}
      <div class="nav-compact-right">

        {* Wishlist *}
        <button class="action-btn" type="button"
                data-bs-toggle="offcanvas" data-bs-target="#offcanvasWishlist"
                aria-controls="offcanvasWishlist"
                title="{l s='Обране' d='Shop.Theme.Global'}"
                aria-label="{l s='Обране' d='Shop.Theme.Global'}">
          <i class="fa-regular fa-heart" aria-hidden="true"></i>
          {hook h='displayWishlistTop'}
        </button>

        {* Account *}
        <div class="header-account">
          {if isset($logged) && $logged}
            <a href="{$urls.pages.my_account}" class="action-btn"
               title="{l s='Мій акаунт' d='Shop.Theme.Global'}"
               aria-label="{l s='Мій акаунт' d='Shop.Theme.Global'}">
              <i class="fa-solid fa-user" aria-hidden="true"></i>
            </a>
            <div class="account-dropdown">
              <a href="{$urls.pages.my_account}">
                <i class="fa-solid fa-user-circle" aria-hidden="true"></i>
                {l s='Профіль' d='Shop.Theme.Global'}
              </a>
              <a href="{$urls.pages.order_history}">
                <i class="fa-solid fa-box" aria-hidden="true"></i>
                {l s='Мої замовлення' d='Shop.Theme.Global'}
              </a>
              <hr>
              <a href="{$urls.pages.logout}" class="logout-link">
                <i class="fa-solid fa-right-from-bracket" aria-hidden="true"></i>
                {l s='Вихід' d='Shop.Theme.Global'}
              </a>
            </div>
          {else}
            <a href="{$urls.pages.authentication}" class="action-btn"
               title="{l s='Увійти' d='Shop.Theme.Global'}"
               aria-label="{l s='Увійти' d='Shop.Theme.Global'}">
              <i class="fa-solid fa-user" aria-hidden="true"></i>
            </a>
          {/if}
        </div>

        {* Cart *}
        <button class="action-btn" type="button"
                data-bs-toggle="offcanvas" data-bs-target="#offcanvasCart"
                aria-controls="offcanvasCart"
                title="{l s='Кошик' d='Shop.Theme.Global'}"
                aria-label="{l s='Кошик' d='Shop.Theme.Global'}">
          <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i>
          {hook h='displayShoppingCart'}
        </button>

      </div>{* /.nav-compact-right *}
    </div>{* /.site-nav__inner *}
  </nav>

</header>{* /.site-header *}

{* ============================================================================
   3. MOBILE TOP BAR (hidden md+)
   Logo centred between search and contact button.
============================================================================ *}
<header class="mobile-top-bar d-md-none" role="banner"
        aria-label="{l s='Мобільна шапка' d='Shop.Theme.Global'}">
  <div class="mobile-top-bar__inner">

    {* Logo — text only, no subtitle *}
    <a href="{$urls.base_url}" class="mobile-top-bar__logo mobile-logo-text"
       aria-label="{l s='Головна' d='Shop.Theme.Global'}">
      {if $shop.logo}
        <img src="{$shop.logo}" alt="{$shop.name|escape:'html'}"
             class="mobile-top-bar__logo-img" width="32" height="32" loading="eager">
      {else}
        <div class="logo-text">{$shop.name|escape:'html'}</div>
      {/if}
    </a>

    {* Search — stretches to fill space between logo and contact btn *}
    <div class="mobile-top-bar__search flex-grow-1">
      {hook h='displaySearch'}
    </div>

    {* Contact button — opens offcanvasContact *}
    <button class="mobile-top-bar__contact-btn" type="button"
            data-bs-toggle="offcanvas" data-bs-target="#offcanvasContact"
            aria-controls="offcanvasContact"
            aria-label="{l s='Контакти' d='Shop.Theme.Global'}">
      <i class="fa-solid fa-headset" aria-hidden="true"></i>
    </button>

  </div>
</header>

{* ============================================================================
   4. MOBILE BOTTOM NAV — 5 icons (fixed bottom, hidden md+)
============================================================================ *}
<nav class="mobile-bottom-nav d-md-none" role="navigation"
     aria-label="{l s='Мобільна навігація' d='Shop.Theme.Global'}">
  <ul class="mobile-bottom-nav__list" role="list">

    {* Home *}
    <li class="mobile-bottom-nav__item">
      <a href="{$urls.base_url}"
         class="mobile-bottom-nav__link{if $page.page_name == 'index'} mobile-bottom-nav__link--active{/if}"
         aria-label="{l s='Головна' d='Shop.Theme.Global'}"
         {if $page.page_name == 'index'}aria-current="page"{/if}>
        <i class="fa-solid fa-house" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Головна' d='Shop.Theme.Global'}</span>
      </a>
    </li>

    {* Catalog — opens mobile drawer (custom JS, Bootstrap attrs stripped by theme.js) *}
    <li class="mobile-bottom-nav__item">
      <button class="mobile-bottom-nav__link" type="button"
              data-bs-toggle="offcanvas" data-bs-target="#offcanvasMobileMenu"
              aria-controls="offcanvasMobileMenu"
              aria-label="{l s='Каталог' d='Shop.Theme.Global'}">
        <i class="fa-solid fa-layer-group" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Каталог' d='Shop.Theme.Global'}</span>
      </button>
    </li>

    {* Cart — offcanvas-bottom on mobile (class toggled by theme.js CartOffcanvas module) *}
    <li class="mobile-bottom-nav__item">
      <button class="mobile-bottom-nav__link mobile-bottom-nav__cart" type="button"
              data-bs-toggle="offcanvas" data-bs-target="#offcanvasCart"
              aria-controls="offcanvasCart"
              aria-label="{l s='Кошик' d='Shop.Theme.Global'}">
        <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Кошик' d='Shop.Theme.Global'}</span>
        {* Badge count — injected via JS from ps_shoppingcart data *}
        <span class="mobile-bottom-nav__badge cart-count" aria-live="polite" aria-atomic="true"></span>
      </button>
    </li>

    {* Wishlist — offcanvas-bottom *}
    <li class="mobile-bottom-nav__item">
      <button class="mobile-bottom-nav__link" type="button"
              data-bs-toggle="offcanvas" data-bs-target="#offcanvasWishlist"
              aria-controls="offcanvasWishlist"
              aria-label="{l s='Обране' d='Shop.Theme.Global'}">
        <i class="fa-regular fa-heart" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Обране' d='Shop.Theme.Global'}</span>
      </button>
    </li>

    {* Menu — opens mobile drawer *}
    <li class="mobile-bottom-nav__item">
      <button class="mobile-bottom-nav__link" type="button"
              data-bs-toggle="offcanvas" data-bs-target="#offcanvasMobileMenu"
              aria-controls="offcanvasMobileMenu"
              aria-label="{l s='Меню' d='Shop.Theme.Global'}">
        <i class="fa-solid fa-bars" aria-hidden="true"></i>
        <span class="mobile-bottom-nav__label">{l s='Меню' d='Shop.Theme.Global'}</span>
      </button>
    </li>

  </ul>
</nav>

{* ============================================================================
   5. MOBILE DRAWER — custom JS overlay + drawer (slides from left)
   Controlled by MobileDrawer + DrawerAccordion in assets/js/theme.js.
   Bootstrap data-bs-* attrs on open-buttons are stripped by MobileDrawer.init().
   id="offcanvasMobileMenu" kept for selector consistency with bottom nav buttons.
============================================================================ *}
<div class="drawer-overlay" id="js-drawer-overlay"></div>

<div class="mobile-drawer" id="offcanvasMobileMenu" aria-label="{l s='Мобільне меню' d='Shop.Theme.Global'}">

  <div class="drawer-header">
    <a href="{$urls.base_url}" class="drawer-logo" aria-label="{l s='Головна' d='Shop.Theme.Global'}">
      {if $shop.logo}
        <img src="{$shop.logo}" alt="{$shop.name|escape:'html'}" width="120" height="36" loading="lazy">
      {else}
        <div>
          <div class="logo-text">{$shop.name|escape:'html'}</div>
          {if $shop.baseline}
            <div class="logo-sub">{$shop.baseline|escape:'html'}</div>
          {/if}
        </div>
      {/if}
    </a>
    <button class="drawer-close" id="js-drawer-close"
            aria-label="{l s='Закрити меню' d='Shop.Theme.Global'}">&times;</button>
  </div>

  <div class="drawer-nav">
    {include file='_partials/mobile-menu.tpl'}
  </div>

</div>{* /.mobile-drawer *}

{* ============================================================================
   6. OFFCANVAS: CART
   Desktop: offcanvas-end (slides from right).
   Mobile: switched to offcanvas-bottom by CartOffcanvas module in theme.js.
   Content rendered via AJAX — ps_shoppingcart override in modules/.
============================================================================ *}
<div class="offcanvas offcanvas-cart" tabindex="-1"
     id="offcanvasCart" aria-labelledby="offcanvasCartLabel"
     data-cart-offcanvas="true">
  <div class="offcanvas-header offcanvas-cart__header">
    <h2 class="offcanvas-title offcanvas-cart__title" id="offcanvasCartLabel">
      <i class="fa-solid fa-cart-shopping me-2" aria-hidden="true"></i>
      {l s='Мій кошик' d='Shop.Theme.Global'}
    </h2>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
            aria-label="{l s='Закрити кошик' d='Shop.Theme.Global'}"></button>
  </div>
  <div class="offcanvas-body offcanvas-cart__body">
    {hook h='displayShoppingCartDetailed'}
  </div>
  <div class="offcanvas-cart__footer">
    <a href="{$urls.pages.cart}" class="btn btn-primary w-100 offcanvas-cart__checkout-btn">
      {l s='Перейти до оформлення' d='Shop.Theme.Global'}
      <i class="fa-solid fa-arrow-right ms-2" aria-hidden="true"></i>
    </a>
  </div>
</div>{* /#offcanvasCart *}

{* ============================================================================
   7. OFFCANVAS: WISHLIST — offcanvas-bottom (slides up from bottom)
   Opened by: mobile bottom nav heart btn + desktop header heart btn.
   Content rendered via blockwishlist override in modules/.
============================================================================ *}
<div class="offcanvas offcanvas-bottom offcanvas-wishlist" tabindex="-1"
     id="offcanvasWishlist" aria-labelledby="offcanvasWishlistLabel">
  <div class="offcanvas-header offcanvas-wishlist__header">
    <h2 class="offcanvas-title offcanvas-wishlist__title" id="offcanvasWishlistLabel">
      <i class="fa-regular fa-heart me-2" aria-hidden="true"></i>
      {l s='Моє обране' d='Shop.Theme.Global'}
    </h2>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
            aria-label="{l s='Закрити обране' d='Shop.Theme.Global'}"></button>
  </div>
  <div class="offcanvas-body offcanvas-wishlist__body">
    {hook h='displayWishlist'}
  </div>
  <div class="offcanvas-wishlist__footer">
    <a href="{$urls.pages.wishlist|default:'#'}" class="btn btn-outline-primary w-100">
      {l s='Переглянути всі обрані' d='Shop.Theme.Global'}
    </a>
  </div>
</div>{* /#offcanvasWishlist *}

{* ============================================================================
   8. OFFCANVAS: CONTACT — offcanvas-bottom (slides up from bottom)
   Opened by: mobile-top-bar contact (headset) button.
   Contains: Telegram, Viber, WhatsApp, phone channels.
============================================================================ *}
<div class="offcanvas offcanvas-bottom offcanvas-contact" tabindex="-1"
     id="offcanvasContact" aria-labelledby="offcanvasContactLabel">
  <div class="offcanvas-header offcanvas-contact__header">
    <h2 class="offcanvas-title offcanvas-contact__title" id="offcanvasContactLabel">
      {l s="Зв'язатися з нами" d='Shop.Theme.Global'}
    </h2>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
            aria-label="{l s='Закрити' d='Shop.Theme.Global'}"></button>
  </div>
  <div class="offcanvas-body offcanvas-contact__body">

    <p class="offcanvas-contact__subtitle">
      {l s="Оберіть зручний спосіб зв'язку" d='Shop.Theme.Global'}
    </p>

    <ul class="offcanvas-contact__channels" role="list">

      {* Telegram *}
      {if $shop.telegram|default:''}
        <li class="offcanvas-contact__channel">
          <a href="https://t.me/{$shop.telegram|escape:'html'}"
             class="offcanvas-contact__channel-link offcanvas-contact__channel-link--telegram"
             target="_blank" rel="noopener noreferrer" aria-label="Telegram">
            <i class="fa-brands fa-telegram offcanvas-contact__channel-icon" aria-hidden="true"></i>
            <span class="offcanvas-contact__channel-name">Telegram</span>
          </a>
        </li>
      {/if}

      {* Viber *}
      {if $shop.viber|default:''}
        <li class="offcanvas-contact__channel">
          <a href="viber://chat?number={$shop.viber|escape:'html'}"
             class="offcanvas-contact__channel-link offcanvas-contact__channel-link--viber"
             aria-label="Viber">
            <i class="fa-brands fa-viber offcanvas-contact__channel-icon" aria-hidden="true"></i>
            <span class="offcanvas-contact__channel-name">Viber</span>
          </a>
        </li>
      {/if}

      {* WhatsApp *}
      {if $shop.whatsapp|default:''}
        <li class="offcanvas-contact__channel">
          <a href="https://wa.me/{$shop.whatsapp|escape:'html'}"
             class="offcanvas-contact__channel-link offcanvas-contact__channel-link--whatsapp"
             target="_blank" rel="noopener noreferrer" aria-label="WhatsApp">
            <i class="fa-brands fa-whatsapp offcanvas-contact__channel-icon" aria-hidden="true"></i>
            <span class="offcanvas-contact__channel-name">WhatsApp</span>
          </a>
        </li>
      {/if}

      {* Phone *}
      {if $shop.phone|default:''}
        <li class="offcanvas-contact__channel">
          <a href="tel:{$shop.phone|regex_replace:'/[^+0-9]/':''}"
             class="offcanvas-contact__channel-link offcanvas-contact__channel-link--phone"
             aria-label="{l s='Зателефонувати нам' d='Shop.Theme.Global'}">
            <i class="fa-solid fa-phone offcanvas-contact__channel-icon" aria-hidden="true"></i>
            <span class="offcanvas-contact__channel-name">{$shop.phone|escape:'html'}</span>
            <span class="offcanvas-contact__channel-hours">
              {l s='Пн–Нд 09:00–20:00' d='Shop.Theme.Global'}
            </span>
          </a>
        </li>
      {/if}

    </ul>
  </div>
</div>{* /#offcanvasContact *}

{* Bootstrap manages its own backdrop — no custom overlay needed *}