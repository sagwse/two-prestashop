{**
 * schema-organization.tpl
 * MyShop — PrestaShop 9.0 Theme · v0.4.0
 *
 * Schemas  : Organization + WebSite (с SearchAction / Sitelinks Searchbox)
 * Где      : _partials/head.tpl — включается на ВСЕХ страницах
 * Хук      : нет (глобальная схема, не через displaySchemaMarkup)
 *
 * PS9 Smarty-переменные:
 *   $shop.name, $shop.logo, $shop.phone, $shop.email
 *   $shop.address.address1, $shop.address.address2 (опц.)
 *   $shop.address.city, $shop.address.postcode
 *   $shop.address.country.iso_code
 *   $urls.base_url, $urls.pages.search
 *   $language.iso_code
 *
 * Как подключается в head.tpl:
 *   {include file='_partials/microdata/schema-organization.tpl'}
 *}

{* PS9: $shop.logo — только имя файла (напр. "logo.jpg"), полный URL конструируем вручную *}
{assign var='_org_logo_url' value="`$urls.base_url`img/`$shop.logo`"}

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [

    {* ─── 1. Organization ─── *}
    {
      "@type": "Organization",
      "@id": "{$urls.base_url}#organization",
      "name": "{$shop.name|escape:'javascript'}",
      "url": "{$urls.base_url}",
      "logo": {
        "@type": "ImageObject",
        "@id": "{$urls.base_url}#logo",
        "url": "{$_org_logo_url|escape:'javascript'}",
        "contentUrl": "{$_org_logo_url|escape:'javascript'}"
      }{if $shop.phone},
      "telephone": "{$shop.phone|escape:'javascript'}"{/if}{if $shop.email},
      "email": "{$shop.email|escape:'javascript'}"{/if}{if isset($shop.address.address1) && $shop.address.address1},
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "{$shop.address.address1|escape:'javascript'}{if isset($shop.address.address2) && $shop.address.address2}, {$shop.address.address2|escape:'javascript'}{/if}",
        "addressLocality": "{$shop.address.city|escape:'javascript'}",
        "postalCode": "{$shop.address.postcode|escape:'javascript'}",
        "addressCountry": "{$shop.address.country.iso_code|escape:'javascript'}"
      }{/if}
      {*
        TODO 0.4.x — раскомментируйте и заполните реальными URL аккаунтов:
        ,"sameAs": [
          "https://www.facebook.com/YOURPAGE",
          "https://www.instagram.com/YOURPROFILE",
          "https://t.me/YOURCHANNEL",
          "https://www.youtube.com/@YOURCHANNEL",
          "https://www.tiktok.com/@YOURPROFILE"
        ]
      *}
    },

    {* ─── 2. WebSite + SearchAction (Sitelinks Searchbox) ─── *}
    {
      "@type": "WebSite",
      "@id": "{$urls.base_url}#website",
      "url": "{$urls.base_url}",
      "name": "{$shop.name|escape:'javascript'}",
      "inLanguage": "{$language.iso_code|default:'uk'}",
      "publisher": {
        "@id": "{$urls.base_url}#organization"
      },
      "potentialAction": {
        "@type": "SearchAction",
        "target": {
          "@type": "EntryPoint",
          "urlTemplate": "{$urls.pages.search}?s={literal}{search_term_string}{/literal}"
        },
        "query-input": "required name=search_term_string"
      }
    }

  ]
}
</script>
