{**
 * stylesheets.tpl — рендер CSS файлов из theme.yml
 *}
{foreach $stylesheets.external as $stylesheet}
  <link rel="stylesheet" href="{$stylesheet.uri}" type="text/css" media="{$stylesheet.media}">
{/foreach}

{if isset($stylesheets.inline)}
  {foreach $stylesheets.inline as $stylesheet}
    <style>
      {$stylesheet.content nofilter}
    </style>
  {/foreach}
{/if}
