{**
 * javascript.tpl — render JS assets from theme.yml
 * Filtering and deduplication handled by mytheme_core module (output buffering).
 *}

{* External scripts *}
{if isset($javascript.external)}
  {foreach $javascript.external as $js}
    <script src="{$js.uri}" {$js.attribute}></script>
  {/foreach}
{/if}

{* Inline JS from modules *}
{if isset($javascript.inline)}
  {foreach $javascript.inline as $js}
    <script>
      {$js.content nofilter}
    </script>
  {/foreach}
{/if}

{* Smarty variables exported to JS *}
{if isset($vars) && $vars|@count}
  <script>
    {foreach from=$vars key=var_name item=var_value}
      var {$var_name} = {$var_value|json_encode nofilter};
    {/foreach}
  </script>
{/if}