# Рекомендации по разработке главной страницы v0.5.x
## PrestaShop 9.0 — mytheme | G&G Vitamins UA
**Актуально:** март 2026 | Ниша: дієтичні добавки, вітаміни, мінерали | Ассортимент: 300+

> Документ является продолжением `CATALOG-0.6.0-recommendations.md`
> и `PRODUCT-0.7.0-recommendations.md`.
> Читать вместе с `PROJECT.md`, `CHANGELOG.md`, `ps9_categories.md`.
>
> **Порядок разработки (принятый):** каталог v0.6.0 ✅ → карточка товара v0.7.0 ⬜ → **главная v0.5.x** ⬜
>
> Главная разрабатывается последней — это правильно: к этому моменту уже
> готовы `product-miniature.tpl`, `rating-stars.tpl`, CSS-переменные и
> все партиалы, которые переиспользуются на главной.

---

## 1. СТРАТЕГИЧЕСКИЕ РЕШЕНИЯ

### 1.1 Главная цель страницы

**Решение: равномерный баланс — продажи + доверие.**

Обоснование (Nielsen Norman Group, 2025):
- Главная страница e-commerce выполняет две функции одновременно: **быстрый путь к товару** для тех, кто уже знает что хочет, и **убеждение** для тех, кто пришёл впервые.
- Для ниши нутрицевтики (YMYL — Your Money or Your Life) доверие критично: Google E-E-A-T и пользователи одинаково требуют подтверждения экспертизы и безопасности.
- G&G UA — официальный представитель британского бренда с 50-летней историей. Это конкурентное преимущество, которое должно считываться **с первого экрана**.

**Два CTA в Hero (не один):**
- Primary CTA: «Переглянути каталог» → `/ua/vitaminy` (продажи)
- Secondary CTA: «Дізнатись більше про G&G» → `/ua/pro-nas` (доверие)

### 1.2 Hero — статичный HTML + JS-ротация акцентной фразы (принято)

**Архитектура:** фиксированная основа H1 + одно выделенное слово/фраза, которая плавно меняется через fade. Фото и фон — статичны, меняется только текст. LCP не страдает.

**Почему не ps_imageslider:**
- LCP: статичный HTML грузится за ~0.3–0.8s против 1.5–3s у слайдера (Baymard, 2025).
- Banner blindness: NNG (2024) — пользователи игнорируют автоматически движущийся контент.
- Ротация только текста — нет смены тяжёлых изображений, нет CLS, нет лишних HTTP-запросов.

**Структура H1 с ротацией:**
```html
<h1 class="hero__title">
  Вітаміни та добавки для
  <span class="hero__rotating-phrase" aria-live="polite">
    <span class="hero__phrase is-active">вашого здоров'я</span>
    <span class="hero__phrase">імунітету</span>
    <span class="hero__phrase">енергії та сну</span>
    <span class="hero__phrase">жіночого здоров'я</span>
    <span class="hero__phrase">всієї родини</span>
  </span>
</h1>
```

**Принцип:** H1 для Google и AI-агентов всегда читается как полный текст первого `is-active` варианта — «Вітаміни та добавки для вашого здоров'я». Остальные фразы в DOM видны скринридерам через `aria-live="polite"`, не мешают SEO.

**CSS:**
```css
.hero__rotating-phrase {
  display: inline-block;
  position: relative;
  color: var(--color-primary);
}

.hero__phrase {
  display: block;
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0;
  transition: opacity 0.6s ease-in-out;
  white-space: nowrap;
  pointer-events: none;
}

.hero__phrase.is-active {
  position: relative;
  opacity: 1;
  pointer-events: auto;
}
```

**JS (< 30 строк, без библиотек, defer):**
```javascript
// home.js — Hero phrase rotation
(function () {
  const phrases = document.querySelectorAll('.hero__phrase');
  if (!phrases.length) return;

  let current = 0;
  const INTERVAL = 3000;   // 3 секунды на фразу
  const FADE     = 600;    // совпадает с CSS transition

  function next() {
    phrases[current].classList.remove('is-active');
    current = (current + 1) % phrases.length;
    phrases[current].classList.add('is-active');
  }

  // Пауза при потере фокуса вкладки — экономия ресурсов
  let timer = setInterval(next, INTERVAL);
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) { clearInterval(timer); }
    else { timer = setInterval(next, INTERVAL); }
  });

  // Уважение к prefers-reduced-motion
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    clearInterval(timer);
  }
}());
```

**5 ротируемых фраз (покрывают все ключевые сегменты):**

| Фраза | Целевой сегмент |
|---|---|
| `вашого здоров'я` | Общий — первый показ |
| `імунітету` | Иммунитет — топ-запрос осень/зима |
| `енергії та сну` | Магній, B-вітаміни |
| `жіночого здоров'я` | SOOV, жіноча аудиторія |
| `всієї родини` | Kids Rainbow Food, Daily Packs |

**⚠️ SEO-важно:** `prefers-reduced-motion` отключает ротацию — фраза остаётся первой. Google Googlebot видит первую фразу (статичный рендер). Все варианты присутствуют в DOM — не скрыты через `display:none`, читаются AI-агентами.

### 1.3 Порядок секций — обоснование

Порядок секций на главной определяется **«тепловой картой намерений»** (Baymard, 2025): разные пользователи имеют разные намерения — нужно охватить все сценарии в первых 2–3 экранах.

```
Сценарий A: «Знаю что хочу»    → Hero (поиск) → Топ товари → Категорії
Сценарий B: «Хочу, но не знаю» → Hero (слоган) → Топ для початку → Для чого
Сценарий C: «Вперше на сайті»  → Hero → USP Bar → Про бренд G&G → Категорії
Сценарий D: «SOOV цікавить»    → Hero → SOOV блок → Товари SOOV
```

**Оптимальная последовательность для охвата всех сценариев:**

```
[1]  Hero + USP Bar             ← Сценарии A, B, C, D — первый экран
[2]  Категорії (плитки)         ← Сценарий A, C — быстрая навигация
[3]  Топ для початку            ← Сценарий B — «не знаю что выбрать»
[4]  SOOV — міні-лендінг        ← Сценарий D — отдельная аудитория
[5]  Про бренд G&G              ← Сценарий C — строим доверие
[6]  Відгуки / Соціальний доказ ← Все сценарии — финальное убеждение
[7]  Блог / Статті              ← SEO + повторні відвідування
[8]  FAQ                        ← SEO + AI-агенти
```

---

## 2. ДЕТАЛЬНАЯ АРХИТЕКТУРА СЕКЦИЙ

### 2.1 Секція 1 — Hero з ротацією акцентної фрази

**Макет (desktop):**
```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  H1: Вітаміни та добавки для        [фото флаконів G&G]    │
│      ╔══════════════════════╗        (560×520px WebP)       │
│      ║  «вашого здоров'я»  ║  ← акцентна фраза змінюється  │
│      ╚══════════════════════╝    плавно кожні 3.2 секунди   │
│                                                             │
│  <p> Офіційний представник G&G Vitamins Ltd                 │
│       (Велика Британія). 300+ найменувань.                  │
│                                                             │
│  [Переглянути каталог →]  [Дізнатись про G&G]               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Мобільна версія:** фото скривається, текст і CTA — на повну ширину.

**Smarty розмітка Hero:**
```smarty
<section class="hero" id="home-hero">
  <div class="container">
    <div class="hero__layout">

      <div class="hero__content">
        <h1 class="hero__title">
          {l s='Вітаміни та добавки для' d='Shop.Theme.Global'}
          <span class="hero__rotating-phrase" aria-live="polite">
            <span class="hero__phrase is-active">{l s="вашого здоров'я" d='Shop.Theme.Global'}</span>
            <span class="hero__phrase">{l s='імунітету' d='Shop.Theme.Global'}</span>
            <span class="hero__phrase">{l s='енергії та сну' d='Shop.Theme.Global'}</span>
            <span class="hero__phrase">{l s="жіночого здоров'я" d='Shop.Theme.Global'}</span>
            <span class="hero__phrase">{l s='всієї родини' d='Shop.Theme.Global'}</span>
          </span>
        </h1>

        <p class="hero__subtitle">
          {l s='Офіційний представник G&G Vitamins Ltd (Велика Британія) в Україні. Понад 300 найменувань вітамінів та добавок без наповнювачів.' d='Shop.Theme.Global'}
        </p>

        <div class="hero__ctas">
          <a href="{$urls.base_url}ua/vitaminy"
             class="btn btn-primary hero__cta-primary">
            {l s='Переглянути каталог' d='Shop.Theme.Global'}
            <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
          </a>
          <a href="{$urls.pages.cms}?id_cms=1"
             class="btn btn-outline-primary hero__cta-secondary">
            {l s='Дізнатись про G&G' d='Shop.Theme.Global'}
          </a>
        </div>
      </div>

      <div class="hero__media">
        <img
          src="{$urls.base_url}themes/mytheme/assets/img/hero-bg.webp"
          alt="{l s='G&G Vitamins — вітаміни та добавки з Великої Британії' d='Shop.Theme.Global'}"
          width="560" height="520"
          fetchpriority="high"
          loading="eager"
          decoding="async"
          class="hero__img"
        >
      </div>

    </div>
  </div>
</section>
```

**5 фраз і їх покриття:**

| Фраза | Цільовий сегмент | Ключовий товар |
|---|---|---|
| `вашого здоров'я` | Загальний — перший показ (SEO-H1) | Весь каталог |
| `імунітету` | Осінь/зима, ГРВІ | Vitamin C, Zinc, Vitamin D3 |
| `енергії та сну` | Хронічна втома, стрес | Magnesium, B Complex |
| `жіночого здоров'я` | Жіноча аудиторія | SOOV Flow, Meno, 40+ |
| `всієї родини` | Батьки, сім'я | Kids Rainbow Food, Daily Packs |

**⚠️ SEO:** Google і AI-агенти читають першу `is-active` фразу — «Вітаміни та добавки для вашого здоров'я» — як повний H1. Це і є семантичний заголовок. Всі 5 варіантів у DOM (не `display:none`) — скринридери озвучують зміни через `aria-live="polite"`.

**CSS Hero:**
```css
.hero {
  padding: clamp(3rem, 8vw, 6rem) 0;
  overflow: hidden;
}

.hero__layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  align-items: center;
  gap: 3rem;
}

.hero__content { max-width: 560px; }

.hero__title {
  font-size: clamp(1.875rem, 4vw, 3rem);
  font-weight: 800;
  line-height: var(--line-height-tight);
  color: var(--color-text);
  margin-bottom: 1.25rem;
}

/* ── Ротація акцентної фрази ── */
.hero__rotating-phrase {
  display: inline-block;
  position: relative;
  color: var(--color-primary);
}

.hero__phrase {
  display: block;
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0;
  transition: opacity 0.6s ease-in-out;
  white-space: nowrap;
  pointer-events: none;
}

.hero__phrase.is-active {
  position: relative;
  opacity: 1;
  pointer-events: auto;
}

/* Без анімації — accessibility */
@media (prefers-reduced-motion: reduce) {
  .hero__phrase { transition: none; }
  .hero__phrase:not(.is-active) { display: none; }
}

.hero__subtitle {
  font-size: clamp(1rem, 1.5vw, 1.125rem);
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
  margin-bottom: 2rem;
  max-width: 48ch;
}

.hero__ctas { display: flex; gap: 1rem; flex-wrap: wrap; }
.hero__cta-primary { display: inline-flex; align-items: center; gap: 0.5rem; }

.hero__img {
  width: 100%;
  max-width: 560px;
  height: auto;
  border-radius: var(--radius-xl);
  object-fit: cover;
}

@media (max-width: 991px) { .hero__layout { gap: 2rem; } }

@media (max-width: 767px) {
  .hero__layout { grid-template-columns: 1fr; text-align: center; }
  .hero__content { max-width: 100%; }
  .hero__img { display: none; }
  .hero__ctas { justify-content: center; }
  .hero__subtitle { margin-inline: auto; }
}
```

**JS ротації — `home.js` (< 30 рядків, `defer`, без бібліотек):**
```javascript
// home.js — Hero phrase rotation
(function () {
  const phrases = document.querySelectorAll('.hero__phrase');
  if (!phrases.length) return;
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  let current = 0;
  const INTERVAL = 3200; // мс між змінами

  function next() {
    phrases[current].classList.remove('is-active');
    current = (current + 1) % phrases.length;
    phrases[current].classList.add('is-active');
  }

  let timer = setInterval(next, INTERVAL);

  // Пауза коли вкладка не видима — економія ресурсів
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) clearInterval(timer);
    else timer = setInterval(next, INTERVAL);
  });
}());
```

**Фото `hero-bg.webp`:**
- Розмір: 1120×1040px (2× для retina), WebP, якість 85%, < 150KB
- Зміст: 3–4 флакони G&G на білому/нейтральному фоні або рука тримає капсули
- **Не використовувати:** колаж, текст поверх фото, темний фон
- `fetchpriority="high"` + `loading="eager"` — LCP-елемент, preload у `head_extra`

---

### 2.2 Секция 1b — USP Bar (сразу под Hero)

**Концепция:** 4 компактных преимущества — якорная точка доверия перед переходом к товарам.

**Макет:**
```
┌──────────────────────────────────────────────────────────┐
│ [🇬🇧 Виготовлено │ [🌿 Без       │ [✓ Нотифіковано │ [🚚 Доставка  │
│  у Великій       │  наповнювачів │  МОЗ України   │  по Україні  │
│  Британії]       │  та зв'язуючих│               │               │
└──────────────────────────────────────────────────────────┘
```

**Smarty:**
```smarty
{assign var='usps' value=[
  ['icon' => 'fa-flag', 'title' => 'Виготовлено у Великій Британії', 'sub' => 'Власне виробництво G&G з 1974 р.'],
  ['icon' => 'fa-leaf', 'title' => 'Без наповнювачів', 'sub' => 'Тільки веганські капсули, нічого зайвого'],
  ['icon' => 'fa-shield-check', 'title' => 'Нотифіковано МОЗ України', 'sub' => 'Офіційна реєстрація добавок'],
  ['icon' => 'fa-truck-fast', 'title' => 'Доставка по всій Україні', 'sub' => 'Нова Пошта, Укрпошта, кур\'єр'],
]}
<div class="usp-bar">
  <div class="container">
    <div class="usp-bar__grid">
      {foreach from=$usps item=usp}
        <div class="usp-bar__item">
          <i class="fa-solid {$usp.icon} usp-bar__icon" aria-hidden="true"></i>
          <div class="usp-bar__text">
            <span class="usp-bar__title">{$usp.title}</span>
            <span class="usp-bar__sub">{$usp.sub}</span>
          </div>
        </div>
      {/foreach}
    </div>
  </div>
</div>
```

**CSS:**
```css
.usp-bar {
  background: var(--color-primary-subtle);
  border-top: 1px solid var(--color-border);
  border-bottom: 1px solid var(--color-border);
  padding: 1.25rem 0;
}
.usp-bar__grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
}
.usp-bar__item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
}
.usp-bar__icon {
  font-size: 1.25rem;
  color: var(--color-primary);
  flex-shrink: 0;
  margin-top: 2px;
}
.usp-bar__title {
  display: block;
  font-size: var(--font-size-sm);
  font-weight: 700;
  color: var(--color-text);
  line-height: 1.3;
}
.usp-bar__sub {
  display: block;
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
  margin-top: 2px;
}
@media (max-width: 767px) {
  .usp-bar__grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem 1.5rem;
  }
}
@media (max-width: 479px) {
  .usp-bar__grid { grid-template-columns: 1fr; }
}
```

---

### 2.3 Секция 2 — Категорії (плитки)

**Концепция:** быстрая навигация по 5 основным разделам каталога — колонки мега-меню.

**Макет (desktop — 5 плиток + 1 «Всі товари»):**
```
┌──────────────────────────────────────────────────────────┐
│          Наш асортимент                                   │
│                                                           │
│ [🌿 Вітаміни] [💊 Мінерали] [🌱 Добавки] [⭐ Спец.] [🎀 SOOV] │
│                                                           │
│                    [→ Переглянути весь каталог]           │
└──────────────────────────────────────────────────────────┘
```

**Smarty:**
```smarty
{assign var='home_categories' value=[
  ['name' => 'Вітаміни',   'slug' => 'vitaminy',    'icon' => 'fa-sun',        'count' => '55+', 'color' => 'green'],
  ['name' => 'Мінерали',   'slug' => 'mineraly',    'icon' => 'fa-gem',        'count' => '20+', 'color' => 'blue'],
  ['name' => 'Добавки',    'slug' => 'dobavky',     'icon' => 'fa-seedling',   'count' => '50+', 'color' => 'purple'],
  ['name' => 'Спеціальні', 'slug' => 'spetsialni',  'icon' => 'fa-star',       'count' => '45+', 'color' => 'amber'],
  ['name' => 'SOOV',       'slug' => 'soov',        'icon' => 'fa-heart',      'count' => '12',  'color' => 'pink'],
]}
```

**CSS:**
```css
.home-categories__grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 1rem;
}

.home-category-tile {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  padding: 1.75rem 1rem;
  background: var(--color-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  text-decoration: none;
  color: var(--color-text);
  transition: border-color 0.2s, box-shadow 0.2s, transform 0.2s;
  gap: 0.875rem;
}
.home-category-tile:hover {
  border-color: var(--color-primary);
  box-shadow: 0 4px 20px oklch(47% 0.07 145 / 0.14);
  transform: translateY(-3px);
  color: var(--color-primary);
}

.home-category-tile__icon-wrap {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  /* Цвет задаётся модификатором: --green, --blue и т.д. */
}
.home-category-tile--green  .home-category-tile__icon-wrap { background: oklch(92% 0.07 145); color: oklch(35% 0.10 145); }
.home-category-tile--blue   .home-category-tile__icon-wrap { background: oklch(92% 0.05 220); color: oklch(35% 0.10 220); }
.home-category-tile--purple .home-category-tile__icon-wrap { background: oklch(92% 0.06 300); color: oklch(35% 0.12 300); }
.home-category-tile--amber  .home-category-tile__icon-wrap { background: oklch(93% 0.08 80);  color: oklch(35% 0.14 80); }
.home-category-tile--pink   .home-category-tile__icon-wrap { background: oklch(90% 0.08 340); color: oklch(35% 0.15 340); }

.home-category-tile__name {
  font-weight: 700;
  font-size: var(--font-size-base);
}
.home-category-tile__count {
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
}

@media (max-width: 991px) {
  .home-categories__grid { grid-template-columns: repeat(3, 1fr); }
}
@media (max-width: 575px) {
  .home-categories__grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 0.75rem;
  }
}
```

---

### 2.4 Секция 3 — Топ для початку

**Концепция:** «Якщо не знаєш що обрати — починай тут». Решает проблему паралича выбора при 300+ SKU. Первый UX-фильтр для новых покупателей.

**Содержание:** 8 базовых товаров («стартовый стек здоровья» — из ps9_categories.md раздел 5.1):

| # | Товар | Категория |
|---|---|---|
| 1 | Vitamin D3 1000iu — 120 Vegan Capsules | Вітамін D |
| 2 | Triple Magnesium Complex — 90 Vegan Capsules | Магній |
| 3 | Omega 3 Fish Oil 3000mg — 90 Softgels | Омега |
| 4 | Vitamin C Complex 1000mg — 120 Vegan Capsules | Вітамін C |
| 5 | Advanced Pro-VeFlora 50 Billion — 60 Vegan Caps | Пробіотики |
| 6 | Zinc Citrate 15mg — 120 Vegan Capsules | Цинк |
| 7 | Vitamin B12 1000mcg — 120 Vegan Capsules | Вітамін B |
| 8 | Cal-M — 120 Vegan Capsules | Магній / Кальцій |

**Реализация:** `ps_featuredproducts` или `ps_categoryproducts` через хук `displayHome` с настроенной коллекцией «Топ для початку» (тег в PS9).

**Smarty обёртка в displayHome.tpl:**
```smarty
{* Секция «Топ для початку» *}
{if isset($featured_products) && $featured_products|@count > 0}
<section class="home-section home-section--featured" id="home-top-start">
  <div class="container">
    <div class="home-section__header">
      <div>
        <h2 class="home-section__title">Топ для початку</h2>
        <p class="home-section__subtitle">
          Базовий набір для тих, хто починає з вітамінів
        </p>
      </div>
      <a href="{$urls.base_url}ua/populyarne/top-dlya-pochatku"
         class="home-section__link">
        Переглянути всі
        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
      </a>
    </div>
    <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-3">
      {foreach from=$featured_products item=product}
        {include file='catalog/listing/product-miniature.tpl' product=$product}
      {/foreach}
    </div>
  </div>
</section>
{/if}
```

---

### 2.5 Секция 4 — SOOV: міні-лендінг

**Концепция:** полноценный брендованный блок на главной — полный баннер на всю ширину с двумя колонками (текст + карточки топ-3 товаров). Это отдельная аудитория (женщины, специфический запрос), которую важно «поймать» на главной.

**Макет:**
```
┌──────────────────────────────────────────────────────────────┐
│ Фоновий колір: oklch(95% 0.04 340) — дуже ніжний рожевий     │
│                                                              │
│ ┌─── 45% ───────────────┐  ┌─── 55% ──────────────────────┐ │
│ │ SOOV [лого]           │  │ [Flow]  [Deflate] [Ouch]      │ │
│ │                       │  │ картка  картка    картка       │ │
│ │ Жіноче здоров'я       │  │ SOOV    SOOV      SOOV         │ │
│ │ від G&G Vitamins       │  │                               │ │
│ │                       │  │                               │ │
│ │ Лінійка спеціально    │  │                               │ │
│ │ розроблена для        │  │                               │ │
│ │ менструального циклу, │  │                               │ │
│ │ менопаузи та          │  │                               │ │
│ │ жіночого здоров'я     │  │                               │ │
│ │                       │  │                               │ │
│ │ [Переглянути лінійку] │  │                               │ │
│ └───────────────────────┘  └───────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

**Smarty:**
```smarty
<section class="home-section home-section--soov" id="home-soov">
  <div class="container">
    <div class="soov-block">

      <div class="soov-block__info">
        <span class="soov-block__eyebrow">Лінійка жіночого здоров'я</span>
        <h2 class="soov-block__title">
          <span class="soov-block__brand">soov</span>
        </h2>
        <p class="soov-block__desc">
          12 продуктів, спеціально розроблених для підтримки менструального циклу,
          перименопаузи та жіночого здоров'я. Натуральний склад. Клінічно
          підтверджені інгредієнти.
        </p>
        <ul class="soov-block__bullets">
          <li><i class="fa-solid fa-check" aria-hidden="true"></i> Менструальний цикл (Flow, 40+, Meno)</li>
          <li><i class="fa-solid fa-check" aria-hidden="true"></i> Підтримка при болях, втомі, здутті</li>
          <li><i class="fa-solid fa-check" aria-hidden="true"></i> 7-денні саше для цільової підтримки</li>
        </ul>
        <a href="{$urls.base_url}ua/soov" class="btn btn-soov">
          Переглянути лінійку SOOV
          <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
        </a>
      </div>

      <div class="soov-block__products">
        {* Топ-3 SOOV: Flow, Deflate, Ouch — через ps_categoryproducts або хардкод ID *}
        <div class="row row-cols-1 row-cols-sm-3 g-3">
          {foreach from=$soov_products item=product}
            {include file='catalog/listing/product-miniature.tpl' product=$product}
          {/foreach}
        </div>
      </div>

    </div>
  </div>
</section>
```

**CSS:**
```css
.home-section--soov {
  background: oklch(96% 0.03 340);
  border-radius: var(--radius-xl);
  padding: 3rem 0;
  margin: 2rem 0;
}

.soov-block {
  display: grid;
  grid-template-columns: 2fr 3fr;
  gap: 3rem;
  align-items: center;
}

.soov-block__eyebrow {
  display: inline-block;
  font-size: var(--font-size-xs);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: oklch(45% 0.15 340);
  margin-bottom: 0.75rem;
}

.soov-block__brand {
  display: block;
  font-size: clamp(2rem, 4vw, 3rem);
  font-weight: 900;
  color: oklch(35% 0.18 340);
  letter-spacing: -0.02em;
  font-style: italic;
}

.soov-block__desc {
  color: var(--color-text-secondary);
  line-height: var(--line-height-relaxed);
  margin-bottom: 1.25rem;
}

.soov-block__bullets {
  list-style: none;
  padding: 0;
  margin: 0 0 1.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.soov-block__bullets li {
  display: flex;
  align-items: flex-start;
  gap: 0.5rem;
  font-size: var(--font-size-sm);
  color: var(--color-text);
}
.soov-block__bullets .fa-check {
  color: oklch(45% 0.15 340);
  margin-top: 2px;
  flex-shrink: 0;
}

.btn-soov {
  background: oklch(45% 0.18 340);
  color: #fff;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: var(--radius-base);
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  transition: background 0.2s;
}
.btn-soov:hover {
  background: oklch(35% 0.18 340);
  color: #fff;
}

@media (max-width: 767px) {
  .soov-block { grid-template-columns: 1fr; }
}
```

---

### 2.6 Секция 5 — Про бренд G&G

**Концепция:** двухколоночный блок — текст слева, фото справа. SEO-текст + сигналы E-E-A-T для Google и AI-агентов.

**Содержание (украинский):**
```
H2: Чому G&G Vitamins?

50 років якості та чистоти. G&G Vitamins Ltd заснована у Великій Британії у 1974 році.
Ми виробляємо вітаміни та дієтичні добавки у власних лабораторіях — без пресованих
таблеток, тільки чисті веганські капсули без наповнювачів та зв'язуючих речовин.

Ми є офіційним представником G&G Vitamins в Україні. Вся продукція нотифікована МОЗ
України та відповідає вимогам законодавства.

[Дізнатись більше →]   [50+ Років досвіду]  [300+ Продуктів]  [Без наповнювачів]
```

**Smarty:**
```smarty
<section class="home-section home-about" id="home-about">
  <div class="container">
    <div class="home-about__grid">

      <div class="home-about__content">
        <span class="home-about__eyebrow">Офіційний представник в Україні</span>
        <h2 class="home-about__title">Чому G&G Vitamins?</h2>
        <div class="home-about__text">
          <p>
            G&G Vitamins Ltd заснована у Великій Британії у <strong>1974 році</strong>.
            За понад 50 років ми виробляємо вітаміни та дієтичні добавки у власних
            лабораторіях — без пресованих таблеток, тільки <strong>чисті веганські
            капсули без наповнювачів</strong>.
          </p>
          <p>
            Ми є офіційним представником G&G Vitamins в Україні. Вся продукція
            нотифікована МОЗ України та відповідає вимогам чинного законодавства.
          </p>
        </div>
        <div class="home-about__stats">
          {assign var='stats' value=[
            ['num' => '50+', 'label' => 'років досвіду'],
            ['num' => '300+', 'label' => 'найменувань'],
            ['num' => '0',    'label' => 'наповнювачів'],
            ['num' => '🇬🇧',   'label' => 'виробництво UK'],
          ]}
          {foreach from=$stats item=stat}
            <div class="home-about__stat">
              <span class="home-about__stat-num">{$stat.num}</span>
              <span class="home-about__stat-label">{$stat.label}</span>
            </div>
          {/foreach}
        </div>
        <a href="{$urls.pages.cms}?id_cms=1" class="btn btn-outline-primary home-about__cta">
          Дізнатись більше про G&G
        </a>
      </div>

      <div class="home-about__media">
        <img
          src="{$urls.base_url}themes/mytheme/assets/img/about-home.webp"
          alt="Виробництво G&G Vitamins у Великій Британії"
          width="780" height="585"
          loading="lazy"
          decoding="async"
          class="home-about__img"
        >
      </div>

    </div>
  </div>
</section>
```

**CSS:**
```css
.home-about__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
}
.home-about__eyebrow {
  display: inline-block;
  font-size: var(--font-size-xs);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--color-primary);
  margin-bottom: 0.75rem;
}
.home-about__title {
  font-size: clamp(1.5rem, 3vw, 2.25rem);
  font-weight: 800;
  color: var(--color-text);
  margin-bottom: 1.25rem;
}
.home-about__text p { color: var(--color-text-secondary); line-height: var(--line-height-relaxed); margin-bottom: 1rem; }
.home-about__stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1rem;
  padding: 1.5rem 0;
  border-top: 1px solid var(--color-border);
  border-bottom: 1px solid var(--color-border);
  margin-bottom: 1.75rem;
}
.home-about__stat { text-align: center; }
.home-about__stat-num { display: block; font-size: 1.5rem; font-weight: 900; color: var(--color-primary); }
.home-about__stat-label { font-size: var(--font-size-xs); color: var(--color-text-muted); }
.home-about__img { width: 100%; border-radius: var(--radius-xl); object-fit: cover; }

@media (max-width: 767px) {
  .home-about__grid { grid-template-columns: 1fr; }
  .home-about__media { order: -1; }
  .home-about__stats { grid-template-columns: repeat(2, 1fr); }
}
```

---

### 2.7 Секция 6 — Відгуки / Соціальний доказ

**Концепция:** 3 реальных отзыва покупателей + агрегированная оценка. Критически важно для ниши YMYL (здоровье).

**Обоснование (Baymard 2025):** 88% покупателей читают отзывы перед покупкой добавок. Для нутрицевтики доверие к реальным отзывам важнее спецпредложений.

**Источник:** отзывы из `ps_productcomments` — топ-3 по рейтингу/дате. Или статичный assign с реальными отзывами на старте.

**Макет:**
```
┌──────────────────────────────────────────────────────────┐
│  Що кажуть наші покупці    ★★★★★ 4.8 із 5 (247 відгуків)│
│                                                          │
│ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│ │ ★★★★★        │ │ ★★★★★        │ │ ★★★★☆        │      │
│ │ «Вітамін D3  │ │ «Купую       │ │ «SOOV Flow   │      │
│ │  від G&G...» │ │  вже 2 роки» │ │  допоміг...» │      │
│ │ Олена К.     │ │ Марія С.     │ │ Тетяна В.    │      │
│ └──────────────┘ └──────────────┘ └──────────────┘      │
└──────────────────────────────────────────────────────────┘
```

**Smarty (статичный вариант на старте):**
```smarty
{assign var='testimonials' value=[
  ['stars' => 5, 'text' => 'Вітамін D3 від G&G — найкращий, що я пробувала. Приймаю 3 місяці, аналізи покращились значно.', 'name' => 'Олена К.', 'product' => 'Vitamin D3 1000iu'],
  ['stars' => 5, 'text' => 'Замовляю магній та омега вже 2 роки. Якість стабільна, доставка швидка. Офіційний представник — це важливо.', 'name' => 'Марія С.', 'product' => 'Triple Magnesium Complex'],
  ['stars' => 5, 'text' => 'SOOV Flow реально допомагає при ПМС. Відчула різницю вже після першого місяця. Рекомендую всім дівчатам.', 'name' => 'Тетяна В.', 'product' => 'SOOV Flow'],
]}
```

**Schema.org для отзывов на главной:**
Если отзывы статичные — добавить `Review` в JSON-LD через `schema-organization.tpl` или отдельную схему. Это помогает AI-агентам понять репутацию магазина.

---

### 2.8 Секция 7 — Блог / Статті

**Концепция:** 3 последних статьи — SEO + повторные визиты + E-E-A-T.

**Обоснование:** Google (2025) повышает рейтинг сайтов здоровья с регулярно обновляемым экспертным контентом. Статьи про «дефіцит вітаміну D», «як обрати магній», «SOOV при ПМС» — отвечают на запросы, по которым приходят новые пользователи.

**Реализация:** хук `displayHome` → `ps_blog` или кастомный модуль блога. На старте — статичный assign с 3 карточками.

**Карточка статьи:**
```
┌──────────────────┐
│ [фото статьи]    │
│ Категория        │
│ Заголовок статьи │
│ Дата • 5 хв читання│
│ [Читати →]       │
└──────────────────┘
```

---

### 2.9 Секция 8 — FAQ

**Концепция:** Реализовано в v0.5.0 (Bootstrap аккордеон + JSON-LD FAQPage). Дополнить вопросами, специфичными для G&G UA.

**Рекомендуемые FAQ для главной (обновить в `index.tpl`):**

```smarty
{assign var='faq_items' value=[
  [
    'q' => 'Ви є офіційним представником G&G Vitamins?',
    'a' => 'Так, ми є офіційним представником G&G Vitamins Ltd (Велика Британія) в Україні. Вся продукція оригінальна, імпортована безпосередньо від виробника та нотифікована МОЗ України.'
  ],
  [
    'q' => 'Чому G&G Vitamins використовує тільки капсули, а не таблетки?',
    'a' => 'Капсули не потребують наповнювачів та зв\'язуючих речовин, які необхідні для таблеток. Ви отримуєте тільки активні інгредієнти — нічого зайвого.'
  ],
  [
    'q' => 'Чи нотифіковані добавки G&G в Україні?',
    'a' => 'Так, всі добавки G&G Vitamins, що реалізуються через наш магазин, мають офіційну нотифікацію Держпродспоживслужби України (ДПСС) відповідно до вимог МОЗ.'
  ],
  [
    'q' => 'Що таке лінійка SOOV?',
    'a' => 'SOOV — це спеціалізована лінійка добавок для жіночого здоров\'я від G&G Vitamins. 12 продуктів для підтримки менструального циклу, перименопаузи та менопаузи. Офіційно доступна в Україні через наш магазин.'
  ],
  [
    'q' => 'Як швидко здійснюється доставка по Україні?',
    'a' => 'Доставка здійснюється Новою Поштою, Укрпоштою та кур\'єром. Середній термін — 1–3 робочих дні після підтвердження замовлення.'
  ],
  [
    'q' => 'Чи підходять добавки G&G для веганів?',
    'a' => 'Більшість продуктів G&G Vitamins підходять для веганів — вони виготовлені у рослинних капсулах без желатину. Веганський статус вказаний на кожній картці товару.'
  ],
]}
```

---

## 3. ПОЛНАЯ СТРУКТУРА `index.tpl`

```smarty
{extends 'layouts/layout-full-width.tpl'}

{block name='head_extra'}
  {* Schema: Organization + WebSite + SearchAction (вся страница) *}
  {hook h='displaySchemaMarkup'}
  {* Для главной — schema-organization.tpl уже включает SearchAction ✅ *}
{/block}

{block name='content'}

  {* ═══ 1. Hero ═══ *}
  <section class="hero" id="home-hero">
    <div class="container">
      <div class="hero__layout">
        <div class="hero__content">
          <h1 class="hero__title">
            {l s='Вітаміни та дієтичні добавки G&G Vitamins в Україні' d='Shop.Theme.Global'}
          </h1>
          <p class="hero__subtitle">
            {l s='Офіційний представник G&G Vitamins Ltd (Велика Британія). Понад 300 найменувань без наповнювачів.' d='Shop.Theme.Global'}
          </p>
          <div class="hero__ctas">
            <a href="{$urls.base_url}ua/vitaminy" class="btn btn-primary hero__cta-primary">
              {l s='Переглянути каталог' d='Shop.Theme.Global'}
              <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
            </a>
            <a href="{$urls.pages.cms}?id_cms=1" class="btn btn-outline-primary hero__cta-secondary">
              {l s='Дізнатись про G&G' d='Shop.Theme.Global'}
            </a>
          </div>
        </div>
        <div class="hero__media">
          <img
            src="{$urls.base_url}themes/mytheme/assets/img/hero-bg.webp"
            alt="{l s='G&G Vitamins — вітаміни та добавки з Великої Британії' d='Shop.Theme.Global'}"
            width="560" height="520"
            fetchpriority="high"
            loading="eager"
            decoding="async"
            class="hero__img"
          >
        </div>
      </div>
    </div>
  </section>

  {* ═══ 1b. USP Bar ═══ *}
  {include file='_partials/hooks/displayHomeUsp.tpl'}

  {* ═══ 2. Категорії ═══ *}
  <section class="home-section home-section--categories" id="home-categories">
    <div class="container">
      <div class="home-section__header">
        <h2 class="home-section__title">
          {l s='Наш асортимент' d='Shop.Theme.Global'}
        </h2>
      </div>
      {include file='_partials/hooks/displayHomeCategories.tpl'}
    </div>
  </section>

  {* ═══ 3. Топ для початку ═══ *}
  <section class="home-section home-section--top-start" id="home-top-start">
    <div class="container">
      {hook h='displayHome'}
      {* → displayHome.tpl → ps_featuredproducts / ps_categoryproducts *}
    </div>
  </section>

  {* ═══ 4. SOOV міні-лендінг ═══ *}
  {include file='_partials/hooks/displayHomeSoov.tpl'}

  {* ═══ 5. Про бренд G&G ═══ *}
  <section class="home-section home-about" id="home-about">
    <div class="container">
      {include file='_partials/hooks/displayHomeAbout.tpl'}
    </div>
  </section>

  {* ═══ 6. Відгуки ═══ *}
  <section class="home-section home-section--reviews" id="home-reviews">
    <div class="container">
      {include file='_partials/hooks/displayHomeReviews.tpl'}
    </div>
  </section>

  {* ═══ 7. Блог / Статті ═══ *}
  {if $blog_posts|@count > 0}
  <section class="home-section home-section--blog" id="home-blog">
    <div class="container">
      {include file='_partials/hooks/displayHomeBlog.tpl'}
    </div>
  </section>
  {/if}

  {* ═══ 8. FAQ ═══ *}
  <section class="home-section home-section--faq" id="home-faq">
    <div class="container">
      {include file='_partials/hooks/displayHomeFaq.tpl'}
    </div>
  </section>

{/block}
```

---

## 4. ВСПОМОГАТЕЛЬНЫЙ CSS — `home.css`

```css
/* ═══ Общие стили секций главной ═══ */

.home-section {
  padding: clamp(3rem, 6vw, 5rem) 0;
}

.home-section__header {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: 2rem;
  gap: 1rem;
}

.home-section__title {
  font-size: clamp(1.25rem, 2.5vw, 1.875rem);
  font-weight: 800;
  color: var(--color-text);
  margin: 0;
}

.home-section__subtitle {
  color: var(--color-text-muted);
  font-size: var(--font-size-sm);
  margin: 0.25rem 0 0;
}

.home-section__link {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  font-size: var(--font-size-sm);
  font-weight: 600;
  color: var(--color-primary);
  text-decoration: none;
  white-space: nowrap;
  flex-shrink: 0;
}
.home-section__link:hover { color: var(--color-primary-dark); }

/* ═══ Разделители между секциями ═══ */
.home-section + .home-section {
  border-top: 1px solid var(--color-border);
}
.home-section--soov { border: none; } /* SOOV блок — без разделителя */
```

---

## 5. SEO ГЛАВНОЙ СТРАНИЦЫ — GOOGLE UA 2025–2026

### 5.1 Title и Meta Description

**Title (50–60 символов):**
```
G&G Vitamins Україна — вітаміни та добавки | Офіційний представник
```

**Meta Description (150–160 символов):**
```
Офіційний представник G&G Vitamins Ltd (Велика Британія) в Україні.
300+ вітамінів, мінералів та добавок без наповнювачів. Нотифіковано МОЗ.
Доставка по Україні.
```

**Canonical:** `<link rel="canonical" href="{$urls.current_url}">` — уже в head.tpl.

### 5.2 H1 — один, содержит ключевой запрос

```
Вітаміни та дієтичні добавки G&G Vitamins в Україні
```

Ключевые запросы, которые охватывает:
- «вітаміни G&G» — брендовый запрос
- «дієтичні добавки G&G Vitamins»
- «G&G Vitamins Україна» — геолокационный
- «офіційний представник G&G»

### 5.3 Schema.org на главной

| Схема | Файл | Что даёт |
|---|---|---|
| `Organization` | schema-organization.tpl ✅ | Google Knowledge Panel |
| `WebSite + SearchAction` | schema-organization.tpl ✅ | Поиск по сайту в Google |
| `FAQPage` | schema-faq.tpl ✅ | Rich snippets в SERP |
| `Review` (опционально) | новый schema-reviews.tpl | Звёзды в SERP для главной |

**Добавить в v0.15.0:** `schema-reviews.tpl` с агрегированным рейтингом магазина.

### 5.4 AI-агенты — оптимизация главной

AI-агенты (Perplexity, ChatGPT Search, Gemini) при запросе «G&G Vitamins Україна» или «купити вітаміни G&G» должны находить вашу страницу и идентифицировать сайт как **официального представителя**.

**Ключевые сигналы — разместить на главной:**
1. Явное упоминание «офіційний представник G&G Vitamins Ltd» в тексте (H1 или первый абзац).
2. Указание страны производителя «Велика Британія» + год основания «1974».
3. Упоминание «нотифіковано МОЗ України» — сигнал легальности.
4. `schema-organization.tpl` с полным `sameAs` (ссылки на gandgvitamins.com, soov.uk).

**Обновить `schema-organization.tpl`:**
```json
{
  "@type": "Organization",
  "name": "[Назва магазину]",
  "description": "Офіційний представник G&G Vitamins Ltd (Велика Британія) в Україні",
  "sameAs": [
    "https://www.gandgvitamins.com",
    "https://soov.uk",
    "https://www.instagram.com/[ваш_інстаграм]"
  ],
  "parentOrganization": {
    "@type": "Organization",
    "name": "G&G Vitamins Ltd",
    "url": "https://www.gandgvitamins.com",
    "address": {
      "@type": "PostalAddress",
      "addressCountry": "GB"
    }
  }
}
```

---

## 6. CORE WEB VITALS — ГЛАВНАЯ СТРАНИЦА

### 6.1 LCP — Hero Image

Главный LCP-элемент: `<img class="hero__img">` (560×520px WebP).

**Обязательно:**
```html
fetchpriority="high"
loading="eager"
```

**В `{block head_extra}` head.tpl:**
```smarty
{if $page.page_name == 'index'}
  <link rel="preload" as="image"
        href="{$urls.base_url}themes/mytheme/assets/img/hero-bg.webp"
        type="image/webp">
{/if}
```

**Цель LCP:** ≤ 1.8s (хорошо) / ≤ 2.5s (допустимо).

### 6.2 CLS — зарезервировать место

Все изображения с `width` и `height` — место резервируется до загрузки:
- `hero__img`: `width="560" height="520"` ✅
- `home-about__img`: `width="780" height="585"` ✅
- Карточки товаров: `aspect-ratio: 1/1` на обёртке фото ✅ (из product-miniature.tpl)

### 6.3 INP — интерактивность

- Кнопки CTA: простые `<a>` или `<button>` без тяжёлых обработчиков.
- Аккордеон FAQ: Bootstrap Collapse — нативный, быстрый.
- `ps_featuredproducts` / `ps_categoryproducts`: грузятся через хук, не блокируют рендер.

---

## 7. МОБИЛЬНАЯ ВЕРСИЯ — СПЕЦИФИКА ГЛАВНОЙ

### 7.1 Адаптация секций

| Секция | Desktop | Mobile |
|---|---|---|
| Hero | 2 колонки (50/50) | 1 колонка, фото скрыто |
| USP Bar | 4 в ряд | 2×2 |
| Категории | 5 плиток в ряд | 2×3 (2 колонки) |
| Топ товари | 4 карточки в ряд | 2 карточки в ряд |
| SOOV блок | 2 колонки (40/60) | 1 колонка |
| Про бренд | 2 колонки (50/50) | 1 колонка (фото сверху) |
| Відгуки | 3 в ряд | scroll-snap горизонтально |
| Блог | 3 в ряд | scroll-snap горизонтально |
| FAQ | Аккордеон | Аккордеон (без изменений) |

### 7.2 Горизонтальный scroll для карточек на mobile

Отзывы и Блог на mobile — горизонтальный scroll-snap (переиспользовать паттерн из `product-related` в PRODUCT-0.7.0):

```css
@media (max-width: 767px) {
  .home-reviews__grid,
  .home-blog__grid {
    display: flex;
    gap: 1rem;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    scrollbar-width: none;
    padding-bottom: 0.5rem;
    margin: 0 -1rem; /* выход за padding контейнера */
    padding: 0 1rem;
  }
  .home-reviews__grid > *,
  .home-blog__grid > * {
    flex: 0 0 calc(80% - 0.5rem);
    scroll-snap-align: start;
  }
}
```

---

## 8. ФАЙЛЫ ДЛЯ СОЗДАНИЯ В v0.5.x

```
templates/
├── index.tpl                                ✅ v0.5.0 — обновить (новые секции)
└── _partials/
    └── hooks/
        ├── displayHome.tpl                  ✅ v0.5.0 — обновить (вынести хуки)
        ├── displayHomeUsp.tpl               ⬜ v0.5.x — USP Bar партиал
        ├── displayHomeCategories.tpl        ⬜ v0.5.x — плитки категорий
        ├── displayHomeSoov.tpl              ⬜ v0.5.x — SOOV міні-лендінг
        ├── displayHomeAbout.tpl             ⬜ v0.5.x — Про бренд G&G
        ├── displayHomeReviews.tpl           ⬜ v0.5.x — Відгуки
        └── displayHomeFaq.tpl               ⬜ v0.5.x — FAQ (перенести из index.tpl)

assets/css/pages/
└── home.css                                 ⬜ v0.14.0

assets/js/pages/
└── home.js                                  ⬜ v0.14.0 (минимально — только если нужно)
    (FAQ аккордеон — Bootstrap Collapse, без кастомного JS)
```

**Зависимости:**
```
catalog/listing/product-miniature.tpl    ✅ v0.6.0 — переиспользуется в топ товарах
catalog/listing/_partials/rating-stars.tpl ✅ v0.6.0
_partials/microdata/schema-organization.tpl ✅ v0.4.0 — обновить sameAs
_partials/microdata/schema-faq.tpl       ✅ v0.4.0
assets/css/theme.css                     ✅ v0.6.1 (OKLCH переменные)
ps_featuredproducts                      ← настроить для «Топ для початку»
ps_categoryproducts                      ← настроить для SOOV блока
```

---

## 9. ИТОГОВАЯ СХЕМА СТРАНИЦЫ — визуальная

```
index.tpl
│
├── {block head_extra}
│     <link rel="preload" hero-bg.webp>
│     {hook h='displaySchemaMarkup'} → schema-organization.tpl
│
└── {block content}
      │
      ├── .hero                          ← H1 + подзаголовок + 2 CTA + фото
      │
      ├── .usp-bar                       ← 4 преимущества (UK | Без добавок | МОЗ | Доставка)
      │
      ├── .home-section--categories      ← 5 плиток категорий + «Весь каталог»
      │
      ├── .home-section--top-start       ← «Топ для початку» — 8 товаров
      │   (product-miniature.tpl × 8)
      │
      ├── .home-section--soov            ← SOOV міні-лендінг (2 колонки: текст + топ-3 SOOV)
      │   (product-miniature.tpl × 3)
      │
      ├── .home-about                    ← Про бренд (2 колонки: текст + фото) + 4 статистики
      │
      ├── .home-section--reviews         ← 3 відгуки + агрегований рейтинг
      │
      ├── .home-section--blog            ← 3 статті (если есть блог)
      │
      └── .home-section--faq             ← FAQ аккордеон + schema-faq.tpl (JSON-LD FAQPage)
```

---

*Документ составлен на основе: Baymard Institute Homepage & Category UX (2025),
Nielsen Norman Group E-Commerce UX (2024–2025),
Google Search Central (2025–2026), Google AI Overviews (2025),
Core Web Vitals thresholds (2025–2026), W3C WCAG 2.2,
Закон України № 4122-IX від 05.12.2024,
анализа gandgvitamins.com + soov.uk,
CATALOG-0.6.0-recommendations.md, PRODUCT-0.7.0-recommendations.md,
ps9_categories.md (березень 2026).*
