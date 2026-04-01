{**
 * mobile-menu.tpl — Мобільний drawer: акордеон-навігація + посилання + перемикач мови
 * Включається з: templates/_partials/header.tpl  (всередині #offcanvasMobileMenu)
 * PrestaShop 9.0 / Smarty / Bootstrap 5.3 / Font Awesome 7
 *
 * Керується: модулями MobileDrawer + DrawerAccordion в assets/js/theme.js
 * НЕ Bootstrap offcanvas — власна JS реалізація overlay/drawer.
 *}

{* ── Акордеон-навігація каталогу ───────────────────────────────────── *}
<nav class="drawer-accordion" aria-label="{l s='Каталог мобільний' d='Shop.Theme.Global'}">

  {* Вітаміни *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--vit" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-sun" aria-hidden="true"></i></span>
      {l s='Вітаміни' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <a href="#" class="mm-acc__link">{l s='Вітамін A' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Вітамін B (комплекс)' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">ТОП</span>
        </a>
        <a href="#" class="mm-acc__link mm-acc__link--sub">B1 · B2 · B3 · B5 · B6 · B7 · B9 · B12</a>
        <a href="#" class="mm-acc__link">{l s='Вітамін C' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Вітамін D3' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★ №1</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='Вітамін E' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Вітамін K (K1 + K2-MK7)' d='Shop.Theme.Global'}</a>
        <div class="mm-acc__section">{l s='Мультивітаміни' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link">{l s='Загальні' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Для жінок' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Для чоловіків' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Для дітей' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='Усі вітаміни' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

  {* Мінерали *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--min" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-gem" aria-hidden="true"></i></span>
      {l s='Мінерали' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Магній (Mg)' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='Цинк (Zn)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Залізо (Fe)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Кальцій (Ca)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Селен (Se)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Йод (I)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Калій (K)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Хром (Cr)' d='Shop.Theme.Global'}</a>
        <div class="mm-acc__section">{l s='Комплекси' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link">{l s='Мультимінерали' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='Усі мінерали' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

  {* Добавки *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--sup" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-capsules" aria-hidden="true"></i></span>
      {l s='Добавки' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Омега 3 / 6 / 9' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★</span>
        </a>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Пробіотики' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='Амінокислоти' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Антиоксиданти' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Коензим Q10' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Колаген' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Травні ферменти' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Суперфуди' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Рослинні екстракти' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Продукти бджільництва' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Органічні добавки' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">Wholefood</a>
        <a href="#" class="mm-acc__link">{l s='Порошки для напоїв' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='Усі добавки' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

  {* Спеціальні *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--spc" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-star" aria-hidden="true"></i></span>
      {l s='Спеціальні' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <div class="mm-acc__section">{l s='За аудиторією' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Для жінок · SOOV' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--new">UK</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='Для чоловіків' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link mm-acc__link--top">
          {l s='Для дітей · Kids' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--top">★</span>
        </a>
        <a href="#" class="mm-acc__link">{l s='50+ (вікова категорія)' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Для вагітних' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Для спортсменів' d='Shop.Theme.Global'}</a>
        <div class="mm-acc__section">{l s='За філософією' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link">{l s='Веганські' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">{l s='Органічні' d='Shop.Theme.Global'}</a>
        <a href="#" class="mm-acc__link">Clean Label</a>
        <a href="#" class="mm-acc__link">Daily Packs</a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='Усі лінійки' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

  {* Популярне *}
  <div class="mm-acc__item">
    <button class="mm-acc__head mm-acc__head--pop" aria-expanded="false">
      <span class="mm-col-icon"><i class="fa-solid fa-fire" aria-hidden="true"></i></span>
      {l s='Популярне' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down mm-acc__chevron" aria-hidden="true"></i>
    </button>
    <div class="mm-acc__body">
      <div class="mm-acc__body-inner">
        <div class="mm-acc__section">{l s='Топ для початку' d='Shop.Theme.Global'}</div>
        <div class="mm-acc__chips">
          <a href="#" class="mm-chip mm-chip--hot">{l s='Вітамін D3' d='Shop.Theme.Global'}</a>
          <a href="#" class="mm-chip mm-chip--hot">{l s='Магній' d='Shop.Theme.Global'}</a>
          <a href="#" class="mm-chip mm-chip--hot">Омега-3</a>
          <a href="#" class="mm-chip">{l s='Вітамін C' d='Shop.Theme.Global'}</a>
          <a href="#" class="mm-chip">{l s='Пробіотики' d='Shop.Theme.Global'}</a>
          <a href="#" class="mm-chip">{l s='Цинк' d='Shop.Theme.Global'}</a>
        </div>
        <div class="mm-acc__divider"></div>
        <div class="mm-acc__section">{l s='Розділи' d='Shop.Theme.Global'}</div>
        <a href="#" class="mm-acc__link">
          <i class="fa-solid fa-wand-sparkles" aria-hidden="true"></i>
          {l s='Новинки' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--new">NEW</span>
        </a>
        <a href="#" class="mm-acc__link">
          <i class="fa-solid fa-thumbs-up" aria-hidden="true"></i>
          {l s='Рекомендовані' d='Shop.Theme.Global'}
        </a>
        <a href="#" class="mm-acc__link">
          <i class="fa-solid fa-tag" aria-hidden="true"></i>
          {l s='Акційні товари' d='Shop.Theme.Global'}
          <span class="mm-badge mm-badge--sale">-%</span>
        </a>
        <a href="#" class="mm-acc__link">
          <i class="fa-solid fa-leaf" aria-hidden="true"></i>
          {l s='Сезонні добірки' d='Shop.Theme.Global'}
        </a>
        <a href="#" class="mm-acc__link mm-acc__link--seeall">
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          {l s='Переглянути все' d='Shop.Theme.Global'}
        </a>
      </div>
    </div>
  </div>

</nav>{* /.drawer-accordion *}

{* ── Інші навігаційні посилання ─────────────────────────────────────── *}
<a href="#" class="drawer-nav-link nav-accent-mobile">
  <i class="fa-solid fa-tag" aria-hidden="true"></i>
  {l s='Акції' d='Shop.Theme.Global'}
</a>
<a href="#" class="drawer-nav-link">{l s='Про бренд' d='Shop.Theme.Global'}</a>
<a href="#" class="drawer-nav-link">{l s='Статті / Блог' d='Shop.Theme.Global'}</a>
<a href="#" class="drawer-nav-link">{l s="Дистриб'ютори" d='Shop.Theme.Global'}</a>

{* ── Перемикач мови ─────────────────────────────────────────────────── *}
<div class="drawer-lang" id="js-drawer-lang">
  {capture name="mobile_lang_selector"}{widget name="ps_languageselector"}{/capture}
  {if $smarty.capture.mobile_lang_selector|trim}
    {$smarty.capture.mobile_lang_selector nofilter}
  {else}
    <div class="drawer-lang-buttons" style="display:flex; justify-content:center; gap: 0.5rem; width:100%;">
      <a href="#" class="lang-btn active"
         style="padding: 0.5rem 1rem; border: 1px solid var(--color-border); border-radius: var(--radius-base); color: var(--color-primary); font-weight: 700; background: var(--color-primary-subtle); text-decoration: none;">
        UA
      </a>
      <a href="#" class="lang-btn"
         style="padding: 0.5rem 1rem; border: 1px solid var(--color-border); border-radius: var(--radius-base); color: var(--color-text); font-weight: 500; background: transparent; text-decoration: none;">
        RU
      </a>
    </div>
  {/if}
</div>

{* ── Кнопка авторизації ─────────────────────────────────────────────── *}
{if isset($logged) && $logged}
  <a href="{$urls.pages.my_account}" class="drawer-auth-btn">
    {l s='Мій акаунт' d='Shop.Theme.Global'}
  </a>
{else}
  <a href="{$urls.pages.authentication}" class="drawer-auth-btn" id="js-drawer-auth">
    {l s='Увійти' d='Shop.Theme.Global'}
  </a>
{/if}
