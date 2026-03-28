{**
 * schema-article.tpl
 * MyShop — PrestaShop 9.0 Theme · v0.4.0
 *
 * Schema   : WebPage (по умолчанию) или Article (для контентных CMS-страниц)
 * Где      : cms/cms.tpl (CMS страницы)
 * Хук      : displaySchemaMarkup — добавить в cms.tpl:
 *              {hook h='displaySchemaMarkup'}
 *            ИЛИ напрямую:
 *              {include file='_partials/microdata/schema-article.tpl'}
 *
 * PS9 Smarty-переменные:
 *   $cms.id_cms         — id CMS страницы (для @id)
 *   $cms.meta_title     — заголовок страницы
 *   $cms.meta_description — мета-описание (опц.)
 *   $cms.content        — HTML контент страницы
 *   $cms.date_add       — дата создания ('Y-m-d H:i:s')
 *   $cms.date_upd       — дата последнего изменения ('Y-m-d H:i:s')
 *   $shop.name          — название магазина
 *   $urls.current_url   — URL текущей страницы
 *   $urls.base_url
 *   $language.iso_code  — код языка
 *
 * КАК ВЫБРАТЬ ТИП СХЕМЫ:
 *   По умолчанию используется WebPage — подходит для большинства CMS-страниц
 *   (Контакты, О нас, Доставка, Гарантия, Политика конфиденциальности).
 *
 *   Для редакционных/новостных статей (блог, гид покупателя) используйте Article:
 *   передайте переменную schema_type='Article' перед include:
 *     {assign var='schema_type' value='Article'}
 *     {include file='_partials/microdata/schema-article.tpl'}
 *
 *   Или прямо в cms.tpl по id страницы:
 *     {if $cms.id_cms == 15}{assign var='schema_type' value='Article'}{/if}
 *}

{assign var='_schema_type' value=$schema_type|default:'WebPage'}

{*
 * Форматируем дату: PS9 хранит в формате 'Y-m-d H:i:s'.
 * Используем truncate:10 вместо date_format — безопасно для PHP 8.4
 * (strftime deprecated с PHP 8.1, date_format:'%Y-%m-%d' может давать E_DEPRECATED).
 * truncate:10:'' берёт первые 10 символов строки → '2024-01-15' — валидный ISO 8601 для schema.org.
 *}
{assign var='_date_published' value=$cms.date_add|truncate:10:''}
{assign var='_date_modified'  value=$cms.date_upd|truncate:10:''}

<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "{$_schema_type}",
    "@id": "{$urls.current_url|escape:'javascript'}#webpage",
    "url": "{$urls.current_url|escape:'javascript'}",
    "name": "{$cms.meta_title|escape:'javascript'}"{if $cms.meta_description},
    "description": "{$cms.meta_description|escape:'javascript'}"{/if},
    "inLanguage": "{$language.iso_code|default:'uk'}",
    "isPartOf": {
      "@id": "{$urls.base_url}#website"
    },
    "datePublished": "{$_date_published}",
    "dateModified": "{$_date_modified}",
    "author": {
      "@id": "{$urls.base_url}#organization"
    },
    "publisher": {
      "@id": "{$urls.base_url}#organization"
    }

    {* ── Поля только для типа Article ── *}
    {if $_schema_type == 'Article'},
      "articleBody": "{$cms.content|strip_tags|trim|truncate:5000:''|escape:'javascript'}",
      {*
      * ПОРЯДОК МОДИФИКАТОРОВ— ВАЖНО:
        *
        strip_tags→ trim→ truncate→ escape(всегда escape последним!) *
        Обратный порядок(escape до truncate) может сломать JSON:
        *
        escape превращает\ " в \\",
      и если truncate режет строку *
      ровно между\ и " — JSON невалиден (строка заканчивается на \). *
    truncate: 5000: ''—
    5000 символов,
    append = '',
    без многоточия.*truncate: 110: ''—
    ограничение Google для headline.*
  }
  "headline": "{$cms.meta_title|truncate:110:''|escape:'javascript'}"
  {/if}

  }
</script>