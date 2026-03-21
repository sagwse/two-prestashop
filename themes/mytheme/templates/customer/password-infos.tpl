{**
 * password-infos.tpl — Сброс пароля: информация об отправке
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Відновлення пароля' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  <p>{l s='Якщо акаунт з такою email адресою існує, ви отримаєте лист з інструкціями.' d='Shop.Theme.Customeraccount'}</p>
  <a href="{$urls.pages.authentication}" class="btn btn-outline-primary">
    {l s='Повернутися до входу' d='Shop.Theme.Actions'}
  </a>
{/block}
