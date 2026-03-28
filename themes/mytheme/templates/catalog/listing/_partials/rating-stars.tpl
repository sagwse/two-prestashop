{**
 * rating-stars.tpl — Переиспользуемый блок звёзд рейтинга
 *
 * Версия темы : mytheme v0.6.0
 * PrestaShop  : 9.0.x
 * Шаблонизатор: Smarty
 *
 * Вызывается из:
 *   catalog/listing/product-miniature.tpl — рейтинг в карточке листинга
 *   catalog/product.tpl (v0.7.0)          — рейтинг на странице товара
 *   Любые другие шаблоны где нужны звёзды.
 *
 * Получаемые параметры:
 *   $rating      — число от 0 до 5, может быть дробным (4.2, 3.7)
 *                  Источник: $product.stars_ratings из PS9 / ps_productcomments
 *   $show_score  — bool, показывать ли числовой балл рядом со звёздами
 *                  true  → «★★★★☆ 4.2»
 *                  false → «★★★★☆» (только звёзды)
 *   $score       — числовой балл для отображения (передаётся отдельно от $rating,
 *                  так как $rating используется для вычисления звёзд,
 *                  а $score — для вывода форматированного числа)
 *                  Источник: $product.averaged_note из ps_productcomments
 *                  Если не передан — вычисляем из $rating округлением до 1 знака.
 *
 * Логика рендеринга звёзд:
 *   5 звёзд, каждая — один из трёх состояний:
 *     полная    → fa-star solid         (index + 1 ≤ floor($rating))
 *     половина  → fa-star-half-stroke   (index == floor($rating) && дробная часть ≥ 0.25)
 *     пустая    → fa-star regular       (остальные)
 *   Порог половины: 0.25 (не 0.5) — визуально честнее при рейтинге 4.3
 *   пользователь видит 4 полных + 1 половина, не 4 полных + 1 пустая.
 *
 * Доступность (a11y):
 *   — Звёзды aria-hidden="true" — чисто декоративные элементы.
 *   — Числовой контекст передаётся через aria-label на контейнере
 *     в вызывающем шаблоне (product-miniature.tpl).
 *   — Этот партиал не добавляет собственного aria-label —
 *     его ставит родительский шаблон, знающий полный контекст
 *     (балл + количество отзывов).
 *
 * Размеры и цвета (заданы в category.css / theme.css):
 *   Звёзды: font-size 12px
 *   Цвет:   var(--color-rating) = oklch(76% 0.18 85) — золотой
 *   Балл:   font-size 0.75rem, color var(--color-text-muted)
 *
 * Модуль ps_productcomments:
 *   Обязателен для корректной работы ($product.stars_ratings, $product.averaged_note).
 *   Без него значения будут 0 — product-miniature.tpl корректно обрабатывает этот случай
 *   через условие на $comment_count (не вызывает этот партиал при 0 отзывах).
 *}


{* ─────────────────────────────────────────────────────────────────────────────
   ВЫЧИСЛЕНИЯ
   Все assign до разметки — шаблон остаётся читаемым.
   ───────────────────────────────────────────────────────────────────────────── *}

{* Нормализация $rating: приводим к числу, ограничиваем диапазон 0–5 *}
{assign var='stars_value' value=0}
{if isset($rating) && $rating}
  {assign var='stars_value' value=$rating|floatval}
  {if $stars_value > 5}{assign var='stars_value' value=5}{/if}
  {if $stars_value < 0}{assign var='stars_value' value=0}{/if}
{/if}

{* Целая часть рейтинга — количество полных звёзд *}
{assign var='stars_full' value=$stars_value|floor}

{* Дробная часть — определяет полузвезду *}
{assign var='stars_fraction' value=0}
{math assign='stars_fraction' equation="x - y" x=$stars_value y=$stars_full}

{* Показывать ли полузвезду: порог 0.25 (честнее чем 0.5) *}
{assign var='show_half' value=false}
{if $stars_fraction >= 0.25}{assign var='show_half' value=true}{/if}

{* Числовой балл для отображения *}
{assign var='display_score' value=''}
{if isset($show_score) && $show_score}
  {if isset($score) && $score}
    {* Передан явно — используем как есть (уже форматирован PS9) *}
    {assign var='display_score' value=$score}
  {else}
    {* Вычисляем из $rating — округляем до 1 знака *}
    {math assign='display_score' equation="round(x, 1)" x=$stars_value}
  {/if}
{/if}


{* ═══════════════════════════════════════════════════════════════════════════
   РАЗМЕТКА ЗВЁЗД
   Все иконки aria-hidden — декоративные элементы, контекст даёт родитель.
   ═══════════════════════════════════════════════════════════════════════════ *}
<span class="rating-stars" aria-hidden="true">

  {* Итерируем 5 позиций: index 0..4 *}
  {section name='star' loop=5}

    {assign var='star_index' value=$smarty.section.star.index}

    {if $star_index < $stars_full}
      {* ── Полная звезда ───────────────────────────────────────────────────
         Условие: позиция строго меньше количества полных звёзд.
         Пример: rating=4.2 → stars_full=4 → позиции 0,1,2,3 = полные. *}
      <i class="fa-solid fa-star rating-stars__star rating-stars__star--full"></i>

    {elseif $star_index == $stars_full && $show_half}
      {* ── Половина звезды ─────────────────────────────────────────────────
         Условие: позиция равна количеству полных И есть дробная часть ≥ 0.25.
         fa-star-half-stroke — FA7 иконка половины звезды (правая половина залита).
         Пример: rating=4.3 → позиция 4 = полузвезда. *}
      <i class="fa-solid fa-star-half-stroke rating-stars__star rating-stars__star--half"></i>

    {else}
      {* ── Пустая звезда ───────────────────────────────────────────────────
         fa-star из fa-regular (контур без заливки).
         Пример: rating=4.2 → позиция 4 = пустая (0.2 < порога 0.25). *}
      <i class="fa-regular fa-star rating-stars__star rating-stars__star--empty"></i>

    {/if}

  {/section}{* /star loop *}

</span>{* /.rating-stars *}


{* ── Числовой балл — выводим только если $show_score=true ─────────────────── *}
{if $display_score !== ''}
  <span class="rating-stars__score">
    {$display_score}
  </span>
{/if}