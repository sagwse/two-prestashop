{**
 * javascript.tpl — рендер JS файлов из theme.yml
 * PrestaShop 9.0 / mytheme
 *
 * Вызывается дважды: в <head> и перед </body>.
 * window.__ps_patched — JS-флаг, гарантирует однократное выполнение патча.
 *
 * ПАТЧ — Object.defineProperty interceptor:
 *   Перехватывает момент присвоения window.prestashop = {...} в core.js
 *   и немедленно добавляет EventEmitter (.on/.off/.emit/.fire).
 *   Это решает проблему product.bundle.js, который падает ещё
 *   до DOMContentLoaded — раньше, чем setTimeout/DCL-патч успевает сработать.
 *
 * PS 9.0.3 bug: window.prestashop создаётся core.js без методов
 *   .on / .emit / .off → все модули падают с "prestashop.on is not a function".
 *
 * ЗАБЛОКИРОВАННЫЕ СКРИПТЫ (фильтрация по URI):
 *   ps_searchbar.js       — заменён собственным LiveSearch в theme.js
 *   blockreassurance      — модуль не используется, USP Bar — статичный HTML
 *   ps_facebook           — Facebook Pixel не подключён
 *   ps_imageslider        — Hero статичный, слайдер не используется
 *}

{* ============================================================
   prestashop EventEmitter patch — PS 9.0.3 bugfix
   window.__ps_patched гарантирует однократное выполнение
   при двух вызовах javascript.tpl.
   ============================================================ *}
<script>
  (function() {
    if (window.__ps_patched) return;
    window.__ps_patched = true;

    function addEmitter(ps) {
      if (!ps || typeof ps.emit === 'function') return;
      var _listeners = {};
      ps.on = function(event, cb) {
        if (!_listeners[event]) _listeners[event] = [];
        _listeners[event].push(cb);
      };
      ps.off = function(event, cb) {
        if (!_listeners[event]) return;
        _listeners[event] = _listeners[event].filter(function(fn) { return fn !== cb; });
      };
      ps.emit = function(event, data) {
        (_listeners[event] || []).forEach(function(fn) {
          try { fn(data); } catch (e) {}
        });
      };
      ps.fire = ps.emit;
    }

    if (window.prestashop) {
      /* core.js уже создал объект к этому моменту — патчим сразу */
      addEmitter(window.prestashop);
    } else {
      /* core.js ещё не создал объект — перехватываем момент присвоения.
Как только core.js выполнит window.prestashop = {*...*},
      сработает наш setter: добавит EventEmitter и восстановит
      обычное свойство(чтобы дальнейшие read / write работали нормально).*/
      var _stored;
      Object.defineProperty(window, 'prestashop', {
        configurable: true,
        enumerable: true,
        get: function() { return _stored; },
        set: function(val) {
          _stored = val;
          Object.defineProperty(window, 'prestashop', {
            configurable: true,
            writable: true,
            enumerable: true,
            value: val
          });
          addEmitter(val);
        }
      });
    }
  })();
</script>

{* ============================================================
   Внешние скрипты (core.js + модули + тема)

   ЗАБЛОКИРОВАНО (isBlocked = true → скрипт не рендерится):
     jQuery              — тема не использует
     ps_searchbar.js     — заменён собственным LiveSearch в theme.js
     blockreassurance    — не используется, USP Bar статичный HTML
     ps_facebook         — Facebook Pixel не подключён
     ps_imageslider      — Hero статичный, слайдер не используется

   Дубли фильтруются по URI.
   ============================================================ *}
{if isset($javascript.external)}
  {assign var="rendered_js" value=[]}
  {foreach $javascript.external as $js}

    {* --- фильтры --- *}
    {assign var="isJquery"          value=$js.uri|stristr:'jquery'}
    {assign var="isSearchbar"       value=$js.uri|stristr:'ps_searchbar/ps_searchbar.js'}
    {assign var="isBlockReassurance" value=$js.uri|stristr:'blockreassurance'}
    {assign var="isFacebook"        value=$js.uri|stristr:'ps_facebook'}
    {assign var="isImageSlider"     value=$js.uri|stristr:'ps_imageslider'}

    {assign var="isDuplicate" value=false}
    {foreach $rendered_js as $rendered}
      {if $rendered == $js.uri}
        {assign var="isDuplicate" value=true}
      {/if}
    {/foreach}

    {assign var="isBlocked" value=$isJquery || $isSearchbar || $isBlockReassurance || $isFacebook || $isImageSlider}

    {if !$isBlocked && !$isDuplicate}
      {append var="rendered_js" value=$js.uri}
      <script src="{$js.uri}" {$js.attribute}></script>
    {/if}

  {/foreach}
{/if}

{* ============================================================
   Inline JS от модулей
   ============================================================ *}
{if isset($javascript.inline)}
  {foreach $javascript.inline as $js}
    <script>
      {$js.content nofilter}
    </script>
  {/foreach}
{/if}

{* ============================================================
   Smarty-переменные, экспортированные в JS
   ============================================================ *}
{if isset($vars) && $vars|@count}
  <script>
    {foreach from=$vars key=var_name item=var_value}
      var {$var_name} = {$var_value|json_encode nofilter};
    {/foreach}
  </script>
{/if}