{**
 * templates/index.tpl
 * v0.5.0 — Главная страница
 *
 * Extends: layouts/layout-full-width.tpl
 *
 * Структура секций:
 * ┌─────────────────────────────────────────────────────────────────────┐
 * │  1. HERO          — статичный HTML, h1, два CTA                     │
 * │  2. USP BAR       — 4 преимущества магазина (иконки FA7 + текст)    │
 * │  3. HOOK MODULES  — displayHome: категории, featured, баннер        │
 * │  4. ABOUT         — уникальный SEO-текст магазина                   │
 * │  5. FAQ           — Bootstrap аккордеон + JSON-LD FAQPage schema    │
 * └─────────────────────────────────────────────────────────────────────┘
 *
 * SEO:
 *   — h1 только один: в секции Hero
 *   — h2 для каждой именованной секции (About, FAQ)
 *   — Секции модулей (featured, категории) используют h2/h3 внутри
 *     своих шаблонов (переопределение в 0.11.0)
 *   — FAQ JSON-LD размещён inline перед аккордеоном (Google принимает
 *     <script type="application/ld+json"> в <body>)
 *
 * Переменные PS9 (доступны из IndexController):
 *   $page.page_name       → 'index'
 *   $shop.name            → название магазина
 *   $urls.pages.*         → системные URL страниц
 *   $urls.base_url        → базовый URL установки
 *}

{extends file='layouts/layout-full-width.tpl'}

{block name='content'}

{* ══════════════════════════════════════════════════════════════════════════
   1. HERO
   ──────────────────────────────────────────────────────────────────────────
   Полноширинная секция. Первый экран — главный оффер магазина.
   h1 — единственный на странице, содержит брендовый/ключевой запрос.
   Фон задаётся через CSS:
     .home-hero { background-image: url('/themes/mytheme/assets/img/hero-bg.webp'); }
   Для разных магазинов — переопределить через CSS-переменную:
     --hero-bg-image: url('...');
   ══════════════════════════════════════════════════════════════════════════ *}
<section class="home-hero" aria-label="{l s='Main banner' d='Shop.Theme.Global'}">
  <div class="home-hero__overlay" aria-hidden="true"></div>
  <div class="container home-hero__container">
    <div class="home-hero__content">

      <h1 class="home-hero__title">
        {* ⚠️ Заменить на реальный h1 с ключевым запросом магазина.
           Пример: «Купить инструменты в Киеве — доставка по Украине»
           $shop.name используется как безопасный fallback. *}
        {$shop.name|escape:'html':'UTF-8'}
      </h1>

      <p class="home-hero__subtitle">
        {* ⚠️ Заменить на ваш уникальный оффер *}
        {l s='Discover our best products at the best prices. Fast delivery, easy returns.' d='Shop.Theme.Global'}
      </p>

      <div class="home-hero__actions">
        {* Первичный CTA — в каталог / главную категорию *}
        <a
          href="{$urls.pages.all_products|default:'#'}"
          class="home-hero__cta home-hero__cta--primary btn btn-primary btn-lg"
          title="{l s='Browse all products' d='Shop.Theme.Global'}"
        >
          {l s='Shop Now' d='Shop.Theme.Global'}
          <i class="fas fa-arrow-right ms-2" aria-hidden="true"></i>
        </a>

        {* Вторичный CTA — о магазине (CMS id=1, заменить на реальный) *}
        <a
          href="{url entity='cms' id=1}"
          class="home-hero__cta home-hero__cta--secondary btn btn-outline-light btn-lg"
          title="{l s='Learn more about us' d='Shop.Theme.Global'}"
        >
          {l s='About Us' d='Shop.Theme.Global'}
        </a>
      </div>

    </div>
  </div>
</section>


{* ══════════════════════════════════════════════════════════════════════════
   2. USP BAR — Преимущества магазина
   ──────────────────────────────────────────────────────────────────────────
   Desktop: 4 колонки в ряд.
   Mobile:  горизонтальный скролл без переноса (flex-nowrap + overflow-x).
   Иконки: Font Awesome 7 Solid.
   Нет заголовка h2 — это вспомогательный блок доверия, не SEO-секция.
   ══════════════════════════════════════════════════════════════════════════ *}
<section class="home-usps" aria-label="{l s='Our advantages' d='Shop.Theme.Global'}">
  <div class="container">
    <ul class="home-usps__list list-unstyled" role="list">

      <li class="home-usps__item">
        <span class="home-usps__icon-wrap" aria-hidden="true">
          <i class="fas fa-truck-fast home-usps__icon"></i>
        </span>
        <div class="home-usps__text">
          <strong class="home-usps__name">
            {l s='Fast Delivery' d='Shop.Theme.Global'}
          </strong>
          <span class="home-usps__desc">
            {l s='2–5 business days' d='Shop.Theme.Global'}
          </span>
        </div>
      </li>

      <li class="home-usps__item">
        <span class="home-usps__icon-wrap" aria-hidden="true">
          <i class="fas fa-rotate-left home-usps__icon"></i>
        </span>
        <div class="home-usps__text">
          <strong class="home-usps__name">
            {l s='Easy Returns' d='Shop.Theme.Global'}
          </strong>
          <span class="home-usps__desc">
            {l s='14 days, free of charge' d='Shop.Theme.Global'}
          </span>
        </div>
      </li>

      <li class="home-usps__item">
        <span class="home-usps__icon-wrap" aria-hidden="true">
          <i class="fas fa-shield-halved home-usps__icon"></i>
        </span>
        <div class="home-usps__text">
          <strong class="home-usps__name">
            {l s='Secure Payment' d='Shop.Theme.Global'}
          </strong>
          <span class="home-usps__desc">
            {l s='SSL encrypted checkout' d='Shop.Theme.Global'}
          </span>
        </div>
      </li>

      <li class="home-usps__item">
        <span class="home-usps__icon-wrap" aria-hidden="true">
          <i class="fas fa-headset home-usps__icon"></i>
        </span>
        <div class="home-usps__text">
          <strong class="home-usps__name">
            {l s='Support' d='Shop.Theme.Global'}
          </strong>
          <span class="home-usps__desc">
            {l s='Mon–Sat, 9:00–18:00' d='Shop.Theme.Global'}
          </span>
        </div>
      </li>

    </ul>
  </div>
</section>


{* ══════════════════════════════════════════════════════════════════════════
   3. HOOK MODULES — displayHome
   ──────────────────────────────────────────────────────────────────────────
   Рендерит все модули хука displayHome в порядке их позиций в BO.
   Рекомендуемый порядок позиций в BO:
     1. ps_categoryproducts  → сетка категорий
     2. ps_featuredproducts  → витрина товаров
     3. ps_banner            → промо-баннер (опционально)
   Шаблоны модулей переопределяются в версии 0.11.0.
   ══════════════════════════════════════════════════════════════════════════ *}
{include file='_partials/hooks/displayHome.tpl'}


{* ══════════════════════════════════════════════════════════════════════════
   4. ABOUT — Уникальный SEO-текст магазина
   ──────────────────────────────────────────────────────────────────────────
   Индексируется поисковиками. Описывает магазин, ассортимент, ценности.
   Desktop: два столбца (текст слева, изображение справа).
   Mobile:  один столбец (изображение скрыто или ниже текста).
   ⚠️ Заменить текст и изображение на реальные перед запуском в production.
   ══════════════════════════════════════════════════════════════════════════ *}
<section class="home-about" aria-labelledby="home-about-heading">
  <div class="container">
    <div class="row align-items-center g-4 g-xl-5">

      {* Текстовый блок *}
      <div class="col-12 col-lg-6 home-about__content">

        <h2 id="home-about-heading" class="home-about__title">
          {* ⚠️ Заменить на реальный заголовок — о магазине, бренде или нише *}
          {l s='Why Choose Us?' d='Shop.Theme.Global'}
        </h2>

        <p class="home-about__lead">
          {* ⚠️ Заменить на уникальный текст с ключевыми запросами магазина *}
          {l s='We have been delivering quality products since 2015. Our team carefully selects every item in our catalog to ensure the best value for our customers.' d='Shop.Theme.Global'}
        </p>

        <p class="home-about__text">
          {l s='From order to delivery, we handle everything with care. Our support team is always ready to help, and our return policy is hassle-free.' d='Shop.Theme.Global'}
        </p>

        {* Список ключевых преимуществ (bullets) *}
        <ul class="home-about__list list-unstyled" role="list">
          <li class="home-about__list-item">
            <i class="fas fa-circle-check home-about__list-icon" aria-hidden="true"></i>
            {l s='10 000+ satisfied customers' d='Shop.Theme.Global'}
          </li>
          <li class="home-about__list-item">
            <i class="fas fa-circle-check home-about__list-icon" aria-hidden="true"></i>
            {l s='Official manufacturer warranties' d='Shop.Theme.Global'}
          </li>
          <li class="home-about__list-item">
            <i class="fas fa-circle-check home-about__list-icon" aria-hidden="true"></i>
            {l s='Delivery across the country' d='Shop.Theme.Global'}
          </li>
        </ul>

        <a
          href="{url entity='cms' id=1}"
          class="home-about__link btn btn-outline-secondary mt-2"
          title="{l s='About our store' d='Shop.Theme.Global'}"
        >
          {l s='Learn More' d='Shop.Theme.Global'}
          <i class="fas fa-arrow-right ms-2" aria-hidden="true"></i>
        </a>

      </div>

      {* Медиа-блок: изображение магазина / товаров *}
      <div class="col-12 col-lg-6 home-about__media" aria-hidden="true">
        {*
          ⚠️ Заменить src на реальное изображение.
          Рекомендуемые размеры: 780×585 px (ratio 4:3), формат webp.
          Путь: /themes/mytheme/assets/img/about-home.webp
          Или загрузите через BO и используйте полный URL.
        *}
        <div class="home-about__img-wrap ratio ratio-4x3">
          <img
            src="{$urls.base_url}themes/mytheme/assets/img/about-home.webp"
            alt=""
            class="home-about__img img-fluid rounded"
            loading="lazy"
            decoding="async"
            width="780"
            height="585"
          >
        </div>
      </div>

    </div>
  </div>
</section>


{* ══════════════════════════════════════════════════════════════════════════
   5. FAQ — Часто задаваемые вопросы
   ──────────────────────────────────────────────────────────────────────────
   Данные: статичный assign, Вариант A (PROJECT.md §schema-faq.tpl).
   UI:     Bootstrap аккордеон, без кастомного JS.
   Schema: JSON-LD FAQPage — inline перед аккордеоном.
           Google принимает <script type="application/ld+json"> в <body>.

   ⚠️ Строки в $faq_items намеренно не обёрнуты в {l} — Smarty не позволяет
      вызывать функции как значения в {assign value=[...]}. Для многоязычных
      магазинов вынесите FAQ в кастомный модуль (Вариант B из PROJECT.md).

   Порядок модификаторов в schema-faq.tpl соответствует правилу проекта:
     strip_tags → trim → truncate → escape:'javascript'
   ══════════════════════════════════════════════════════════════════════════ *}

{assign var='faq_items' value=[
  [
    'question' => 'Як оформити замовлення?',
    'answer'   => 'Додайте товари до кошика, перейдіть до оформлення замовлення та заповніть контактні дані. Ми підтвердимо замовлення протягом 1 робочого дня.'
  ],
  [
    'question' => 'Які способи оплати доступні?',
    'answer'   => 'Приймаємо оплату карткою (Visa, Mastercard), банківським переказом та готівкою при отриманні. Усі онлайн-платежі захищені SSL-шифруванням.'
  ],
  [
    'question' => 'Скільки часу займає доставка?',
    'answer'   => 'Стандартна доставка — 2–5 робочих днів. Експрес-доставка (1–2 дні) доступна при оформленні замовлення. Ми відправляємо замовлення щодня крім неділі.'
  ],
  [
    'question' => 'Як повернути товар?',
    'answer'   => 'Протягом 14 днів з моменту отримання ви можете повернути будь-який товар у незайманому стані. Повернення безкоштовне. Зверніться до служби підтримки для оформлення.'
  ],
  [
    'question' => 'Як відстежити статус замовлення?',
    'answer'   => 'Після відправлення ви отримаєте email з трек-номером. Також статус можна перевірити в особистому кабінеті у розділі «Мої замовлення».'
  ],
  [
    'question' => 'Чи надається гарантія на товари?',
    'answer'   => 'Усі товари мають гарантію виробника. Терміни залежать від категорії товару та вказані на сторінці кожного товару. За гарантійними питаннями звертайтеся до підтримки.'
  ]
]}

{* JSON-LD FAQPage schema — передаємо $faq_items у вже готовий partial *}
{include file='_partials/microdata/schema-faq.tpl'}

<section class="home-faq" aria-labelledby="home-faq-heading">
  <div class="container">

    <div class="home-faq__header text-center">
      <h2 id="home-faq-heading" class="home-faq__title">
        {l s='Frequently Asked Questions' d='Shop.Theme.Global'}
      </h2>
      <p class="home-faq__subtitle">
        {l s='Quick answers to the most common questions' d='Shop.Theme.Global'}
      </p>
    </div>

    <div class="row justify-content-center">
      <div class="col-12 col-lg-8 col-xl-7">

        <div class="accordion home-faq__accordion" id="homeFaqAccordion">

          {foreach from=$faq_items item='faq' key='i'}

            {* Уникальный ID для каждого элемента аккордеона *}
            {assign var='faq_collapse_id' value="home-faq-collapse-`$i`"}
            {assign var='faq_heading_id'  value="home-faq-heading-`$i`"}

            <div class="accordion-item home-faq__item">

              {* h3 внутри section с h2 — корректная иерархия заголовков *}
              <h3 class="accordion-header home-faq__question-header" id="{$faq_heading_id}">
                <button
                  class="accordion-button home-faq__question-btn{if $i > 0} collapsed{/if}"
                  type="button"
                  data-bs-toggle="collapse"
                  data-bs-target="#{$faq_collapse_id}"
                  aria-expanded="{if $i === 0}true{else}false{/if}"
                  aria-controls="{$faq_collapse_id}"
                >
                  {$faq.question|escape:'html':'UTF-8'}
                </button>
              </h3>

              <div
                id="{$faq_collapse_id}"
                class="accordion-collapse collapse{if $i === 0} show{/if}"
                aria-labelledby="{$faq_heading_id}"
                data-bs-parent="#homeFaqAccordion"
              >
                <div class="accordion-body home-faq__answer">
                  {$faq.answer|escape:'html':'UTF-8'}
                </div>
              </div>

            </div>

          {/foreach}

        </div>
        {* /.accordion *}

      </div>
    </div>
    {* /.row *}

  </div>
</section>

{/block}
{* /.block content *}
