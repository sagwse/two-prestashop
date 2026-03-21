{**
 * contact.tpl — Контактная форма
 * mytheme v0.7.1 — PS9 stub (полная реализация → v0.10.0)
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Зв\'язатися з нами' d='Shop.Theme.Global'}
{/block}

{block name='page_content'}
  {hook h='displayContactContent'}
{/block}
