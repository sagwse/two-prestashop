{**
 * mobile-menu.tpl — Mobile drawer: accordion nav + util links + lang switcher
 * Included by: templates/_partials/header.tpl  (inside #offcanvasMobileMenu)
 * PrestaShop 9.0 / Smarty / Bootstrap 5.3 / Font Awesome 7
 *
 * Controlled by: MobileDrawer + DrawerAccordion modules in assets/js/theme.js
 * NOT a Bootstrap offcanvas — custom JS overlay/drawer implementation.
 *}

{* ── Accordion catalog nav ────────────────────────────────────────── *}
<nav class="drawer-accordion" aria-label="{l s='Mobile catalog' d='Shop.Theme.Global'}">

  {* Vitamins *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--vit" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-sun" aria-hidden="true"></i></span>
      {l s='Vitamins' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <a href="#" class="mm-acc__link">{l s='Vitamin A' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Vitamin B (complex)' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">TOP</span>
        </a>
        <a href="#" class="mm-acc__link mm-acc__link--sub">B1 · B2 · B3 · B5 · B6 · B7 · B9 · B12</a>
        <a href="#" class="mm-acc__link">{l s='Vitamin C' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Vitamin D3' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★ №1</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='Vitamin E' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Vitamin K (K1 + K2-MK7)' d='Shop.Theme.Global'}</a>
        <div class="mm-acc__section">{l s='Multivitamins' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link">{l s='General' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='For women' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='For men' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='For children' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='All vitamins' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

  {* Minerals *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--min" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-gem" aria-hidden="true"></i></span>
      {l s='Minerals' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Magnesium (Mg)' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='Zinc (Zn)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Iron (Fe)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Calcium (Ca)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Selenium (Se)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Iodine (I)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Potassium (K)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Chromium (Cr)' d='Shop.Theme.Global'}</a>
        <div class="mm-acc__section">{l s='Complexes' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link">{l s='Multiminerals' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='All minerals' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

  {* Supplements *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--sup" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-capsules" aria-hidden="true"></i></span>
      {l s='Supplements' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Omega 3 / 6 / 9' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★</span>
        </a>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Probiotics' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='Amino acids' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Antioxidants' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Coenzyme Q10' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Collagen' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Digestive enzymes' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Superfoods' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Plant extracts' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Bee products' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Organic supplements' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">Wholefood</a>
        <a href="#" class="mm-acc__link">{l s='Drink powders' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='All supplements' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

  {* Special *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--spc" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-star" aria-hidden="true"></i></span>
      {l s='Special' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <div class="mm-acc__section">{l s='By audience' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='For women · SOOV' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--new">UK</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='For men' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='For children · Kids' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='50+ (age group)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='For pregnant women' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='For athletes' d='Shop.Theme.Global'}</a>
        <div class="mm-acc__section">{l s='By philosophy' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link">{l s='Vegan' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Organic' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">Clean Label</a>
        <a href="#" class="mm-acc__link">Daily Packs</a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='All ranges' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

  {* Popular *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--pop" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-fire" aria-hidden="true"></i></span>
      {l s='Popular' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <div class="mm-acc__section">{l s='Top picks to start' d='Shop.Theme.Global'}</div>
        <div class="mm-acc__chips">
          <a href="#" class="mm-chip mm-chip--hot">{l s='Vitamin D3' d='Shop.Theme.Global'}</a>
          <a href="#" class="mm-chip mm-chip--hot">{l s='Magnesium' d='Shop.Theme.Global'}</a>
          <a href="#" class="mm-chip mm-chip--hot">Omega-3</a>
          <a href="#" class="mm-chip">{l s='Vitamin C' d='Shop.Theme.Global'}</a>
          <a href="#" class="mm-chip">{l s='Probiotics' d='Shop.Theme.Global'}</a>
          <a href="#" class="mm-chip">{l s='Zinc' d='Shop.Theme.Global'}</a>
        </div>
        <div class="mm-acc__divider"></div>
        <div class="mm-acc__section">{l s='Sections' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link">
          <i class="fa-solid fa-wand-sparkles" aria-hidden="true"></i>
          {l s='New arrivals' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--new">NEW</span>
        </a>
        <a href="#" class="mm-acc__link">
          <i class="fa-solid fa-thumbs-up" aria-hidden="true"></i>
          {l s='Recommended' d='Shop.Theme.Global'}
        </a>
        <a href="#" class="mm-acc__link">
          <i class="fa-solid fa-tag" aria-hidden="true"></i>
          {l s='Sale items' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--sale">-%</span>
        </a>
        <a href="#" class="mm-acc__link">
          <i class="fa-solid fa-leaf" aria-hidden="true"></i>
          {l s='Seasonal picks' d='Shop.Theme.Global'}
        </a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='View all' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

</nav>{* /.drawer-accordion *}

{* ── Other nav links ───────────────────────────────────────────────── *}
<a href="#" class="drawer-nav-link nav-accent-mobile">
  <i class="fa-solid fa-tag" aria-hidden="true"></i>
  {l s='Sales' d='Shop.Theme.Global'}
</a>
<a href="#" class="drawer-nav-link">{l s='About brand' d='Shop.Theme.Global'}</a>
<a href="#" class="drawer-nav-link">{l s='Articles / Blog' d='Shop.Theme.Global'}</a>
<a href="#" class="drawer-nav-link">{l s='Distributors' d='Shop.Theme.Global'}</a>

{* ── Language switcher ─────────────────────────────────────────────── *}
<div class="drawer-lang" id="js-drawer-lang">
  {widget name="ps_languageselector"}
</div>

{* ── Auth button ───────────────────────────────────────────────────── *}
{if isset($logged) && $logged}
  <a href="{$urls.pages.my_account}" class="drawer-auth-btn">
    {l s='My account' d='Shop.Theme.Global'}
  </a>
{else}
  <a href="{$urls.pages.authentication}" class="drawer-auth-btn" id="js-drawer-auth">
    {l s='Sign in' d='Shop.Theme.Global'}
  </a>
{/if}
