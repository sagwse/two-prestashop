{**
 * templates/_partials/notifications.tpl
 * v0.5.1 — Системные уведомления (flash-сообщения)
 *
 * Переменные PS9:
 *   $notifications.error   — массив строк: ошибки
 *   $notifications.warning — массив строк: предупреждения
 *   $notifications.success — массив строк: успех
 *   $notifications.info    — массив строк: информация
 *
 * Маппинг типов → Bootstrap alert:
 *   error   → alert-danger
 *   warning → alert-warning
 *   success → alert-success
 *   info    → alert-info
 *
 * Маппинг типов → Font Awesome 7 иконки (fas):
 *   error   → fa-circle-xmark
 *   warning → fa-triangle-exclamation
 *   success → fa-circle-check
 *   info    → fa-circle-info
 *
 * Поведение:
 *   — Каждый массив обходится отдельно: несколько сообщений одного типа
 *     выводятся как отдельные alert-блоки.
 *   — Кнопка закрытия Bootstrap (data-bs-dismiss="alert") — без кастомного JS.
 *   — role="alert" + aria-live="polite" для доступности (screen readers).
 *   — Весь блок обёрнут в условие: если все массивы пусты — ничего не рендерится.
 *
 * Подключение:
 *   Вызывается через хук displayContentWrapperTop в layout-full-width.tpl
 *   (хук срабатывает автоматически при наличии модулей на нём).
 *   При необходимости явного подключения:
 *     {include file='_partials/notifications.tpl'}
 *}

{* Проверяем — есть ли хоть одно непустое уведомление *}
{if
  (!empty($notifications.error)) ||
  (!empty($notifications.warning)) ||
  (!empty($notifications.success)) ||
  (!empty($notifications.info))
}

{* Маппинг тип → Bootstrap класс + FA7 иконка *}
{assign var='notif_map' value=[
    'error'   => ['bs' => 'danger',  'icon' => 'fa-circle-xmark'],
    'warning' => ['bs' => 'warning', 'icon' => 'fa-triangle-exclamation'],
    'success' => ['bs' => 'success', 'icon' => 'fa-circle-check'],
    'info'    => ['bs' => 'info',    'icon' => 'fa-circle-info']
  ]}

<div class="notifications-wrap" role="region" aria-label="{l s='Notifications' d='Shop.Theme.Global'}">
  <div class="container">

    {foreach from=$notif_map key='type' item='cfg'}
      {if isset($notifications.$type) && !empty($notifications.$type)}
        {foreach from=$notifications.$type item='message'}

          <div
            class="alert alert-{$cfg.bs} alert-dismissible notifications__alert notifications__alert--{$type} d-flex align-items-start gap-2"
            role="alert" aria-live="polite">
            <i class="fas {$cfg.icon} notifications__icon flex-shrink-0 mt-1" aria-hidden="true"></i>

            <div class="notifications__body">
              {$message}
            </div>

            <button type="button" class="btn-close notifications__close" data-bs-dismiss="alert"
              aria-label="{l s='Close' d='Shop.Theme.Global'}"></button>
          </div>

        {/foreach}
      {/if}
    {/foreach}

  </div>
</div>

{/if}