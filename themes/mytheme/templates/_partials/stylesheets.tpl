{**
 * stylesheets.tpl — рендер CSS файлов из theme.yml
 * Фильтрует: jQuery UI CSS, CSS модулей, дубли
 *}

{* Список URI которые нужно заблокировать *}
{assign var="blocked_css" value=[
  'jquery',
  'ps_socialfollow',
  'blockreassurance',
  'ps_searchbar',
  'productcomments',
  'homeslider',
  'wishlist'
]}

{if isset($stylesheets.external)}
  {assign var="rendered_css" value=[]}
  {foreach $stylesheets.external as $stylesheet}

    {* Проверяем на заблокированные *}
    {assign var="isBlocked" value=false}
    {foreach $blocked_css as $blocked}
      {if $stylesheet.uri|stristr:$blocked}
        {assign var="isBlocked" value=true}
      {/if}
    {/foreach}

    {* Проверяем на дубли *}
    {assign var="isDuplicate" value=false}
    {foreach $rendered_css as $rendered}
      {if $rendered == $stylesheet.uri}
        {assign var="isDuplicate" value=true}
      {/if}
    {/foreach}

    {if !$isBlocked && !$isDuplicate}
      {append var="rendered_css" value=$stylesheet.uri}
      <link rel="stylesheet" href="{$stylesheet.uri}" type="text/css" media="{$stylesheet.media}">
    {/if}
  {/foreach}
{/if}

{if isset($stylesheets.inline)}
  {foreach $stylesheets.inline as $stylesheet}
    <style>
      {$stylesheet.content nofilter}
    </style>
  {/foreach}
{/if}