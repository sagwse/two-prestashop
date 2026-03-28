{**
 * javascript.tpl — рендер JS файлов из theme.yml
 *}
{if isset($javascript.external)}
  {foreach $javascript.external as $js}
    <script type="text/javascript" src="{$js.uri}" {$js.attribute}></script>
  {/foreach}
{/if}

{if isset($javascript.inline)}
  {foreach $javascript.inline as $js}
    <script type="text/javascript">
      {$js.content nofilter}
    </script>
  {/foreach}
{/if}

{if isset($vars) && $vars|@count}
  <script type="text/javascript">
    {foreach from=$vars key=var_name item=var_value}
      var {$var_name} = {$var_value|json_encode nofilter};
    {/foreach}
  </script>
{/if}