{**
 * errors/not-found.tpl — Контент «не найден» (переиспользуется)
 * mytheme v0.7.1 — PS9 stub
 *}
<div class="not-found text-center py-5">
  <p class="not-found__code" style="font-size: 5rem; font-weight: 800; color: oklch(65% 0 0)">404</p>
  <h1>{l s='Сторінку не знайдено' d='Shop.Theme.Global'}</h1>
  <p>{l s='Можливо, сторінку було видалено або переміщено.' d='Shop.Theme.Global'}</p>
  <p>
    {l
      s='Якщо проблема повторюється, [1]зв\'яжіться з нами[/1].'
      d='Shop.Theme.Global'
      sprintf=[
        '[1]' => '<a href="{$urls.pages.contact}">',
        '[/1]' => '</a>'
      ]
    }
  </p>
  <a href="{$urls.pages.index}" class="btn btn-primary mt-3">
    <i class="fa-solid fa-house me-2" aria-hidden="true"></i>
    {l s='На головну' d='Shop.Theme.Actions'}
  </a>
</div>
