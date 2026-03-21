{**
 * password-new.tpl — Сброс пароля: новый пароль
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Новий пароль' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  <form action="{$urls.pages.password}" method="post">
    <input type="hidden" name="token" value="{$customer_token}">
    <input type="hidden" name="id_customer" value="{$id_customer}">
    <div class="mb-3">
      <label class="form-label" for="passwd">{l s='Новий пароль' d='Shop.Forms.Labels'}</label>
      <input class="form-control" type="password" name="passwd" id="passwd" required>
    </div>
    <div class="mb-3">
      <label class="form-label" for="confirmation">{l s='Підтвердження пароля' d='Shop.Forms.Labels'}</label>
      <input class="form-control" type="password" name="confirmation" id="confirmation" required>
    </div>
    <button class="btn btn-primary" type="submit" name="submit">
      {l s='Змінити пароль' d='Shop.Theme.Actions'}
    </button>
  </form>
{/block}
