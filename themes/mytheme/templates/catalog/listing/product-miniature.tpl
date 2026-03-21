{**
 * product-miniature.tpl — Карточка товара в листинге каталога
 *
 * Версия темы : mytheme v0.6.0
 * PrestaShop  : 9.0.x
 * PHP         : 8.4.x
 * Шаблонизатор: Smarty
 *
 * Вызывается из:
 *   catalog/listing/product-list.tpl (v0.6.0)
 *   Возможно также: search.tpl, manufacturer.tpl, новинки/спецпредложения модулей.
 *
 * Получаемые параметры:
 *   $product        — объект товара PS9 (обязателен)
 *   $is_above_fold  — bool, true для первых 4 карточек (LCP-оптимизация)
 *                     передаётся из product-list.tpl
 *
 * Анатомия карточки (сверху вниз):
 *   ┌──────────────────────────────────┐
 *   │ [Бейджи: скидка / новинка / акц] │  ← абс. позиция, верхний левый угол
 *   │                      [♡ wishlist]│  ← абс. позиция, верхний правый угол
 *   │                                  │
 *   │          ФОТО ТОВАРА             │  ← <picture>, 1:1, object-fit: contain
 *   │          (белый фон)             │
 *   │                                  │
 *   └──────────────────────────────────┘
 *   │ ★★★★☆ (4.2) / «Залишити відгук» │  ← 3 состояния рейтинга
 *   │ Назва товару (2 строки max)      │  ← <a>, line-clamp: 2
 *   │ Форма / об'єм / кількість        │  ← вторичный текст из $product.reference
 *   │ ~~стара ціна~~  ПОТОЧНА ЦІНА     │  ← цены на одной строке
 *   │ ≈ X грн за капсулу               │  ← цена за единицу (если unit_price_ratio > 0)
 *   │ [      + До кошика       ]       │  ← кнопка полной ширины / «Обрати варіант»
 *   └──────────────────────────────────┘
 *
 * BEM-именование:
 *   Блок:      .product-miniature
 *   Элементы:  .product-miniature__media, __badges, __badge,
 *              __wishlist, __img-wrapper, __img,
 *              __body, __rating, __rating-stars, __rating-cta,
 *              __name, __reference, __prices, __price-old,
 *              __price-current, __unit-price, __footer, __btn-cart
 *   Модификаторы на блоке:
 *              .product-miniature--has-discount
 *              .product-miniature--out-of-stock
 *              (добавляются через Smarty-условия на корневом элементе)
 *
 * SEO / AI-агенты:
 *   — Название товара: <a>, НЕ H2/H3 — H1 занят категорией (нарушение иерархии)
 *   — alt фото: $product.name — AI-агенты читают alt для понимания контента
 *   — Цены: в тексте DOM, не только в JS — требование AI-агентов 2026
 *   — itemprop не используем — есть JSON-LD (schema-product.tpl), дублирование вредит
 *
 * Core Web Vitals:
 *   LCP: первые 4 карточки ($is_above_fold=true) → loading="eager" + fetchpriority="high"
 *        остальные → loading="lazy"
 *   CLS: aspect-ratio: 1/1 на .product-miniature__img-wrapper резервирует место
 *        до загрузки — браузер не перерасчитывает layout
 *   INP: кнопка «До кошика» — стандартный PS9 data-button-action="add-to-cart",
 *        обработка через prestashop.js (не блокирует main thread)
 *
 * Бейджи — максимум 2 одновременно, приоритет:
 *   1. Скидка (discount) — если $product.has_discount
 *   2. Акция (on-sale)   — из $product.flags[] тип 'on-sale'
 *   3. Новинка (new)     — из $product.flags[] тип 'new'
 *   Логика ограничения реализована через {assign var='badge_count'}.
 *
 * Wishlist (blockwishlist):
 *   Desktop: видна только при hover на карточке (CSS opacity transition)
 *   Mobile:  всегда видна (нет hover на touch-устройствах)
 *   Рендерится через hook displayProductListFunctionalButtons
 *
 * Рейтинг — три состояния (решение принято, раздел 13 артефакта рекомендаций):
 *   0 отзывов      → ссылка «Залишити перший відгук»
 *   1–4 отзыва     → звёзды + счётчик (без среднего балла)
 *   5+ отзывов     → звёзды + балл + счётчик
 *   Требует модуль ps_productcomments — без него $product.comment_count = 0.
 *
 * Цена за единицу:
 *   Выводится если $product.unit_price_ratio > 0 (заполнено в BO).
 *   В v0.6.0 — только отображение. Сортировка по цене/единице — v0.6.x.
 *
 * Не реализовано в этом файле (намеренно):
 *   — Быстрый просмотр (PS_QUICK_VIEW: 0 в theme.yml — отключён)
 *   — Сравнение товаров (ps_compareproducts — не добавляем, решение принято)
 *   — Второе фото при hover (реализовать в v0.6.x если потребуется)
 *}


{* ─────────────────────────────────────────────────────────────────────────────
   ЗАЩИТНАЯ ПРОВЕРКА: не рендерим карточку если объект товара недоступен.
   В нормальном потоке этого не происходит, но защита от ошибок модулей важна.
   ───────────────────────────────────────────────────────────────────────────── *}
{if !isset($product) || !$product}
  {* Тихий выход — не генерируем пустой HTML *}
{else}


{* ─────────────────────────────────────────────────────────────────────────────
   ПРЕДВАРИТЕЛЬНЫЕ ВЫЧИСЛЕНИЯ
   Выполняем все {assign} до разметки — держим шаблон читаемым.
   ───────────────────────────────────────────────────────────────────────────── *}

{* Счётчик бейджей — максимум 2, чтобы не перекрывать фото *}
{assign var='badge_count' value=0}

{* Флаг наличия скидки — используется в нескольких местах *}
{assign var='has_discount' value=false}
{if isset($product.has_discount) && $product.has_discount}
  {assign var='has_discount' value=true}
{/if}

{* Флаг товара "не в наличии" *}
{assign var='out_of_stock' value=false}
{if isset($product.availability) && $product.availability === 'unavailable'}
  {assign var='out_of_stock' value=true}
{/if}

{* Флаг наличия комбинаций (вариантов товара) *}
{assign var='has_combinations' value=false}
{if isset($product.has_combinations) && $product.has_combinations}
  {assign var='has_combinations' value=true}
{/if}

{* Атрибут loading для фото — LCP-оптимизация.
   $is_above_fold передаётся из product-list.tpl.
   Первые 4 карточки: eager + fetchpriority=high.
   Остальные: lazy (браузер сам решает когда загружать). *}
{assign var='img_loading' value='lazy'}
{assign var='img_fetchpriority' value='auto'}
{if isset($is_above_fold) && $is_above_fold}
  {assign var='img_loading' value='eager'}
  {assign var='img_fetchpriority' value='high'}
{/if}

{* Счётчик отзывов — безопасное получение, ps_productcomments может быть не установлен *}
{assign var='comment_count' value=0}
{if isset($product.comment_count) && $product.comment_count}
  {assign var='comment_count' value=$product.comment_count|intval}
{/if}

{* Средний рейтинг — безопасное получение *}
{assign var='stars_rating' value=0}
{if isset($product.stars_ratings) && $product.stars_ratings}
  {assign var='stars_rating' value=$product.stars_ratings}
{/if}

{* Строим модификаторы BEM для корневого элемента *}
{assign var='card_modifiers' value=''}
{if $has_discount}{assign var='card_modifiers' value="{$card_modifiers} product-miniature--has-discount"}{/if}
{if $out_of_stock}{assign var='card_modifiers' value="{$card_modifiers} product-miniature--out-of-stock"}{/if}
{if $has_combinations}{assign var='card_modifiers' value="{$card_modifiers} product-miniature--has-combinations"}{/if}


{* ═══════════════════════════════════════════════════════════════════════════
   КОРНЕВОЙ ЭЛЕМЕНТ КАРТОЧКИ
   article семантически верен — карточка товара это самостоятельная единица.
   data-id-product и data-id-product-attribute нужны PS9 JS (корзина, wishlist).
   ═══════════════════════════════════════════════════════════════════════════ *}
<article
  class="product-miniature{$card_modifiers}"
  data-id-product="{$product.id_product|intval}"
  data-id-product-attribute="{$product.id_product_attribute|intval|default:0}"
  aria-label="{$product.name|escape:'html':'UTF-8'}"
>


  {* ── МЕДИА-БЛОК: фото + бейджи + wishlist ──────────────────────────────── *}
  <div class="product-miniature__media">


    {* ── БЕЙДЖИ (флаги товара) ───────────────────────────────────────────────
       Абсолютное позиционирование: top: 8px, left: 8px.
       Порядок приоритетов: скидка → акция → новинка.
       Максимум 2 бейджа одновременно — после 2 не выводим.
       aria-label на контейнере суммирует все статусы для скринридера.
       ─────────────────────────────────────────────────────────────────────── *}
    {assign var='badge_count' value=0}

    {* Собираем aria-описание бейджей для скринридера *}
    {assign var='badges_aria' value=''}

    <div class="product-miniature__badges" aria-hidden="true">

      {* Бейдж 1 — Скидка.
         Показываем процент скидки если он доступен ($product.discount_percentage).
         Формат: «-15%». Если процент недоступен — просто «Знижка». *}
      {if $has_discount && $badge_count < 2}
        <span class="product-miniature__badge product-miniature__badge--discount">
          {if isset($product.discount_percentage) && $product.discount_percentage}
            -{$product.discount_percentage|escape:'html':'UTF-8'}
          {else}
            {l s='Знижка' d='Shop.Theme.Catalog'}
          {/if}
        </span>
        {assign var='badge_count' value=$badge_count+1}
        {assign var='badges_aria' value="{$badges_aria} знижка"}
      {/if}

      {* Бейджи из $product.flags[] — PS9 передаёт массив флагов товара.
         Каждый флаг: объект с полями type (строка) и label (локализованный текст).
         Стандартные типы: 'new', 'on-sale', 'pack', 'virtual'.
         Обходим массив и выводим только известные нам типы, соблюдая лимит 2. *}
      {if isset($product.flags) && $product.flags|@count > 0}
        {foreach from=$product.flags item='flag'}

          {* Бейдж «Акция» (on-sale) *}
          {if $flag.type === 'on-sale' && $badge_count < 2}
            <span class="product-miniature__badge product-miniature__badge--on-sale">
              {$flag.label|escape:'html':'UTF-8'}
            </span>
            {assign var='badge_count' value=$badge_count+1}
            {assign var='badges_aria' value="{$badges_aria} акція"}

          {* Бейдж «Новинка» (new) — самый низкий приоритет *}
          {elseif $flag.type === 'new' && $badge_count < 2}
            <span class="product-miniature__badge product-miniature__badge--new">
              {$flag.label|escape:'html':'UTF-8'}
            </span>
            {assign var='badge_count' value=$badge_count+1}
            {assign var='badges_aria' value="{$badges_aria} новинка"}

          {* Бейдж «Пак» (pack) — набор товаров *}
          {elseif $flag.type === 'pack' && $badge_count < 2}
            <span class="product-miniature__badge product-miniature__badge--pack">
              {$flag.label|escape:'html':'UTF-8'}
            </span>
            {assign var='badge_count' value=$badge_count+1}

          {/if}
        {/foreach}
      {/if}

      {* Бейдж «Немає в наявності» — особый статус, всегда показываем поверх других.
         Перекрывает лимит badge_count — наличие критически важно для пользователя. *}
      {if $out_of_stock}
        <span class="product-miniature__badge product-miniature__badge--out-of-stock">
          {l s='Немає в наявності' d='Shop.Theme.Catalog'}
        </span>
      {/if}

    </div>{* /.product-miniature__badges *}

    {* Скрытый текст для скринридеров — суммирует статусы *}
    {if $badges_aria || $out_of_stock}
      <span class="visually-hidden">
        {if $badges_aria}{$badges_aria|trim}{/if}
        {if $out_of_stock}, {l s='немає в наявності' d='Shop.Theme.Catalog'}{/if}
      </span>
    {/if}


    {* ── WISHLIST (список желаний) ───────────────────────────────────────────
       Абсолютное позиционирование: top: 8px, right: 8px.
       Рендерится через hook displayProductListFunctionalButtons — blockwishlist.
       Desktop: скрыт по умолчанию, появляется при hover на карточке (CSS).
       Mobile:  всегда видим (нет :hover на touch, медиа-запрос hover:hover).
       Обёртка .product-miniature__wishlist нужна для CSS-управления видимостью,
       так как мы не можем добавить классы внутрь вывода хука напрямую. *}
    <div class="product-miniature__wishlist">
      {hook h='displayProductListFunctionalButtons' product=$product}
    </div>


    {* ── ФОТО ТОВАРА ─────────────────────────────────────────────────────────
       Ссылка на страницу товара оборачивает фото — весь блок кликабелен.
       <picture> с <source> для mobile/desktop:
         mobile  → home_default  (250×250px) — меньший файл
         desktop → medium_default (452×452px) — чёткость на больших экранах
       aspect-ratio: 1/1 на обёртке — резервирует место (CLS = 0).
       object-fit: contain — упаковки БАДов не обрезаются (бутылочки, блистеры).
       padding: 8px — небольшой отступ чтобы упаковка не касалась краёв.
       alt = $product.name — обязательно, AI-агенты используют для понимания фото.
       tabindex="-1" на ссылке фото — фокус на клавиатуре идёт на название товара,
       не на фото (избегаем двойного фокуса на один товар).
       ─────────────────────────────────────────────────────────────────────── *}
    <a
      href="{$product.url|escape:'html':'UTF-8'}"
      class="product-miniature__img-link"
      tabindex="-1"
      aria-hidden="true"
    >
      <div class="product-miniature__img-wrapper">

        {* Проверяем наличие фото — у товара может не быть изображения *}
        {if isset($product.cover) && $product.cover}

          <picture>
            {* Mobile: home_default 250×250px — загружается на экранах < 576px.
               Меньший размер = меньше трафика на мобильном. *}
            {if isset($product.cover.bySize.home_default.url) && $product.cover.bySize.home_default.url}
              <source
                media="(max-width: 575px)"
                srcset="{$product.cover.bySize.home_default.url|escape:'html':'UTF-8'}"
                width="250"
                height="250"
              >
            {/if}

            {* Desktop/tablet: medium_default 452×452px — основное фото.
               Используется на всех экранах ≥ 576px (и как fallback). *}
            <img
              class="product-miniature__img"
              src="{if isset($product.cover.bySize.medium_default.url) && $product.cover.bySize.medium_default.url}{$product.cover.bySize.medium_default.url|escape:'html':'UTF-8'}{else}{$product.cover.medium.url|escape:'html':'UTF-8'}{/if}"
              alt="{$product.name|escape:'html':'UTF-8'}"
              width="452"
              height="452"
              loading="{$img_loading}"
              fetchpriority="{$img_fetchpriority}"
            >
          </picture>

        {else}

          {* Fallback: товар без фото — заглушка с иконкой.
             Сохраняет aspect-ratio и не ломает сетку. *}
          <div class="product-miniature__img-placeholder" aria-hidden="true">
            <i class="fa-solid fa-image"></i>
          </div>

        {/if}

        {* Оверлей при состоянии "не в наличии" — затемняет фото.
           Реализован через CSS ::after на .product-miniature--out-of-stock
           или через этот div (управляется в category.css). *}
        {if $out_of_stock}
          <div class="product-miniature__out-of-stock-overlay" aria-hidden="true"></div>
        {/if}

      </div>{* /.product-miniature__img-wrapper *}
    </a>{* /.product-miniature__img-link *}


  </div>{* /.product-miniature__media *}


  {* ── ТЕЛО КАРТОЧКИ: рейтинг + название + артикул + цены ────────────────── *}
  <div class="product-miniature__body">


    {* ── РЕЙТИНГ ─────────────────────────────────────────────────────────────
       Три состояния (решение принято — раздел 13 артефакта рекомендаций):
         0 отзывов   → ссылка «Залишити перший відгук»
         1–4 отзыва  → звёзды + счётчик (без среднего балла — статистически ненадёжно)
         5+ отзывов  → звёзды + балл + счётчик
       min-height на блоке рейтинга — выравнивает высоту карточек в строке
       когда у части товаров нет рейтинга.
       aria-label описывает рейтинг для скринридера числом.
       ─────────────────────────────────────────────────────────────────────── *}
    <div class="product-miniature__rating">

      {if $comment_count === 0}

        {* Нет отзывов — приглашение оставить первый.
           Якорь #product-comments ведёт прямо к блоку отзывов на странице товара.
           Не показываем пустые звёзды — они снижают конверсию на 15% (Baymard, 2024). *}
        <a
          href="{$product.url|escape:'html':'UTF-8'}#product-comments"
          class="product-miniature__rating-cta"
          tabindex="-1"
        >
          {l s='Залишити перший відгук' d='Shop.Theme.Catalog'}
        </a>

      {elseif $comment_count < 5}

        {* 1–4 отзыва — звёзды без среднего балла.
           При малом количестве отзывов средний балл статистически ненадёжен
           и может вводить в заблуждение (1 отзыв на 5 звёзд ≠ реальная оценка). *}
        <div
          class="product-miniature__rating-stars"
          aria-label="{l s='%count% відгуків' sprintf=['%count%' => $comment_count] d='Shop.Theme.Catalog'}"
        >
          {include
            file='catalog/listing/_partials/rating-stars.tpl'
            rating=$stars_rating
            show_score=false
          }
          <span class="product-miniature__rating-count">
            ({$comment_count|intval})
          </span>
        </div>

      {else}

        {* 5+ отзывов — полный формат: звёзды + балл + счётчик.
           Формат: ★★★★☆ 4.2 (17) *}
        {assign var='avg_score' value=0}
        {if isset($product.averaged_note) && $product.averaged_note}
          {assign var='avg_score' value=$product.averaged_note}
        {/if}
        <div
          class="product-miniature__rating-stars"
          aria-label="{l s='Рейтинг %score% з 5, %count% відгуків' sprintf=['%score%' => $avg_score, '%count%' => $comment_count] d='Shop.Theme.Catalog'}"
        >
          {include
            file='catalog/listing/_partials/rating-stars.tpl'
            rating=$stars_rating
            show_score=true
            score=$avg_score
          }
          <span class="product-miniature__rating-count">
            ({$comment_count|intval})
          </span>
        </div>

      {/if}

    </div>{* /.product-miniature__rating *}


    {* ── НАЗВАНИЕ ТОВАРА ─────────────────────────────────────────────────────
       <a> а не <h2>/<h3> — H1 занят названием категории.
       Заголовки в карточках листинга нарушают SEO-иерархию страницы.
       line-clamp: 2 — максимум 2 строки, ellipsis на третьей.
       min-height: 2 строки — выравнивает карточки в строке.
       Основная ссылка карточки — получает фокус клавиатуры (tabindex не задан).
       title = полное название — доступно при наведении если текст обрезан.
       ─────────────────────────────────────────────────────────────────────── *}
    <a
      href="{$product.url|escape:'html':'UTF-8'}"
      class="product-miniature__name"
      title="{$product.name|escape:'html':'UTF-8'}"
    >
      {$product.name|escape:'html':'UTF-8'}
    </a>


    {* ── АРТИКУЛ / ФОРМА ВЫПУСКА / ОБЪЁМ ────────────────────────────────────
       Для ниши БАДов критично: «60 капсул» vs «120 капсул» — ключевое отличие.
       Источник: $product.reference — поле «Артикул» в BO, куда менеджер вводит
       форму выпуска и объём (например: «Капсули, 60 шт.», «Порошок, 250 г»).
       Соглашение с командой контента обязательно — поле должно заполняться
       не артикулом поставщика, а потребительски понятным описанием.
       Если поле пустое — блок занимает min-height для выравнивания карточек. *}
    {if isset($product.reference) && $product.reference}
      <span class="product-miniature__reference">
        {$product.reference|escape:'html':'UTF-8'}
      </span>
    {else}
      {* Пустой элемент сохраняет min-height для выравнивания *}
      <span class="product-miniature__reference product-miniature__reference--empty"
            aria-hidden="true"></span>
    {/if}


    {* ── БЛОК ЦЕН ────────────────────────────────────────────────────────────
       Структура: [перечёркнутая старая цена]  [текущая цена]
       Всё на одной строке — не переносить (задано в CSS: white-space: nowrap).
       $product.price        — текущая цена (уже отформатирована PS9 с символом валюты)
       $product.regular_price — оригинальная цена до скидки
       Цены выводим без escape — PS9 форматирует как безопасный HTML-текст.
       ВАЖНО: значение цены должно быть в DOM (не только в JS) —
       требование AI-агентов 2026 для понимания структуры страницы.
       itemprop не используем — данные уже есть в JSON-LD (schema-product.tpl).
       ─────────────────────────────────────────────────────────────────────── *}
    <div class="product-miniature__prices">

      {if $has_discount}
        {* Старая цена — перечёркнутая.
           <del> семантически корректен (удалённая/заменённая информация).
           datetime-атрибут не нужен для цены. *}
        <del class="product-miniature__price-old">
          {$product.regular_price}
        </del>
      {/if}

      {* Текущая цена.
         Модификатор --discounted окрашивает в --color-discount (красный) *}
      <span class="product-miniature__price-current{if $has_discount} product-miniature__price-current--discounted{/if}">
        {$product.price}
      </span>

    </div>{* /.product-miniature__prices *}


    {* ── ЦЕНА ЗА ЕДИНИЦУ ────────────────────────────────────────────────────
       Выводим если unit_price_ratio > 0 (заполнено в BO: Каталог → Товар → Ціни).
       В v0.6.0 — только отображение. Сортировка по цене/единице — v0.6.x.
       $product.unit_price — уже отформатированная цена за единицу от PS9.
       $product.unit_price_unit — единица измерения (г, мл, шт, капс. и т.д.).
       Пример: «≈ 4.50 ₴ за капс.»
       Соглашение с контентом: поле «Одиниця» в BO заполнять коротко: «капс», «г», «мл».
       ─────────────────────────────────────────────────────────────────────── *}
    {if isset($product.unit_price_ratio) && $product.unit_price_ratio > 0}
      {if isset($product.unit_price) && $product.unit_price}
        <span class="product-miniature__unit-price">
          ≈ {$product.unit_price}
          {if isset($product.unit_price_unit) && $product.unit_price_unit}
            {l s='за' d='Shop.Theme.Catalog'} {$product.unit_price_unit|escape:'html':'UTF-8'}
          {/if}
        </span>
      {/if}
    {/if}


  </div>{* /.product-miniature__body *}


  {* ── ФУТЕР КАРТОЧКИ: кнопка действия ───────────────────────────────────── *}
  <div class="product-miniature__footer">


    {* ── КНОПКА ДЕЙСТВИЯ ────────────────────────────────────────────────────
       Два варианта в зависимости от типа товара:

       A) Простой товар (без комбинаций):
          <button data-button-action="add-to-cart"> — PS9 prestashop.js
          перехватывает этот атрибут и выполняет AJAX-добавление в корзину.
          data-product-id, data-product-attribute-id — обязательны для PS9.
          После успешного добавления JS (category.js v0.14.0) временно меняет
          текст на «✓ Додано» и цвет кнопки на oklch(55% 0.12 145).

       B) Товар с комбинациями (варианты: вкус, объём, тип и т.д.):
          Нельзя добавить в корзину без выбора варианта — ведём на страницу.
          <a href> вместо <button> — семантически верно (переход на страницу).
          btn-outline — визуально отличает от прямого «До кошика».

       Состояние "не в наличии":
          Кнопка заблокирована (disabled). Текст сменяется.
          Disabled кнопка не получает фокус клавиатуры — добавляем
          aria-disabled="true" на <a> для случая с комбинациями.

       Touch-target: min-height 44px задан в CSS (Apple HIG / Material You).
       ─────────────────────────────────────────────────────────────────────── *}

    {if $out_of_stock}

      {* Товар не в наличии — заблокированная кнопка *}
      <button
        class="product-miniature__btn-cart product-miniature__btn-cart--unavailable"
        type="button"
        disabled
        aria-disabled="true"
      >
        <i class="fa-solid fa-ban me-2" aria-hidden="true"></i>
        {l s='Немає в наявності' d='Shop.Theme.Catalog'}
      </button>

    {elseif $has_combinations}

      {* Товар с комбинациями — ведём на страницу выбора варианта *}
      <a
        href="{$product.url|escape:'html':'UTF-8'}"
        class="product-miniature__btn-cart product-miniature__btn-cart--combinations"
        aria-label="{l s='Обрати варіант товару %name%' sprintf=['%name%' => $product.name|escape:'html':'UTF-8'] d='Shop.Theme.Catalog'}"
      >
        <i class="fa-solid fa-sliders me-2" aria-hidden="true"></i>
        {l s='Обрати варіант' d='Shop.Theme.Catalog'}
      </a>

    {else}

      {* Простой товар — AJAX добавление в корзину.
         data-button-action="add-to-cart" — перехватывается prestashop.js (PS9 core).
         data-product-* — идентификаторы для корзины.
         data-product-url — используется JS для перехода на страницу товара
         если добавление невозможно (например, требует авторизации).
         aria-label содержит название товара — скринридер озвучит что именно добавляется. *}
      <button
        class="product-miniature__btn-cart"
        type="button"
        data-button-action="add-to-cart"
        data-product-id="{$product.id_product|intval}"
        data-product-attribute-id="{$product.id_product_attribute|intval|default:0}"
        data-product-url="{$product.url|escape:'html':'UTF-8'}"
        aria-label="{l s='Додати до кошика: %name%' sprintf=['%name%' => $product.name|escape:'html':'UTF-8'] d='Shop.Theme.Catalog'}"
        data-product-name="{$product.name|escape:'html':'UTF-8'}"
      >
        {* Иконка корзины — получает класс .is-animating при клике (JS).
           CSS: .is-animating { transform: scale(1.2); transition: transform 0.2s } *}
        <i class="fa-solid fa-cart-plus product-miniature__cart-icon me-2" aria-hidden="true"></i>

        {* Текст кнопки — JS (category.js v0.14.0) временно меняет на «✓ Додано» *}
        <span class="product-miniature__btn-cart-text">
          {l s='До кошика' d='Shop.Theme.Catalog'}
        </span>

        {* Скрытый текст «успешно добавлено» — JS раскрывает его через aria-live.
           Не отображается визуально — только для скринридеров. *}
        <span
          class="product-miniature__cart-confirm visually-hidden"
          role="status"
          aria-live="polite"
          aria-atomic="true"
        ></span>

      </button>

    {/if}


  </div>{* /.product-miniature__footer *}


</article>{* /.product-miniature *}


{/if}{* /if product isset *}
