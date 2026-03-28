{**
 * head.tpl — <head> секция темы mytheme
 *
 * Содержит:
 *  1. Базовые мета-теги (charset, viewport, title, description, robots, canonical)
 *  2. hreflang (мультиязычность)
 *  3. CSS (глобальные через $stylesheets — собираются из theme.yml)
 *  4. Open Graph / Twitter Card мета-теги
 *  5. Favicon
 *  6. JSON-LD схемы:
 *     — schema-organization.tpl  (Organization + WebSite + SearchAction) — всегда
 *     — schema-breadcrumb.tpl    (BreadcrumbList)                         — всегда
 *     — {hook h='displaySchemaMarkup'}                                    — страничные
 *  7. Preconnect hints для производительности
 *
 * ВАЖНО:
 *  — JS НЕ подключается здесь. Все скрипты — в конце <body> с атрибутом defer.
 *    Исключение: критический inline-JS (детекция touch, class на <html>) — только здесь.
 *  — Микроразметка ТОЛЬКО JSON-LD, никаких микроатрибутов в HTML.
 *  — CSS assets регистрируются через theme.yml и выводятся через $stylesheets.
 *}


{* =========================================================================
     1. БАЗОВЫЕ МЕТА-ТЕГИ
     ========================================================================= *}

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

{* Title: PrestaShop формирует его автоматически из настроек SEO страницы *}
<title>{$page.meta.title|escape:'html'}</title>

{* Description *}
{if $page.meta.description}
  <meta name="description" content="{$page.meta.description|escape:'html'}">
{/if}

{* Keywords (низкий приоритет для SEO, но PrestaShop их формирует) *}
{if isset($page.meta.keywords) && $page.meta.keywords}
  <meta name="keywords" content="{$page.meta.keywords|escape:'html'}">
{/if}

{* Robots: индексация управляется через BO или SEO-модуль *}
<meta name="robots" content="{if $page.meta.robots}{$page.meta.robots|escape:'html'}{else}index, follow{/if}">

{* Canonical URL: предотвращает дубли (пагинация, фильтры, сортировка) *}
{if $page.canonical}
  <link rel="canonical" href="{$page.canonical|escape:'html'}">
{/if}

{* =========================================================================
     2. HREFLANG — мультиязычность
     Генерируется PrestaShop автоматически из $urls.alternative_langs
     x-default указывает на дефолтный язык магазина
     ========================================================================= *}

{if isset($urls.alternative_langs) && $urls.alternative_langs|@count > 1}
  {foreach from=$urls.alternative_langs item='lang_url' key='lang_code'}
    <link rel="alternate" hreflang="{$lang_code|escape:'html'}" href="{$lang_url|escape:'html'}">
  {/foreach}
  {* x-default — указываем на URL дефолтного языка магазина *}
  {if isset($default_language_code) && isset($urls.alternative_langs[$default_language_code])}
    <link rel="alternate" hreflang="x-default" href="{$urls.alternative_langs[$default_language_code]|escape:'html'}">
  {/if}
{/if}

{* =========================================================================
     3. PRECONNECT / PRELOAD — подсказки браузеру для производительности
     Добавляй только внешние домены, с которыми реально идут запросы.
     Font Awesome — локально, поэтому нет preconnect на CDN.
     ========================================================================= *}

{* Preload критических шрифтов Font Awesome (woff2 — самый приоритетный формат) *}
{* Пример — раскомментируй и укажи реальное имя файла из /assets/fonts/ *}
{*
  <link rel="preload" href="{$urls.theme_assets}fonts/fa-solid-900.woff2" as="font" type="font/woff2" crossorigin="anonymous">
  <link rel="preload" href="{$urls.theme_assets}fonts/fa-brands-400.woff2" as="font" type="font/woff2" crossorigin="anonymous">
  *}

{* =========================================================================
     4. CSS
     Файлы формируются из theme.yml (приоритеты: bootstrap=5, fa=6, theme=50, страничные=60)
     PrestaShop выводит их через $stylesheets, отсортированными по priority.
     ========================================================================= *}

{include file='_partials/stylesheets.tpl' stylesheets=$stylesheets}
{include file='_partials/javascript.tpl' javascript=$javascript.head vars=$js_custom_vars}

{* =========================================================================
     5. FAVICON
     PrestaShop берёт favicon из настроек магазина (BO → Дизайн → Настройки темы).
     SVG favicon — современный стандарт, поддерживается всеми браузерами.
     ========================================================================= *}

{if $shop.favicon}
  <link rel="icon" type="image/x-icon" href="{$shop.favicon|escape:'html'}">
{else}
  <link rel="icon" type="image/svg+xml" href="{$urls.theme_assets}img/favicon.svg">
  <link rel="icon" type="image/png" href="{$urls.theme_assets}img/favicon.png" sizes="32x32">
{/if}
<link rel="apple-touch-icon" href="{$urls.theme_assets}img/apple-touch-icon.png" sizes="180x180">

{* =========================================================================
     6. OPEN GRAPH + TWITTER CARD
     og:image — 1200×630 px, минимум 600×315 px (требования FB/LinkedIn)
     Страничная логика:
       — product       → изображение товара (large_default или thickbox)
       — category      → изображение категории (если есть)
       — cms / прочее  → дефолтное og-изображение магазина
     ========================================================================= *}

{* Определяем og:image в зависимости от типа страницы *}
{if $page.page_name == 'product' && isset($product.cover.bySize.thickbox_default.url)}
  {assign var='og_image' value=$product.cover.bySize.thickbox_default.url}
  {assign var='og_type' value='product'}
{elseif $page.page_name == 'category' && isset($category.image.large.url)}
  {assign var='og_image' value=$category.image.large.url}
  {assign var='og_type' value='website'}
{else}
  {assign var='og_image' value="{$urls.theme_assets}img/og-default.jpg"}
  {assign var='og_type' value='website'}
{/if}

{* Open Graph *}
<meta property="og:site_name" content="{$shop.name|escape:'html'}">
<meta property="og:type" content="{$og_type}">
<meta property="og:title" content="{$page.meta.title|escape:'html'}">
<meta property="og:url"
  content="{if $page.canonical}{$page.canonical|escape:'html'}{else}{$urls.current_url|escape:'html'}{/if}">
<meta property="og:image" content="{$og_image|escape:'html'}">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
{if $page.meta.description}
  <meta property="og:description" content="{$page.meta.description|escape:'html'}">
{/if}
<meta property="og:locale" content="{$language.locale|escape:'html'}">
{* Альтернативные языки для OG *}
{if isset($urls.alternative_langs) && $urls.alternative_langs|@count > 1}
  {foreach from=$urls.alternative_langs item='_lang_url' key='_lang_code'}
    {if $_lang_code != $language.iso_code}
      <meta property="og:locale:alternate" content="{$_lang_code|replace:'-':'_'|escape:'html'}">
    {/if}
  {/foreach}
{/if}

{* Twitter Card *}
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="{$page.meta.title|escape:'html'}">
<meta name="twitter:image" content="{$og_image|escape:'html'}">
{if $page.meta.description}
  <meta name="twitter:description" content="{$page.meta.description|escape:'html'}">
{/if}
{* Раскомментируй и укажи Twitter/X хэндл магазина *}
{* <meta name="twitter:site" content="@yourshop"> *}

{* =========================================================================
     7. JSON-LD МИКРОРАЗМЕТКА
     Глобальные схемы — на КАЖДОЙ странице.
     Страничные — через кастомный хук displaySchemaMarkup.

     schema-organization.tpl → Organization + WebSite + SearchAction
     schema-breadcrumb.tpl   → BreadcrumbList

     Страничные схемы подключаются из шаблонов страниц через хук:
       catalog/product.tpl    → {hook h='displaySchemaMarkup'} добавляет schema-product.tpl
       catalog/.../category   → добавляет schema-category.tpl
       cms/cms.tpl            → добавляет schema-article.tpl
       и т.д.
     ========================================================================= *}

{* Глобальная схема: Organization + WebSite + SearchAction *}
{include file='_partials/microdata/schema-organization.tpl'}

{* Глобальная схема: BreadcrumbList (доступна $breadcrumb на всех страницах) *}
{if isset($breadcrumb.links) && $breadcrumb.links|@count > 0}
  {include file='_partials/microdata/schema-breadcrumb.tpl'}
{/if}

{* Страничные JSON-LD схемы — добавляются через хук из шаблонов страниц *}
{hook h='displaySchemaMarkup'}

{* =========================================================================
     8. ПРОЧЕЕ
     ========================================================================= *}

{* Критический inline JS ТОЛЬКО при крайней необходимости.
     Пример: добавление класса 'js' на <html> для прогрессивного улучшения.
     Этот фрагмент должен быть максимально маленьким.
  *}
<script>
  document.documentElement.className = document.documentElement.className.replace('no-js', 'js');
</script>

{* Хук для сторонних скриптов в head (GTM, аналитика — если не через GTM body) *}
{hook h='displayHeader'}