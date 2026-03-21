{**
 * my-account.tpl — Личный кабинет
 * mytheme v0.7.1 — PS9 stub (полная реализация → v0.9.0)
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Мій акаунт' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {include file='customer/_partials/my-account-links.tpl'}
{/block}
