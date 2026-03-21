{**
 * product-variants.tpl — Выбор вариантов товара (кнопки-пилюли)
 *
 * Версия темы : mytheme v0.7.0
 * PrestaShop  : 9.0.x
 * PHP         : 8.4.x
 * Шаблонизатор: Smarty
 *
 * Вызывается из:
 *   catalog/product.tpl (v0.7.0) — покупательская панель (правая колонка)
 *
 * Получаемые параметры (из product.tpl, переменная $product):
 *   $product.groups[]  — массив атрибутных групп
 *     Каждая группа:
 *       .id                 — ID группы атрибутов
 *       .name               — название группы (Кількість, Форма, Концентрація)
 *       .group_type         — тип (select, radio, color)
 *       .attributes[]       — массив атрибутов внутри группы
 *         Каждый атрибут:
 *           .id             — ID атрибута
 *           .name           — название (60 капсул, 120 капсул)
 *           .selected (bool) — выбран ли
 *           .url            — URL для AJAX-обновления
 *           .html_color_code — цвет (для типа color)
 *
 * Визуальное решение (секция 5 рекомендаций):
 *   Кнопки-пилюли для ВСЕХ типов вариантов G&G.
 *   Вместо select/dropdown — все варианты видны одновременно.
 *   Для 2–6 вариантов (типично: 60/120/240 шт) — оптимальный UX.
 *   Dropdown рекомендован только если вариантов > 8 (не типично для G&G).
 *
 * Поведение:
 *   Активный:     background var(--color-primary), color #fff
 *   Hover:        border-color var(--color-primary-light)
 *   Недоступный:  opacity 0.45, cursor not-allowed, диагональная линия
 *   При выборе: PS9 AJAX обновляет цену, фото, наличие, URL
 *
 * a11y:
 *   role="radiogroup" на группе
 *   <input type="radio"> внутри <label> — нативная семантика
 *   aria-label на группе описывает контекст
 *
 * JS (product.js v0.14.0):
 *   prestashop.on('updateProduct', ...) — стандартный механизм PS9
 *   При выборе: обновление цены, фото, наличия, кнопки
 *   History API: ?id_product_attribute=N
 *
 * CSS: product.css (v0.14.0)
 *}


{* ═══════════════════════════════════════════════════════════════════════════
   ВАРИАНТЫ ТОВАРА
   Рендерим только если у товара есть группы атрибутов.
   ═══════════════════════════════════════════════════════════════════════════ *}
{if isset($product.groups) && $product.groups|@count > 0}

  <div class="product-variants" id="js-product-variants">

    {foreach from=$product.groups key='id_attribute_group' item='group'}

      <div
        class="product-variants__group"
        data-attribute-group-id="{$id_attribute_group|intval}"
      >

        {* ── Лейбл группы: «Кількість: 60 капсул» ──────────────────────── *}
        <span class="product-variants__label" id="variant-label-{$id_attribute_group|intval}">
          {$group.name|escape:'html':'UTF-8'}:
          <strong class="product-variants__selected-value" data-selected-value>
            {foreach from=$group.attributes key='id_attribute' item='attribute'}
              {if $attribute.selected}{$attribute.name|escape:'html':'UTF-8'}{/if}
            {/foreach}
          </strong>
        </span>

        {* ── Кнопки-пилюли ───────────────────────────────────────────────
           role="radiogroup": группа радио-кнопок для a11y.
           aria-labelledby ссылается на лейбл группы.
           ─────────────────────────────────────────────────────────────── *}
        <div
          class="product-variants__options"
          role="radiogroup"
          aria-labelledby="variant-label-{$id_attribute_group|intval}"
        >

          {foreach from=$group.attributes key='id_attribute' item='attribute'}

            {* Определяем доступность варианта.
               PS9 передаёт $attribute.add_to_cart_url — если пустой, вариант недоступен.
               Также проверяем availability если доступно. *}
            {assign var='is_unavailable' value=false}
            {if isset($attribute.add_to_cart_url) && !$attribute.add_to_cart_url}
              {assign var='is_unavailable' value=true}
            {/if}

            <label class="product-variants__pill{if $attribute.selected} product-variants__pill--active{/if}{if $is_unavailable} product-variants__pill--unavailable{/if}">

              <input
                class="product-variants__input visually-hidden"
                type="radio"
                name="group[{$id_attribute_group|intval}]"
                value="{$id_attribute|intval}"
                {if $attribute.selected} checked{/if}
                {if $is_unavailable} disabled{/if}
                data-product-attribute="{$id_attribute|intval}"
                {if isset($attribute.url) && $attribute.url}
                  data-attribute-url="{$attribute.url|escape:'html':'UTF-8'}"
                {/if}
              >

              {* Текст пилюли: цвет + название для типа color *}
              {if $group.group_type === 'color' && isset($attribute.html_color_code) && $attribute.html_color_code}
                <span
                  class="product-variants__pill-color"
                  style="background-color: {$attribute.html_color_code|escape:'html':'UTF-8'}"
                  aria-hidden="true"
                ></span>
              {/if}

              <span class="product-variants__pill-text">
                {$attribute.name|escape:'html':'UTF-8'}
              </span>

            </label>

          {/foreach}

        </div>{* /.product-variants__options *}

      </div>{* /.product-variants__group *}

    {/foreach}

    {* ── Сообщение об ошибке выбора варианта ──────────────────────────────
       Появляется через JS (CSS-класс .has-error на .product-variants).
       Если пользователь кликает «До кошика» не выбрав вариант.
       ─────────────────────────────────────────────────────────────────── *}
    <p
      class="product-variants__error"
      role="alert"
      aria-live="assertive"
      id="js-variant-error"
      hidden
    >
      {l s='Оберіть варіант перед додаванням' d='Shop.Theme.Catalog'}
    </p>

  </div>{* /.product-variants *}

{/if}
