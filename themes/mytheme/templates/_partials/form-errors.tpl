{**
 * templates/_partials/form-errors.tpl
 * v0.5.2 — Ошибки валидации форм
 *
 * Назначение:
 *   Унифицированный вывод ошибок валидации для всех форм темы:
 *   оформление заказа, регистрация, вход, контакты, адрес, смена пароля.
 *
 * Использование — два режима:
 *
 *   Режим 1 — массив ошибок через переменную $errors:
 *     {include file='_partials/form-errors.tpl' errors=$form.errors}
 *     {include file='_partials/form-errors.tpl' errors=$address_form.errors}
 *
 *   Режим 2 — ошибки конкретного поля через переменную $field:
 *     {include file='_partials/form-errors.tpl' field=$form_field}
 *     Ожидает: $field.errors — массив строк ошибок поля.
 *
 * Структура входных данных:
 *
 *   $errors — плоский массив строк:
 *     ['Поле email обязательно', 'Пароль слишком короткий']
 *
 *   $errors — массив с вложенными массивами (checkout, address form):
 *     [
 *       'firstname' => ['Имя обязательно'],
 *       'email'     => ['Некорректный email', 'Email уже занят']
 *     ]
 *
 *   $field.errors — массив строк ошибок одного поля (inline под input):
 *     ['Некорректный формат телефона']
 *
 * Поведение:
 *   — Если ни $errors ни $field не переданы — ничего не рендерится.
 *   — Плоский массив и вложенный определяются автоматически.
 *   — Режим поля ($field) выводит ошибки без alert-обёртки —
 *     маленький inline-блок под input (класс .invalid-feedback Bootstrap).
 *   — Режим массива ($errors) выводит сводный alert-блок над формой.
 *   — role="alert" + aria-live="assertive" — screen reader озвучивает сразу.
 *   — id="form-errors-summary" + tabindex="-1" — JS может сделать focus()
 *     на блок после submit (реализовать в pages/checkout.js в 0.14.0).
 *
 * Подключение в шаблоне формы:
 *
 *   {* Сводный блок над формой *}
* {if isset($errors) && $errors|@count > 0}
  * {include file='_partials/form-errors.tpl' errors=$errors}
* {/if}
*
* {* Inline под конкретным полем *}
* {if isset($field.errors) && $field.errors|@count > 0}
  * {include file='_partials/form-errors.tpl' field=$field}
* {/if}
*}


{* ══════════════════════════════════════════════════════════════════════════
   РЕЖИМ 2 — Inline ошибки поля (под <input>)
   Выводится без alert-обёртки, Bootstrap .invalid-feedback
   ══════════════════════════════════════════════════════════════════════════ *}
{if isset($field) && isset($field.errors) && $field.errors|@count > 0}

  <div class="invalid-feedback form-errors form-errors--field d-block" role="alert" aria-live="assertive">
    {foreach from=$field.errors item='error_msg'}
      <span class="form-errors__message">
        <i class="fas fa-circle-exclamation form-errors__icon" aria-hidden="true"></i>
        {$error_msg|escape:'html':'UTF-8'}
      </span>
    {/foreach}
  </div>


  {* ══════════════════════════════════════════════════════════════════════════
   РЕЖИМ 1 — Сводный блок ошибок над формой
   ══════════════════════════════════════════════════════════════════════════ *}
{elseif isset($errors) && $errors|@count > 0}

  <div id="form-errors-summary" class="alert alert-danger form-errors form-errors--summary" role="alert"
    aria-live="assertive" tabindex="-1">
    <div class="form-errors__header d-flex align-items-center gap-2 mb-2">
      <i class="fas fa-triangle-exclamation form-errors__header-icon" aria-hidden="true"></i>
      <strong class="form-errors__title">
        {l s='Please fix the following errors:' d='Shop.Theme.Global'}
      </strong>
    </div>

    <ul class="form-errors__list list-unstyled mb-0">
      {foreach from=$errors item='error_item'}

        {if is_array($error_item)}
          {* Вложенный массив: ошибки одного поля → несколько строк *}
          {foreach from=$error_item item='error_msg'}
            <li class="form-errors__item">
              <i class="fas fa-minus form-errors__bullet" aria-hidden="true"></i>
              {$error_msg|escape:'html':'UTF-8'}
            </li>
          {/foreach}

        {else}
          {* Плоская строка ошибки *}
          <li class="form-errors__item">
            <i class="fas fa-minus form-errors__bullet" aria-hidden="true"></i>
            {$error_item|escape:'html':'UTF-8'}
          </li>

        {/if}

      {/foreach}
    </ul>

  </div>

{/if}