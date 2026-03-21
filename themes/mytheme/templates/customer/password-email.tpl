{**
 * password-email.tpl — Сброс пароля: ввод email
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {l s='Відновлення пароля' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  <p>{l s='Введіть вашу email адресу для отримання посилання на скидання пароля.' d='Shop.Theme.Customeraccount'}</p>
  <form action="{$urls.pages.password}" method="post">
    <div class="mb-3">
      <label class="form-label" for="email">{l s='Email' d='Shop.Forms.Labels'}</label>
      <input class="form-control" type="email" name="email" id="email" required>
    </div>
    <button class="btn btn-primary" type="submit" name="submit">
      {l s='Надіслати' d='Shop.Theme.Actions'}
    </button>
  </form>
{/block}
