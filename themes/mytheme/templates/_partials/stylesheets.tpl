{**
 * stylesheets.tpl — render CSS assets from theme.yml
 * Filtering and deduplication handled by mytheme_core module (output buffering).
 *}

{* External stylesheets *}
{if isset($stylesheets.external)}
  {foreach $stylesheets.external as $stylesheet}
    <link rel="stylesheet" href="{$stylesheet.uri}" type="text/css" media="{$stylesheet.media}">
  {/foreach}
{/if}

{* Inline styles *}
{if isset($stylesheets.inline)}
  {foreach $stylesheets.inline as $stylesheet}
    <style>
      {$stylesheet.content nofilter}
    </style>
  {/foreach}
{/if}