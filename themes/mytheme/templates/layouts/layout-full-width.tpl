{**
 * templates/layouts/layout-full-width.tpl
 * v0.5.0 — Базовый layout: полная ширина, без боковых колонок.
 *
 * Используется: index.tpl, cms.tpl, checkout.tpl, customer/*.tpl,
 *               errors/404.tpl, errors/500.tpl
 *
 * Дочерний шаблон наследует через: {extends file='layouts/layout-full-width.tpl'}
 * Контентный блок:                 {block name='content'} ... {/block}
 *
 * Дополнительные переопределяемые блоки:
 *   {block name='head_extra'}    — дополнительные теги внутри <head> (per-page meta, schema)
 *   {block name='body_attrs'}    — дополнительные атрибуты <body>
 *   {block name='before_header'} — зона между <body> и header (редко нужно)
 *   {block name='after_footer'}  — зона после footer (до </body>)
 *}
<!doctype html>
<html lang="{$language.iso_code}"{if $language.is_rtl} dir="rtl"{/if}>

<head>
  {include file='_partials/head.tpl'}
  {block name='head_extra'}{/block}
</head>

<body
  id="{$page.page_name}"
  class="page-{$page.page_name} {$page.body_classes|classnames}"
  {block name='body_attrs'}{/block}
>

  {* Google Tag Manager / аналитика — displayAfterBodyOpeningTag *}
  {hook h='displayAfterBodyOpeningTag'}

  {block name='before_header'}{/block}

  {* ─── Шапка ─────────────────────────────────────────────────────────── *}
  {include file='_partials/header.tpl'}

  {* ─── Основной контент ──────────────────────────────────────────────── *}
  <main id="main-content" role="main" tabindex="-1">

    {* Хук над контентом: flash-сообщения модулей, баннеры, топ-плашки *}
    {hook h='displayContentWrapperTop'}

    {block name='content'}{/block}

    {* Хук под контентом *}
    {hook h='displayContentWrapperBottom'}

  </main>

  {* ─── Подвал ─────────────────────────────────────────────────────────── *}
  {include file='_partials/footer.tpl'}

  {block name='after_footer'}{/block}

  {* Подключение скриптов перед закрывающим тегом body *}
  {block name='javascript_bottom'}
    {include file='_partials/javascript.tpl' javascript=$javascript.bottom}
  {/block}

  {* Google Tag Manager body / cookie banner — displayBeforeBodyClosingTag *}
  {hook h='displayBeforeBodyClosingTag'}

</body>
</html>
