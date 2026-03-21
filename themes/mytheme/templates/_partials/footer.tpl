{**
 * footer.tpl — подвал сайта mytheme
 * PrestaShop 9.0 / Smarty / Bootstrap 5.3 / Vanilla JS / Font Awesome 7
 *
 * СТРУКТУРА:
 *  1. Benefits Bar     — полоса преимуществ (иконки + текст, 4–5 блоков)
 *  2. Footer Main      — 4 колонки: лого/описание, покупателям, компания, подписка
 *  3. Subfooter        — copyright, иконки оплаты, правовые ссылки
 *
 * МОБИЛЬНОЕ ПОВЕДЕНИЕ:
 *  — Footer Main колонки 2 и 3 сворачиваются в аккордеон (Bootstrap Collapse)
 *  — Колонка 1 (лого + соцсети) и колонка 4 (подписка) — всегда раскрыты
 *  — Benefits Bar — горизонтальный скролл без wrap
 *  — Subfooter — иконки оплаты переносятся на новую строку
 *
 * ХУКИ:
 *  displayFooterBefore → блок перед основным footer (баннеры, уведомления)
 *  displayFooter       → ps_emailsubscription, ps_socialfollow + доп. контент
 *  displayFooterAfter  → после всего footer (cookie bar, скрипты)
 *
 * BEM-классы: .site-footer, .benefits-bar, .footer-main, .footer-col, .subfooter
 *}

{* Хук перед footer — для баннеров, уведомлений, etc. *}
{hook h='displayFooterBefore'}

<footer class="site-footer" role="contentinfo">

  {* ==========================================================================
     1. BENEFITS BAR
     Иконки + текст преимуществ магазина.
     На мобиле: горизонтальный скролл (overflow-x: auto, no-wrap).
     Содержимое легко менять — только здесь, без правки других файлов.
     ========================================================================== *}
  <section class="benefits-bar" aria-label="{l s='Our advantages' d='Shop.Theme.Global'}">
    <div class="container">
      <ul class="benefits-bar__list" role="list">

        <li class="benefits-bar__item">
          <span class="benefits-bar__icon" aria-hidden="true">
            <i class="fa-solid fa-truck-fast"></i>
          </span>
          <div class="benefits-bar__content">
            <strong class="benefits-bar__title">{l s='Fast Delivery' d='Shop.Theme.Global'}</strong>
            <span class="benefits-bar__text">{l s='1–2 business days' d='Shop.Theme.Global'}</span>
          </div>
        </li>

        <li class="benefits-bar__item">
          <span class="benefits-bar__icon" aria-hidden="true">
            <i class="fa-solid fa-rotate-left"></i>
          </span>
          <div class="benefits-bar__content">
            <strong class="benefits-bar__title">{l s='Easy Returns' d='Shop.Theme.Global'}</strong>
            <span class="benefits-bar__text">{l s='14 days return policy' d='Shop.Theme.Global'}</span>
          </div>
        </li>

        <li class="benefits-bar__item">
          <span class="benefits-bar__icon" aria-hidden="true">
            <i class="fa-solid fa-lock"></i>
          </span>
          <div class="benefits-bar__content">
            <strong class="benefits-bar__title">{l s='Secure Payment' d='Shop.Theme.Global'}</strong>
            <span class="benefits-bar__text">{l s='Protected transactions' d='Shop.Theme.Global'}</span>
          </div>
        </li>

        <li class="benefits-bar__item">
          <span class="benefits-bar__icon" aria-hidden="true">
            <i class="fa-solid fa-headset"></i>
          </span>
          <div class="benefits-bar__content">
            <strong class="benefits-bar__title">{l s='Support' d='Shop.Theme.Global'}</strong>
            <span class="benefits-bar__text">{l s='Mon–Sun 09:00–20:00' d='Shop.Theme.Global'}</span>
          </div>
        </li>

        <li class="benefits-bar__item">
          <span class="benefits-bar__icon" aria-hidden="true">
            <i class="fa-solid fa-shield-halved"></i>
          </span>
          <div class="benefits-bar__content">
            <strong class="benefits-bar__title">{l s='Warranty' d='Shop.Theme.Global'}</strong>
            <span class="benefits-bar__text">{l s='Official guarantee' d='Shop.Theme.Global'}</span>
          </div>
        </li>

      </ul>
    </div>
  </section>

  {* ==========================================================================
     2. FOOTER MAIN — 4 колонки
     Desktop: Bootstrap grid col-lg-3 (4×25%)
     Mobile:  колонки 2/3 — аккордеон Bootstrap Collapse
               колонки 1/4 — всегда видны
     ========================================================================== *}
  <div class="footer-main">
    <div class="container">
      <div class="row footer-main__row g-4 g-lg-5">

        {* ------------------------------------------------------------------
           КОЛОНКА 1: Лого + описание + соцсети
           Всегда раскрыта — аккордеон не применяется
           ------------------------------------------------------------------ *}
        <div class="col-12 col-lg-3 footer-col footer-col--brand">

          {* Лого *}
          <a href="{$urls.base_url}" class="footer-col__logo-link" aria-label="{l s='Home' d='Shop.Theme.Global'}">
            {if $shop.logo}
              <img
                src="{$shop.logo}"
                alt="{$shop.name|escape:'html'}"
                class="footer-col__logo-img"
                width="140"
                height="40"
                loading="lazy"
              >
            {else}
              <span class="footer-col__logo-text">{$shop.name|escape:'html'}</span>
            {/if}
          </a>

          {* Краткое описание магазина (CMS конфигурация или статичный текст) *}
          {if isset($shop.description) && $shop.description}
            <p class="footer-col__description">{$shop.description|escape:'html'}</p>
          {else}
            <p class="footer-col__description">{l s='Your reliable online shop. Quality products, fast delivery, excellent service.' d='Shop.Theme.Global'}</p>
          {/if}

          {* Соцсети — ps_socialfollow *}
          <div class="footer-col__social">
            {hook h='displaySocialTitle'}
            {* ps_socialfollow рендерит список ссылок на соцсети *}
          </div>

        </div>{* /.footer-col--brand *}

        {* ------------------------------------------------------------------
           КОЛОНКА 2: Покупателям
           На мобиле: аккордеон (Bootstrap Collapse)
           ------------------------------------------------------------------ *}
        <div class="col-12 col-lg-3 footer-col footer-col--buyers">

          {* Заголовок-триггер аккордеона (мобиле) / обычный заголовок (десктоп) *}
          <h3 class="footer-col__title">
            <button
              class="footer-col__accordion-btn d-lg-none w-100 d-flex justify-content-between align-items-center"
              type="button"
              data-bs-toggle="collapse"
              data-bs-target="#footerColBuyers"
              aria-expanded="false"
              aria-controls="footerColBuyers"
            >
              {l s='For Buyers' d='Shop.Theme.Global'}
              <i class="fa-solid fa-chevron-down footer-col__accordion-icon" aria-hidden="true"></i>
            </button>
            <span class="d-none d-lg-block">{l s='For Buyers' d='Shop.Theme.Global'}</span>
          </h3>

          {* Список ссылок (скрыт на мобиле, раскрывается аккордеоном) *}
          <div class="collapse d-lg-block" id="footerColBuyers">
            <ul class="footer-col__links" role="list">
              <li>
                <a href="{url entity='cms' id=1}" class="footer-col__link">
                  {l s='Delivery' d='Shop.Theme.Global'}
                </a>
              </li>
              <li>
                <a href="{url entity='cms' id=2}" class="footer-col__link">
                  {l s='Legal Notice' d='Shop.Theme.Global'}
                </a>
              </li>
              <li>
                <a href="{url entity='cms' id=3}" class="footer-col__link">
                  {l s='Terms and Conditions' d='Shop.Theme.Global'}
                </a>
              </li>
              <li>
                <a href="{url entity='cms' id=4}" class="footer-col__link">
                  {l s='About Us' d='Shop.Theme.Global'}
                </a>
              </li>
              <li>
                <a href="{url entity='cms' id=5}" class="footer-col__link">
                  {l s='Secure Payment' d='Shop.Theme.Global'}
                </a>
              </li>
              {* Дополнительные CMS ссылки добавляются здесь *}
            </ul>
          </div>

        </div>{* /.footer-col--buyers *}

        {* ------------------------------------------------------------------
           КОЛОНКА 3: Компания
           На мобиле: аккордеон
           ------------------------------------------------------------------ *}
        <div class="col-12 col-lg-3 footer-col footer-col--company">

          <h3 class="footer-col__title">
            <button
              class="footer-col__accordion-btn d-lg-none w-100 d-flex justify-content-between align-items-center"
              type="button"
              data-bs-toggle="collapse"
              data-bs-target="#footerColCompany"
              aria-expanded="false"
              aria-controls="footerColCompany"
            >
              {l s='Company' d='Shop.Theme.Global'}
              <i class="fa-solid fa-chevron-down footer-col__accordion-icon" aria-hidden="true"></i>
            </button>
            <span class="d-none d-lg-block">{l s='Company' d='Shop.Theme.Global'}</span>
          </h3>

          <div class="collapse d-lg-block" id="footerColCompany">
            <ul class="footer-col__links" role="list">
              <li>
                <a href="{url entity='contact'}" class="footer-col__link">
                  {l s='Contact Us' d='Shop.Theme.Global'}
                </a>
              </li>
              <li>
                <a href="{url entity='sitemap'}" class="footer-col__link">
                  {l s='Sitemap' d='Shop.Theme.Global'}
                </a>
              </li>
              {* Ссылка на личный кабинет *}
              {if isset($logged) && $logged}
                <li>
                  <a href="{$urls.pages.my_account}" class="footer-col__link">
                    {l s='My Account' d='Shop.Theme.Global'}
                  </a>
                </li>
                <li>
                  <a href="{$urls.pages.order_history}" class="footer-col__link">
                    {l s='Order History' d='Shop.Theme.Global'}
                  </a>
                </li>
              {else}
                <li>
                  <a href="{$urls.pages.authentication}" class="footer-col__link">
                    {l s='Sign In' d='Shop.Theme.Global'}
                  </a>
                </li>
              {/if}
            </ul>
          </div>

        </div>{* /.footer-col--company *}

        {* ------------------------------------------------------------------
           КОЛОНКА 4: Подписка на email
           Всегда раскрыта — важный элемент конверсии
           ------------------------------------------------------------------ *}
        <div class="col-12 col-lg-3 footer-col footer-col--newsletter">

          <h3 class="footer-col__title footer-col__title--plain">
            {l s='Newsletter' d='Shop.Theme.Global'}
          </h3>
          <p class="footer-col__description">
            {l s='Subscribe and be the first to know about new products and promotions.' d='Shop.Theme.Global'}
          </p>

          {* Форма подписки — ps_emailsubscription *}
          <div class="footer-col__newsletter-form">
            {* ps_emailsubscription disabled *}
          </div>

        </div>{* /.footer-col--newsletter *}

      </div>{* /.row *}
    </div>{* /.container *}
  </div>{* /.footer-main *}

  {* ==========================================================================
     3. SUBFOOTER — нижняя полоса
     Copyright слева, иконки оплаты по центру, правовые ссылки справа
     На мобиле: три строки (flex-column)
     ========================================================================== *}
  <div class="subfooter">
    <div class="container subfooter__inner">

      {* Copyright *}
      <p class="subfooter__copyright">
        &copy; {$smarty.now|date_format:'%Y'} {$shop.name|escape:'html'}.
        {l s='All rights reserved.' d='Shop.Theme.Global'}
      </p>

      {* Иконки способов оплаты *}
      <div class="subfooter__payment" aria-label="{l s='Payment methods' d='Shop.Theme.Global'}">
        {* Иконки через FA7 brands — замените на реальные логотипы или SVG *}
        <i class="fa-brands fa-cc-visa subfooter__payment-icon" aria-label="Visa" title="Visa"></i>
        <i class="fa-brands fa-cc-mastercard subfooter__payment-icon" aria-label="Mastercard" title="Mastercard"></i>
        <i class="fa-brands fa-google-pay subfooter__payment-icon" aria-label="Google Pay" title="Google Pay"></i>
        <i class="fa-brands fa-apple-pay subfooter__payment-icon" aria-label="Apple Pay" title="Apple Pay"></i>
        {* Monobank, ПриватБанк — через img если нет в FA *}
        {* <img src="{$urls.theme_assets}img/icons/privat24.svg" alt="Privat24" width="40" height="24" loading="lazy"> *}
      </div>

      {* Правовые ссылки *}
      <nav class="subfooter__legal" aria-label="{l s='Legal navigation' d='Shop.Theme.Global'}">
        <ul class="subfooter__legal-list" role="list">
          <li>
            <a href="{url entity='cms' id=2}" class="subfooter__legal-link">
              {l s='Legal Notice' d='Shop.Theme.Global'}
            </a>
          </li>
          <li>
            <a href="{url entity='cms' id=3}" class="subfooter__legal-link">
              {l s='Terms & Conditions' d='Shop.Theme.Global'}
            </a>
          </li>
          <li>
            <a href="{url entity='cms' id=6}" class="subfooter__legal-link">
              {l s='Privacy Policy' d='Shop.Theme.Global'}
            </a>
          </li>
        </ul>
      </nav>

    </div>{* /.subfooter__inner *}
  </div>{* /.subfooter *}

</footer>{* /.site-footer *}

{* Хук после footer — cookie consent (psgdpr), доп. скрипты *}
{hook h='displayFooterAfter'}

{* ============================================================================
   SPACER для мобильного bottom nav bar
   Предотвращает перекрытие контента фиксированной нижней навигацией.
   Высота должна совпадать с высотой .mobile-bottom-nav (задаётся в CSS).
   На десктопе (lg+) этот spacer скрыт через CSS.
   ============================================================================ *}
<div class="mobile-bottom-nav-spacer d-lg-none" aria-hidden="true"></div>
