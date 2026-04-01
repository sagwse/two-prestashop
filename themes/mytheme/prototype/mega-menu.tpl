{**
 * mega-menu.tpl — Desktop navigation megamenu
 * Included by: templates/_partials/header.tpl
 * PrestaShop 9.0 / Smarty / Bootstrap 5.3 / Font Awesome 7
 *
 * Contains: <ul class="nav-list"> with all megamenu items.
 * TODO: Replace hardcoded category links with PS category loop
 *       {foreach from=$categories item='cat'} once ps_mainmenu integration is done.
 *}

<ul class="nav-list">

  {* ── CATALOG megamenu ──────────────────────────────────────────────── *}
  <li class="has-megamenu">
    <a href="{url entity='category' id=2}" class="nav-btn-catalog">
      <i class="fa-solid fa-bars" aria-hidden="true"></i>
      {l s='Catalog' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down nav-caret" aria-hidden="true"></i>
    </a>

    <div class="nav-megamenu" id="js-megamenu-catalog">
      <div class="nav-megamenu__inner">

        <div class="mm-topbar">
          <span class="mm-topbar__label">{l s='Full range of G&G Vitamins UK' d='Shop.Theme.Global'}</span>
          <a href="{url entity='category' id=2}" class="mm-topbar__all">
            {l s='View all products' d='Shop.Theme.Global'}
            <i class="fa-solid fa-arrow-right" style="font-size:0.7rem" aria-hidden="true"></i>
          </a>
        </div>

        <div class="megamenu-catalog">

          {* ── Vitamins column ── *}
          <div class="megamenu-col megamenu-col--vit">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-sun" aria-hidden="true"></i></span>
              {l s='Vitamins' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <a href="#">{l s='Vitamin A' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-top">
                {l s='Vitamin B (complex)' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">TOP</span>
              </a>
              <a href="#" class="mm-sub">B1 · B2 · B3 · B5 · B6 · B7 · B9 · B12</a>
              <a href="#">{l s='Vitamin C' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-top">
                {l s='Vitamin D3' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★ №1</span>
              </a>
              <a href="#">{l s='Vitamin E' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Vitamin K (K1 + K2-MK7)' d='Shop.Theme.Global'}</a>
              <span class="mm-section-title">{l s='Multivitamins' d='Shop.Theme.Global'}</span>
              <a href="#">{l s='General' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='For women' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='For men' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='For children' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='All vitamins' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Minerals column ── *}
          <div class="megamenu-col megamenu-col--min">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-gem" aria-hidden="true"></i></span>
              {l s='Minerals' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <a href="#" class="mm-top">
                {l s='Magnesium (Mg)' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★</span>
              </a>
              <a href="#">{l s='Zinc (Zn)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Iron (Fe)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Calcium (Ca)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Selenium (Se)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Iodine (I)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Potassium (K)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Chromium (Cr)' d='Shop.Theme.Global'}</a>
              <span class="mm-section-title">{l s='Complexes' d='Shop.Theme.Global'}</span>
              <a href="#">{l s='Multiminerals' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='All minerals' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Supplements column ── *}
          <div class="megamenu-col megamenu-col--sup">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-capsules" aria-hidden="true"></i></span>
              {l s='Supplements' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <a href="#" class="mm-top">
                {l s='Omega 3 / 6 / 9' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★</span>
              </a>
              <a href="#" class="mm-top">
                {l s='Probiotics' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★</span>
              </a>
              <a href="#">{l s='Amino acids' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Antioxidants' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Coenzyme Q10' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Collagen' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Digestive enzymes' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Superfoods' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Plant extracts' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Bee products' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Organic supplements' d='Shop.Theme.Global'}</a>
              <a href="#">Wholefood</a>
              <a href="#">{l s='Drink powders' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='All supplements' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Special column ── *}
          <div class="megamenu-col megamenu-col--spc">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-star" aria-hidden="true"></i></span>
              {l s='Special' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <span class="mm-section-title">{l s='By audience' d='Shop.Theme.Global'}</span>
              <a href="#" class="mm-top">
                {l s='For women · SOOV' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--new">UK</span>
              </a>
              <a href="#">{l s='For men' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-top">
                {l s='For children · Kids' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★</span>
              </a>
              <a href="#">{l s='50+ (age group)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='For pregnant women' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='For athletes' d='Shop.Theme.Global'}</a>
              <span class="mm-section-title">{l s='By philosophy' d='Shop.Theme.Global'}</span>
              <a href="#">{l s='Vegan' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Organic' d='Shop.Theme.Global'}</a>
              <a href="#">Clean Label</a>
              <a href="#">Daily Packs</a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='All ranges' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Popular column ── *}
          <div class="megamenu-col megamenu-col--pop">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-fire" aria-hidden="true"></i></span>
              {l s='Popular' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <span class="mm-section-title">{l s='Top picks to start' d='Shop.Theme.Global'}</span>
              <div class="mm-chips">
                <a href="#" class="mm-chip mm-chip--hot">{l s='Vitamin D3' d='Shop.Theme.Global'}</a>
                <a href="#" class="mm-chip mm-chip--hot">{l s='Magnesium' d='Shop.Theme.Global'}</a>
                <a href="#" class="mm-chip mm-chip--hot">Omega-3</a>
                <a href="#" class="mm-chip">{l s='Vitamin C' d='Shop.Theme.Global'}</a>
                <a href="#" class="mm-chip">{l s='Probiotics' d='Shop.Theme.Global'}</a>
                <a href="#" class="mm-chip">{l s='Zinc' d='Shop.Theme.Global'}</a>
              </div>
              <div class="mm-pop-divider"></div>
              <span class="mm-section-title">{l s='Sections' d='Shop.Theme.Global'}</span>
              <a href="#">
                <i class="fa-solid fa-wand-sparkles" aria-hidden="true"></i>
                {l s='New arrivals' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--new">NEW</span>
              </a>
              <a href="#">
                <i class="fa-solid fa-thumbs-up" aria-hidden="true"></i>
                {l s='Recommended' d='Shop.Theme.Global'}
              </a>
              <a href="#">
                <i class="fa-solid fa-tag" aria-hidden="true"></i>
                {l s='Sale items' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--sale">-%</span>
              </a>
              <a href="#">
                <i class="fa-solid fa-leaf" aria-hidden="true"></i>
                {l s='Seasonal picks' d='Shop.Theme.Global'}
              </a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='View all' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── SOOV promo banner ── *}
          <div class="megamenu-soov">
            <div class="soov-inner">
              <div class="megamenu-soov__ribbon">
                <i class="fa-solid fa-circle-dot" aria-hidden="true"></i>
                {l s="Women's range" d='Shop.Theme.Global'}
              </div>
              <div class="megamenu-soov__brand">
                <div class="megamenu-soov__title">SOOV</div>
                <div class="megamenu-soov__dot"></div>
              </div>
              <div class="megamenu-soov__tagline">
                {l s="Women's Health" d='Shop.Theme.Global'}<br>
                {l s='Premium formulas from the UK' d='Shop.Theme.Global'}
              </div>
              <div class="soov-products">
                <div class="soov-group">
                  <div class="soov-group__label">{l s='Cycle' d='Shop.Theme.Global'}</div>
                  <div class="soov-group__tags">
                    <a href="#" class="soov-tag">Flow</a>
                    <a href="#" class="soov-tag">40+</a>
                    <a href="#" class="soov-tag">Meno</a>
                  </div>
                </div>
                <div class="soov-group">
                  <div class="soov-group__label">{l s='Health' d='Shop.Theme.Global'}</div>
                  <div class="soov-group__tags">
                    <a href="#" class="soov-tag">Deflate</a>
                    <a href="#" class="soov-tag">Ignite</a>
                    <a href="#" class="soov-tag">Endo</a>
                    <a href="#" class="soov-tag">Ova</a>
                  </div>
                </div>
                <div class="soov-group">
                  <div class="soov-group__label">{l s='7-day sachets' d='Shop.Theme.Global'}</div>
                  <div class="soov-group__tags">
                    <a href="#" class="soov-tag">Buzz</a>
                    <a href="#" class="soov-tag">Ow</a>
                    <a href="#" class="soov-tag">Ouch</a>
                    <a href="#" class="soov-tag">Vibes</a>
                    <a href="#" class="soov-tag">Crave</a>
                  </div>
                </div>
              </div>
            </div>
            <img class="soov-award"
              src="{$urls.theme_assets}img/soov-award.png"
              alt="Platinum 2025 Awards Winner"
              width="80" loading="lazy">
            <a href="https://soov.uk/" target="_blank" rel="noopener noreferrer" class="megamenu-soov__btn">
              {l s='Go to range' d='Shop.Theme.Global'}
              <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
            </a>
          </div>

        </div>{* /.megamenu-catalog *}
      </div>{* /.nav-megamenu__inner *}
    </div>{* /.nav-megamenu #js-megamenu-catalog *}
  </li>

  {* ── FOR WHAT megamenu ─────────────────────────────────────────────── *}
  <li class="has-megamenu">
    <a href="#">
      {l s='For what' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down nav-caret" aria-hidden="true"></i>
    </a>

    <div class="nav-megamenu" id="js-megamenu-forwhat">
      <div class="nav-megamenu__inner">

        <div class="mm-topbar">
          <span class="mm-topbar__label">{l s='Full range of G&G Vitamins UK' d='Shop.Theme.Global'}</span>
          <a href="{url entity='category' id=2}" class="mm-topbar__all">
            {l s='View all products' d='Shop.Theme.Global'}
            <i class="fa-solid fa-arrow-right" style="font-size:0.7rem" aria-hidden="true"></i>
          </a>
        </div>

        <div class="megamenu-forwhat">
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Protection' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Immunity' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Antioxidant protection' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Respiratory system' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Energy' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Energy and vitality' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Sport and muscles' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Weight loss and metabolism' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Mind' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Brain and memory' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Sleep and recovery' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Stress and nerves' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Body' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Heart and vessels' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Joints and bones' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Digestion' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Beauty' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Skin and hair' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Vision' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Detox and cleanse' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Special' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='For pregnant women' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s="Children's development" d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Hormonal balance' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Thyroid gland' d='Shop.Theme.Global'}</a>
          </div>
        </div>

        <div class="mm-forwhat-footer">
          <a href="#">
            {l s='→ All 18 health directions' d='Shop.Theme.Global'}
          </a>
        </div>

      </div>{* /.nav-megamenu__inner *}
    </div>{* /.nav-megamenu #js-megamenu-forwhat *}
  </li>

  {* ── Simple nav links ──────────────────────────────────────────────── *}
  <li>
    <a href="#" class="nav-accent">
      <i class="fa-solid fa-tag" aria-hidden="true"></i>
      {l s='Sales' d='Shop.Theme.Global'}
    </a>
  </li>
  <li><a href="#">{l s='About brand' d='Shop.Theme.Global'}</a></li>
  <li><a href="#">{l s='Articles / Blog' d='Shop.Theme.Global'}</a></li>
  <li><a href="#">{l s='Distributors' d='Shop.Theme.Global'}</a></li>

</ul>{* /.nav-list *}
