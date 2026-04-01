{**
 * mega-menu.tpl — Десктопне навігаційне мегаменю
 * Включається з: templates/_partials/header.tpl
 * PrestaShop 9.0 / Smarty / Bootstrap 5.3 / Font Awesome 7
 *
 * Містить: <ul class="nav-list"> з усіма пунктами мегаменю.
 * TODO: Замінити хардкодовані посилання на категорії PS через цикл
 *       {foreach from=$categories item='cat'} після інтеграції ps_mainmenu.
 *}

<ul class="nav-list">

  {* ── Мегаменю КАТАЛОГ ───────────────────────────────────────────────── *}
  <li class="has-megamenu">
    <a href="{url entity='category' id=2}" class="nav-btn-catalog">
      <i class="fa-solid fa-bars" aria-hidden="true"></i>
      {l s='Каталог' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down nav-caret" aria-hidden="true"></i>
    </a>

    <div class="nav-megamenu" id="js-megamenu-catalog">
      <div class="nav-megamenu__inner">

        <div class="mm-topbar">
          <span class="mm-topbar__label">{l s='Весь асортимент G&G Vitamins UK' d='Shop.Theme.Global'}</span>
          <a href="{url entity='category' id=2}" class="mm-topbar__all">
            {l s='Дивитись усі товари' d='Shop.Theme.Global'}
            <i class="fa-solid fa-arrow-right" style="font-size:0.7rem" aria-hidden="true"></i>
          </a>
        </div>

        <div class="megamenu-catalog">

          {* ── Колонка Вітаміни ── *}
          <div class="megamenu-col megamenu-col--vit">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-sun" aria-hidden="true"></i></span>
              {l s='Вітаміни' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <a href="#">{l s='Вітамін A' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-top">
                {l s='Вітамін B (комплекс)' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">ТОП</span>
              </a>
              <a href="#" class="mm-sub">B1 · B2 · B3 · B5 · B6 · B7 · B9 · B12</a>
              <a href="#">{l s='Вітамін C' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-top">
                {l s='Вітамін D3' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★ №1</span>
              </a>
              <a href="#">{l s='Вітамін E' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Вітамін K (K1 + K2-MK7)' d='Shop.Theme.Global'}</a>
              <span class="mm-section-title">{l s='Мультивітаміни' d='Shop.Theme.Global'}</span>
              <a href="#">{l s='Загальні' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Для жінок' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Для чоловіків' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Для дітей' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='Усі вітаміни' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Колонка Мінерали ── *}
          <div class="megamenu-col megamenu-col--min">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-gem" aria-hidden="true"></i></span>
              {l s='Мінерали' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <a href="#" class="mm-top">
                {l s='Магній (Mg)' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★</span>
              </a>
              <a href="#">{l s='Цинк (Zn)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Залізо (Fe)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Кальцій (Ca)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Селен (Se)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Йод (I)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Калій (K)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Хром (Cr)' d='Shop.Theme.Global'}</a>
              <span class="mm-section-title">{l s='Комплекси' d='Shop.Theme.Global'}</span>
              <a href="#">{l s='Мультимінерали' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='Усі мінерали' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Колонка Добавки ── *}
          <div class="megamenu-col megamenu-col--sup">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-capsules" aria-hidden="true"></i></span>
              {l s='Добавки' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <a href="#" class="mm-top">
                {l s='Омега 3 / 6 / 9' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★</span>
              </a>
              <a href="#" class="mm-top">
                {l s='Пробіотики' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★</span>
              </a>
              <a href="#">{l s='Амінокислоти' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Антиоксиданти' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Коензим Q10' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Колаген' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Травні ферменти' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Суперфуди' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Рослинні екстракти' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Продукти бджільництва' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Органічні добавки' d='Shop.Theme.Global'}</a>
              <a href="#">Wholefood</a>
              <a href="#">{l s='Порошки для напоїв' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='Усі добавки' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Колонка Спеціальні ── *}
          <div class="megamenu-col megamenu-col--spc">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-star" aria-hidden="true"></i></span>
              {l s='Спеціальні' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <span class="mm-section-title">{l s='За аудиторією' d='Shop.Theme.Global'}</span>
              <a href="#" class="mm-top">
                {l s='Для жінок · SOOV' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--new">UK</span>
              </a>
              <a href="#">{l s='Для чоловіків' d='Shop.Theme.Global'}</a>
              <a href="#" class="mm-top">
                {l s='Для дітей · Kids' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--top">★</span>
              </a>
              <a href="#">{l s='50+ (вікова категорія)' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Для вагітних' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Для спортсменів' d='Shop.Theme.Global'}</a>
              <span class="mm-section-title">{l s='За філософією' d='Shop.Theme.Global'}</span>
              <a href="#">{l s='Веганські' d='Shop.Theme.Global'}</a>
              <a href="#">{l s='Органічні' d='Shop.Theme.Global'}</a>
              <a href="#">Clean Label</a>
              <a href="#">Daily Packs</a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='Усі лінійки' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Колонка Популярне ── *}
          <div class="megamenu-col megamenu-col--pop">
            <div class="megamenu-col__title">
              <span class="mm-col-icon"><i class="fa-solid fa-fire" aria-hidden="true"></i></span>
              {l s='Популярне' d='Shop.Theme.Global'}
            </div>
            <div class="megamenu-col__links">
              <span class="mm-section-title">{l s='Топ для початку' d='Shop.Theme.Global'}</span>
              <div class="mm-chips">
                <a href="#" class="mm-chip mm-chip--hot">{l s='Вітамін D3' d='Shop.Theme.Global'}</a>
                <a href="#" class="mm-chip mm-chip--hot">{l s='Магній' d='Shop.Theme.Global'}</a>
                <a href="#" class="mm-chip mm-chip--hot">Омега-3</a>
                <a href="#" class="mm-chip">{l s='Вітамін C' d='Shop.Theme.Global'}</a>
                <a href="#" class="mm-chip">{l s='Пробіотики' d='Shop.Theme.Global'}</a>
                <a href="#" class="mm-chip">{l s='Цинк' d='Shop.Theme.Global'}</a>
              </div>
              <div class="mm-pop-divider"></div>
              <span class="mm-section-title">{l s='Розділи' d='Shop.Theme.Global'}</span>
              <a href="#">
                <i class="fa-solid fa-wand-sparkles" aria-hidden="true"></i>
                {l s='Новинки' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--new">NEW</span>
              </a>
              <a href="#">
                <i class="fa-solid fa-thumbs-up" aria-hidden="true"></i>
                {l s='Рекомендовані' d='Shop.Theme.Global'}
              </a>
              <a href="#">
                <i class="fa-solid fa-tag" aria-hidden="true"></i>
                {l s='Акційні товари' d='Shop.Theme.Global'}
                <span class="mm-badge mm-badge--sale">-%</span>
              </a>
              <a href="#">
                <i class="fa-solid fa-leaf" aria-hidden="true"></i>
                {l s='Сезонні добірки' d='Shop.Theme.Global'}
              </a>
              <a href="#" class="mm-see-all">
                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                {l s='Переглянути все' d='Shop.Theme.Global'}
              </a>
            </div>
          </div>

          {* ── Промо-банер SOOV ── *}
          <div class="megamenu-soov">
            <div class="soov-inner">
              <div class="megamenu-soov__ribbon">
                <i class="fa-solid fa-circle-dot" aria-hidden="true"></i>
                {l s='Лінійка для жінок' d='Shop.Theme.Global'}
              </div>
              <div class="megamenu-soov__brand">
                <div class="megamenu-soov__title">SOOV</div>
                <div class="megamenu-soov__dot"></div>
              </div>
              <div class="megamenu-soov__tagline">
                {l s="Жіноче здоров'я" d='Shop.Theme.Global'}<br>
                {l s='Преміум формули з Великобританії' d='Shop.Theme.Global'}
              </div>
              <div class="soov-products">
                <div class="soov-group">
                  <div class="soov-group__label">{l s='Цикл' d='Shop.Theme.Global'}</div>
                  <div class="soov-group__tags">
                    <a href="#" class="soov-tag">Flow</a>
                    <a href="#" class="soov-tag">40+</a>
                    <a href="#" class="soov-tag">Meno</a>
                  </div>
                </div>
                <div class="soov-group">
                  <div class="soov-group__label">{l s="Здоров'я" d='Shop.Theme.Global'}</div>
                  <div class="soov-group__tags">
                    <a href="#" class="soov-tag">Deflate</a>
                    <a href="#" class="soov-tag">Ignite</a>
                    <a href="#" class="soov-tag">Endo</a>
                    <a href="#" class="soov-tag">Ova</a>
                  </div>
                </div>
                <div class="soov-group">
                  <div class="soov-group__label">{l s='7-денні саше' d='Shop.Theme.Global'}</div>
                  <div class="soov-group__tags">
                    <a href="#" class="soov-tag">Buzz</a>
                    <a href="#" class="soov-tag">Ow</a>
                    <a href="#" class="soov-tag">Ouch</a>
                    <a href="#" class="soov-tag">Vibes</a>
                    <a href="#" class="soov-tag">Crave</a>
                  </div>
                </div>
              </div>
            </div>
            <img class="soov-award"
              src="{$urls.theme_assets}img/soov-award.png"
              alt="Platinum 2025 Awards Winner"
              width="80" loading="lazy">
            <a href="https://soov.uk/" target="_blank" rel="noopener noreferrer" class="megamenu-soov__btn">
              {l s='Перейти до лінійки' d='Shop.Theme.Global'}
              <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
            </a>
          </div>

        </div>{* /.megamenu-catalog *}
      </div>{* /.nav-megamenu__inner *}
    </div>{* /.nav-megamenu #js-megamenu-catalog *}
  </li>

  {* ── Мегаменю ДЛЯ ЧОГО ─────────────────────────────────────────────── *}
  <li class="has-megamenu">
    <a href="#">
      {l s='Для чого' d='Shop.Theme.Global'}
      <i class="fa-solid fa-chevron-down nav-caret" aria-hidden="true"></i>
    </a>

    <div class="nav-megamenu" id="js-megamenu-forwhat">
      <div class="nav-megamenu__inner">

        <div class="mm-topbar">
          <span class="mm-topbar__label">{l s='Весь асортимент G&G Vitamins UK' d='Shop.Theme.Global'}</span>
          <a href="{url entity='category' id=2}" class="mm-topbar__all">
            {l s='Дивитись усі товари' d='Shop.Theme.Global'}
            <i class="fa-solid fa-arrow-right" style="font-size:0.7rem" aria-hidden="true"></i>
          </a>
        </div>

        <div class="megamenu-forwhat">
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Захист' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Імунітет' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Антиоксидантний захист' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Дихальна система' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Енергія' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Енергія та бадьорість' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s="Спорт і м'язи" d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Схуднення та метаболізм' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Розум' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s="Мозок і пам'ять" d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Сон і відновлення' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Стрес і нерви' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Тіло' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Серце і судини' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Суглоби та кістки' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Травлення' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Краса' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Шкіра і волосся' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Зір' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Детокс та очищення' d='Shop.Theme.Global'}</a>
          </div>
          <div class="forwhat-col">
            <div class="forwhat-col__title">{l s='Особливі' d='Shop.Theme.Global'}</div>
            <a href="#" class="forwhat-item">{l s='Для вагітних' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Дитячий розвиток' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Гормональний баланс' d='Shop.Theme.Global'}</a>
            <a href="#" class="forwhat-item">{l s='Щитоподібна залоза' d='Shop.Theme.Global'}</a>
          </div>
        </div>

        <div class="mm-forwhat-footer">
          <a href="#">
            {l s="→ Всі 18 напрямків здоров'я" d='Shop.Theme.Global'}
          </a>
        </div>

      </div>{* /.nav-megamenu__inner *}
    </div>{* /.nav-megamenu #js-megamenu-forwhat *}
  </li>

  {* ── Прості навігаційні посилання ──────────────────────────────────── *}
  <li>
    <a href="#" class="nav-accent">
      <i class="fa-solid fa-tag" aria-hidden="true"></i>
      {l s='Акції' d='Shop.Theme.Global'}
    </a>
  </li>
  <li><a href="#">{l s='Про бренд' d='Shop.Theme.Global'}</a></li>
  <li><a href="#">{l s='Статті / Блог' d='Shop.Theme.Global'}</a></li>
  <li><a href="#">{l s="Дистриб'ютори" d='Shop.Theme.Global'}</a></li>

</ul>{* /.nav-list *}
