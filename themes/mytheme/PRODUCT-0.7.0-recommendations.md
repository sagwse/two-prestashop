# Рекомендации по разработке карточки товара v0.7.0
## PrestaShop 9.0 — mytheme | G&G Vitamins UA
**Актуально:** март 2026 | Ниша: дієтичні добавки, вітаміни, мінерали | Ассортимент: 300+

> Документ является продолжением `CATALOG-0.6.0-recommendations.md`.
> Читать вместе с PROJECT.md и CHANGELOG.md.

---

## 1. СТРАТЕГИЧЕСКИЕ РЕШЕНИЯ (принятые до написания кода)

### 1.1 Layout страницы товара

**Решение: двухколоночный layout + вертикально раскрытые секции (Collapsed Sections).**

```
Desktop (≥992px):
┌──────────────────────────┬─────────────────────────────┐
│   Галерея (левая, 55%)   │   Покупательская панель (45%)│
│   sticky при скролле     │   название, рейтинг, варианты│
│   до начала инфо-блоков  │   цена, кнопка, доставка     │
└──────────────────────────┴─────────────────────────────┘
│              Информационные секции (full width)          │
│   [Опис] [Склад] [Застосування] [Сертифікати] [FAQ]     │
│   Вертикально раскрытые, не горизонтальные табы         │
└─────────────────────────────────────────────────────────┘
│                  Відгуки (full width)                    │
└─────────────────────────────────────────────────────────┘
│              Схожі товари (full width)                   │
└─────────────────────────────────────────────────────────┘
```

**Почему НЕ горизонтальные табы (Baymard Institute, 2025):**
- 27% пользователей полностью пропускают содержимое горизонтальных вкладок при навигации по странице товара — они не замечают сами табы.
- При тестировании вертикально раскрытых секций число пользователей, пропустивших контент, составило лишь 8% — в 3 раза меньше.
- Google может не индексировать контент, скрытый в горизонтальных табах через CSS `display:none`.
- **Для G&G критично:** покупатели БАДов активно ищут состав и способ применения — если они в табах, их пропускают.

**Мобильный layout (<992px):**
```
[Галерея — полная ширина, swipe]
[Покупательская панель]
[Информационные секции — accordion]
[Відгуки]
[Схожі товари]
[Sticky bottom bar: ціна + «До кошика»]
```

---

### 1.2 Sticky элементы

**Desktop:** галерея прилипает (`position: sticky`) при скролле вниз, пока пользователь читает описание. Когда скролл достигает начала информационных секций — галерея «отлипает» и страница скроллится как обычно.

**Mobile:** sticky bottom bar фиксирован внизу экрана. Содержит: текущая цена + кнопка «До кошика» (или «Обрати варіант»). Появляется через 200px скролла от начала страницы (JS).

**Sticky TOC (Table of Contents):** опциональный sticky-навигатор по информационным секциям на десктопе (после прокрутки мимо галереи). Реализовать в v0.7.x если понадобится.

---

## 2. ГАЛЕРЕЯ ФОТО — `product-images.tpl`

### 2.1 Навигация по галерее: рекомендация

**Решение: миниатюры слева (вертикальная колонка) на десктопе. Swipe + точки-индикаторы на мобильном.**

Обоснование:
- Nielsen Norman Group (2024): вертикальная колонка миниатюр слева — лучший pattern для 4–6 фото. Пользователи сканируют их сверху вниз, что соответствует естественному направлению взгляда.
- Миниатюры снизу (strip) занимают вертикальное пространство и конкурируют с кнопкой «До кошика» за видимость.
- Обрезанные/слишком маленькие миниатюры заставляют 50–80% пользователей пропустить дополнительные фото — миниатюры должны быть достаточно крупными чтобы было видно что на них.

**Размеры миниатюр:**
- Ширина колонки миниатюр: 80px
- Размер одной миниатюры: 72×72px
- Активная миниатюра: border 2px solid `var(--color-primary)`
- Gap между миниатюрами: 6px

**Главное фото:**
- Размер контейнера: квадрат с `aspect-ratio: 1/1` (или 4:5 для вертикальных упаковок)
- Изображение: `thickbox_default` (800×800px) или `large_default`
- `object-fit: contain` — упаковки G&G не обрезаются
- Белый фон (`var(--color-card)`)

### 2.2 Специфика для витаминов и БАДов (Baymard, 2025)

Baymard рекомендует всегда включать фото «Supplement Facts Label» (этикетка с составом) в основную галерею изображений на сайтах витаминов и добавок. Это критически важно — покупатели ищут состав именно там.

**Обязательные типы фото для каждого товара G&G:**

| № | Тип фото | Описание | Приоритет |
|---|---|---|---|
| 1 | Упаковка фронт | Главное фото, белый фон | Обязательно |
| 2 | **Supplement Facts** | Этикетка состава (вертикально, читаемо!) | Обязательно |
| 3 | Упаковка тыл | Обратная сторона упаковки | Обязательно |
| 4 | Lifestyle | Продукт в контексте использования | Желательно |
| 5 | Сертификат | Документ о соответствии (если есть) | Желательно |
| 6 | Содержимое | Фото таблеток/капсул/порошка | Желательно |

**⚠️ Критическое требование по Supplement Facts:** фото этикетки с составом должно быть снято горизонтально и в высоком разрешении — текст должен читаться без зума. Участники тестирования испытывали трудности с чтением состава, когда фото было снято боком или в низком разрешении.

### 2.3 Зум: рекомендация

**Решение: клик открывает lightbox/fullscreen. Hover-зум — опционально на десктопе.**

Обоснование:
- 67% покупателей считают качественные изображения более убедительными, чем описания товара.
- Для БАДов зум критичен — покупатель должен прочитать состав на этикетке Supplement Facts.
- Hover-зум (лупа) на десктопе: реализовать через CSS `transform: scale()` в `overflow:hidden` контейнере. Без JS-библиотек.
- Lightbox по клику: нативный `<dialog>` element (HTML5) + CSS. Без сторонних библиотек.
- На мобильном: pinch-to-zoom нативный браузерный жест на `<img>` (не блокировать через `touch-action`).

### 2.4 Размеры изображений товара

| Тип PS9 | Размер | Использование |
|---|---|---|
| `home_default` | 250×250 | Карточка в листинге mobile |
| `medium_default` | 452×452 | Карточка в листинге desktop |
| `large_default` | 800×800 | Главное фото товара (product page) |
| `thickbox_default` | 800×800 | Lightbox / зум |
| `cart_default` | 125×125 | Корзина, offcanvas cart |

**Рекомендуемый оригинал для загрузки:** 1200×1200px, WebP, качество 85–90%.
Для Supplement Facts фото: минимум 1500×1500px — текст должен читаться.

### 2.5 Мобильная галерея

- Swipe gesture (CSS scroll-snap или touch events в product.js)
- Точки-индикаторы (dots) под галереей: количество = количество фото
- Активная точка: `var(--color-primary)`, неактивная: `var(--color-border)`
- Нет миниатюр на мобильном — они слишком маленькие на узком экране
- `aspect-ratio: 1/1`, полная ширина экрана (минус padding контейнера)

---

## 3. ПОКУПАТЕЛЬСКАЯ ПАНЕЛЬ — правая колонка desktop

### 3.1 Порядок элементов (сверху вниз)

```
[1] Хлебные крошки (категория > товар)
[2] Название товара (H1)
[3] Рейтинг + счётчик отзывов (ссылка вниз на секцию)
[4] Артикул / Product Code (GA651 и т.д.)
[5] Цена (текущая + старая если скидка)
[6] Цена за единицу (если unit_price_ratio > 0)
[7] Метки доверия (Made in England, нотификация ДПСС)
[8] ─── Варианты (если есть) ───
[9] Количество + кнопка «До кошика»
[10] Wishlist + Share кнопки
[11] Доставка / наличие (краткий блок)
[12] Гарантии (иконки: возврат, оплата, поддержка)
```

### 3.2 H1 и SEO

- `<h1>` — только `$product.name`, единственный на странице
- Не содержит лишних слов типа «купити» — это анти-паттерн для нутрицевтики
- `$product.name` на украинском языке (требование закона — информация на украинском)

### 3.3 Рейтинг в покупательской панели

Ссылка `<a href="#product-reviews">` прокручивает страницу до секции отзывов. Формат: `★★★★☆ 4.2 (17 відгуків)`. При 0 отзывах — ссылка «Залишити перший відгук».

### 3.4 Артикул и Product Code

```html
<div class="product-identity">
  <span class="product-identity__reference">
    Артикул: {$product.reference}
  </span>
  <!-- Поле из PS9 — кастомный атрибут или поле reference -->
  <!-- Product Code G&G (GA651) рекомендуется хранить в reference -->
</div>
```

---

## 4. ЦЕНЫ — `product-prices.tpl`

### 4.1 Структура блока цен

```
┌─────────────────────────────────────┐
│  ~~1 200 грн~~   980 грн     -18%   │  ← старая + новая + % скидки
│  ≈ 16.33 грн за капс.               │  ← цена за единицу
└─────────────────────────────────────┘
```

**CSS:**
```css
.product-prices__current {
  font-size: clamp(1.5rem, 2.5vw, 2rem); /* крупно, заметно */
  font-weight: 800;
  color: var(--color-text);
}
.product-prices__current--discounted {
  color: var(--color-discount);
}
.product-prices__old {
  font-size: 1rem;
  font-weight: 400;
  color: var(--color-text-secondary);
  text-decoration: line-through;
  margin-right: 0.5rem;
}
.product-prices__discount-badge {
  display: inline-flex;
  align-items: center;
  padding: 2px 8px;
  background: var(--color-discount-bg);
  color: var(--color-discount);
  border: 1px solid var(--color-discount);
  border-radius: var(--radius-pill);
  font-size: 0.8125rem;
  font-weight: 700;
  margin-left: 0.5rem;
}
.product-prices__unit {
  font-size: 0.8125rem;
  color: var(--color-text-muted);
  margin-top: 4px;
  display: block;
}
```

### 4.2 Налоги

Для Украины: отображать цену с НДС. `{$product.price}` в PS9 уже включает налог если настроено в BO.

---

## 5. ВАРИАНТЫ ТОВАРА — `product-variants.tpl`

### 5.1 Рекомендация по визуальному представлению: кнопки-пилюли

**Решение: кнопки-пилюли для всех типов вариантов G&G.**

Обоснование (2025–2026):
- Baymard (2025): кнопки-пилюли показывают все доступные варианты одновременно — покупатель видит всё без раскрытия dropdown. Для 2–6 вариантов (типично для G&G: 60 капс / 120 капс / 240 капс) — оптимальный выбор.
- Выпадающий select рекомендуется только если вариантов > 8 (невозможно показать все кнопками без переполнения).
- Для G&G типичные варианты: объём (60/120/240 шт), форма (капсули/порошок), концентрація — всё это хорошо ложится в пилюли.

**Поведение кнопок-вариантов:**
- Активный вариант: `background: var(--color-primary)`, `color: #fff`, `border-color: var(--color-primary)`
- Hover: `border-color: var(--color-primary-light)`
- Недоступный вариант: `opacity: 0.45`, `cursor: not-allowed`, диагональная линия через CSS `::after`
- При выборе варианта: цена, фото и наличие обновляются через PS9 AJAX (стандартный механизм)

**Структура:**
```html
<div class="product-variants">
  <div class="product-variants__group" data-attribute-id="{$attribute.id_attribute_group}">
    <span class="product-variants__label">
      {$attribute.name}: <!-- «Кількість» / «Форма» / «Концентрація» -->
      <strong class="product-variants__selected-value" data-selected-value>
        {* JS обновляет при выборе *}
      </strong>
    </span>
    <div class="product-variants__options" role="radiogroup">
      {foreach from=$attribute.values item='value'}
        <label class="product-variants__pill
          {if $value.selected} product-variants__pill--active{/if}
          {if !$value.available} product-variants__pill--unavailable{/if}">
          <input type="radio" name="group[{$attribute.id}]"
                 value="{$value.id_attribute}" ...>
          {$value.name}
        </label>
      {/foreach}
    </div>
  </div>
</div>
```

### 5.2 Выбор варианта и обновление страницы

PS9 использует стандартный механизм: `prestashop.on('updateProduct', ...)`. При выборе варианта:
1. Обновляется цена (через AJAX)
2. Обновляется главное фото (если у варианта своё фото)
3. Обновляется наличие / кнопка
4. Обновляется URL (History API: `?id_product_attribute=N`)

### 5.3 Сообщение о выборе варианта

Если пользователь кликает «До кошика» не выбрав вариант — показать встроенное сообщение под вариантами (без alert): `<p class="product-variants__error" role="alert">` Оберіть варіант перед додаванням`</p>`. Появляется через CSS класс `.has-error`, убирается при выборе.

---

## 6. КНОПКА «ДО КОШИКА» + КІЛЬКІСТЬ — `product-add-to-cart.tpl`

### 6.1 Desktop — в потоке покупательской панели

```
┌──────────────┬─────────────────────────────────────┐
│   [ - ] 1 [ + ]   │    [  🛒  До кошика  ]         │
│   qty stepper      │    (полная ширина кнопки)      │
└──────────────┴─────────────────────────────────────┘
```

**Quantity stepper (счётчик количества):**
- Минус / поле / плюс — три элемента в строку
- Минимум: 1. Максимум: `$product.quantity` (если есть ограничение)
- Поле ввода: `type="number"`, `min="1"`, `inputmode="numeric"` (мобильная клавиатура с цифрами)
- Ширина поля: 48px (достаточно для 3 цифр)
- Touch targets кнопок − и +: min 44×44px

**Кнопка «До кошика»:**
- `data-button-action="add-to-cart"` — стандартный PS9 атрибут
- Высота: 52px (крупнее чем в листинге, это главный CTA страницы)
- Иконка: `fa-cart-plus` + текст
- После успешного добавления: кратковременная смена текста «✓ Додано до кошика» на 2s

### 6.2 Mobile — sticky bottom bar

**Фиксированная панель внизу экрана:**

```
┌─────────────────────────────────────────────────────┐
│   980 грн    │          До кошика                   │
│  (текущая)   │          (70% ширины)                │
└─────────────────────────────────────────────────────┘
       ↑ safe-area-inset-bottom (iPhone notch)
```

**CSS:**
```css
.product-sticky-bar {
  position: fixed;
  left: 0;
  right: 0;
  z-index: 1025; /* ниже mobile-bottom-nav (1030) — bar НАД контентом, НО ПОД навигацией */
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  background: var(--color-card);
  border-top: 1px solid var(--color-border);
  box-shadow: 0 -2px 12px oklch(22% 0.02 145 / 0.10);

  /* ⚠️ КРИТИЧНО: позиционируем НАД mobile-bottom-nav (60px + safe-area),
     а не bottom: 0. Иначе sticky bar перекроет навигационный bar темы.
     --mobile-bottom-nav-height = 60px (из theme.css :root).
     env(safe-area-inset-bottom) — iPhone notch (уже учтён в mobile-bottom-nav). */
  bottom: calc(var(--mobile-bottom-nav-height) + env(safe-area-inset-bottom));
}

/* На десктопе ≥992px — bottom nav bar скрыт, sticky bar может быть bottom: 0 */
@media (min-width: 992px) {
  .product-sticky-bar {
    bottom: 0;
    padding-bottom: 0.75rem;
  }
}
```

**⚠️ Конфликт с mobile-bottom-nav — решение:**
- `mobile-bottom-nav` в `theme.css`: `position: fixed; bottom: 0; z-index: 1030`
- `product-sticky-bar`: `bottom: calc(var(--mobile-bottom-nav-height) + env(safe-area-inset-bottom)); z-index: 1025`
- Итог: sticky bar отображается **над контентом страницы**, но **под** навигационным баром — оба видны, не перекрывают друг друга.
- На десктопе (≥992px): `mobile-bottom-nav` скрыт (`d-lg-none`), sticky bar переключается на `bottom: 0`.

**Появление sticky bar:** JS добавляет класс `.is-visible` когда пользователь скроллит мимо основной кнопки «До кошика» (IntersectionObserver на `#product-add-to-cart-form`).

---

## 7. ИНФОРМАЦИОННЫЕ БЛОКИ — структура и порядок

### 7.1 Рекомендуемый порядок секций

| № | Секция | Источник данных | Приоритет |
|---|---|---|---|
| 1 | **Опис** | `$product.description` (PS9) | Обязательно |
| 2 | **Склад та харчова цінність** | `$product.description_short` или кастомный атрибут | Обязательно |
| 3 | **Спосіб застосування та дозування** | Кастомный атрибут или в описании | Обязательно |
| 4 | **Обов'язкові застереження** | Статичный блок (закон) | Обязательно ⚠️ |
| 5 | **Деталі та характеристики** | `$product.features[]` | Обязательно |
| 6 | **Сертифікати та документи** | Фото (в галерее) + ссылки | Желательно |
| 7 | **FAQ по товару** | Статичный или модуль | Желательно + SEO |

### 7.2 UX-паттерн: вертикально раскрытые секции (Collapsed Sections)

Каждая секция — `<details>/<summary>` или Bootstrap collapse:
- Первая секция «Опис» открыта по умолчанию
- Остальные: первые 3 строки видны, кнопка «Читати більше»
- На десктопе все секции развернуты по умолчанию
- На мобильном: закрыты (accordion), открываются по клику

```html
<section class="product-section" id="product-description">
  <h2 class="product-section__title">
    <button class="product-section__toggle" aria-expanded="true"
            aria-controls="product-description-body">
      Опис
      <i class="fa-solid fa-chevron-down" aria-hidden="true"></i>
    </button>
  </h2>
  <div class="product-section__body" id="product-description-body">
    {$product.description nofilter}
  </div>
</section>
```

---

## 8. ОБЯЗАТЕЛЬНЫЕ ЮРИДИЧЕСКИЕ ТРЕБОВАНИЯ УКРАИНЫ

### 8.1 Закон № 4122-IX от 05.12.2024 (вступил в силу 27.09.2025)

Закон впервые системно урегулировал рынок биологически активных добавок в Украине. Реклама и маркировка не могут утверждать лечебные свойства добавок или содержать заявления, будто продукт излечивает болезни.

После 27.09.2025 любой продукт, не соответствующий требованиям, подлежит отзыву из оборота.

### 8.2 Обязательная информация на странице товара (Закон «Про інформацію для споживачів щодо харчових продуктів» + Наказ МОЗ № 1114)

Вся информация **обязательно на украинском языке**.

**Блок обязательных застережень (жёсткий текст, нельзя менять):**

```
⚠️ ОБОВ'ЯЗКОВІ ЗАСТЕРЕЖЕННЯ (за законодавством України):
• Дієтична добавка. Не є лікарським засобом.
• Не замінює повноцінного раціону харчування.
• Не перевищуйте рекомендовану добову дозу.
• Зберігати у недоступному для дітей місці.
• Перед застосуванням проконсультуйтеся з лікарем.
```

**Обязательные поля товара на сайте:**

| Поле | Источник в PS9 | Пример |
|---|---|---|
| Повна назва продукту | `$product.name` | «Вітамін С 1000 мг — дієтична добавка» |
| Склад (інгредієнти) | `$product.description` или атрибут | Всі інгредієнти, алергени виділити |
| Рекомендована добова доза | Кастомный атрибут | «1 капсула на день» |
| Кількість у упаковці | `$product.reference` или атрибут | «60 капсул» |
| Термін придатності | Поле PS9 или атрибут | «Дивіться на упаковці» |
| Умови зберігання | Кастомный атрибут | «Зберігати при t° до 25°C» |
| Виробник та країна | Кастомный атрибут | «G&G Vitamins, Велика Британія» |
| Імпортер / представник | Статичный блок или атрибут | Юридические данные UA-представителя |
| Штрихкод | Поле EAN13 в PS9 (`$product.ean13`) | 5060327540123 |
| Product Code G&G | `$product.reference` (рекомендуется) | GA651 |
| Нотифікація ДПСС | Кастомный атрибут или статично | № повідомлення (если есть) |

### 8.3 Запрещённые формулировки в описании (закон + АМКУ)

**НЕЛЬЗЯ писать:**
- «лікує», «зцілює», «виліковує» — любые лечебные свойства
- «замінює ліки», «краще за ліки»
- «знімає біль», «допомагає при хворобі X»
- Ссылки на лечение конкретных заболеваний

**МОЖНО писать:**
- «підтримує імунітет», «сприяє нормальній роботі»
- «джерело вітаміну C», «містить магній»
- «рекомендовано як доповнення до раціону»

**⚠️ За нарушения:** штраф 640 000 грн для юридических лиц (Закон № 4122-IX).

### 8.4 Блок «Виробник» (обязательный)

```html
<div class="product-manufacturer">
  <p><strong>Виробник:</strong> G&G Vitamins Ltd, Велика Британія</p>
  <p><strong>Офіційний представник в Україні:</strong> [назва компании UA]</p>
  <p><strong>Адреса:</strong> [юридический адрес]</p>
  <p><strong>Штрихкод:</strong> {$product.ean13}</p>
  <p><strong>Product Code:</strong> {$product.reference}</p>
  <p>
    <i class="fa-solid fa-flag" aria-hidden="true"></i>
    Вироблено у Великій Британії
  </p>
</div>
```

---

## 9. ОТЗЫВЫ — расположение и UX

### 9.1 Рекомендация: отдельная секция после информационных блоков

**Решение: отдельная полноширинная секция `<section id="product-reviews">`, после всех информационных блоков.**

Обоснование:
- Отзывы покупателей на страницах товара должны иметь отдельный видимый блок, а не скрываться за вкладкой или в модальном окне: это важно как для видимости другими пользователями, так и потому что Google известен игнорированием контента, скрытого в вкладках, — магазины теряют SEO-пользу от уникального пользовательского контента.
- Ссылка из покупательской панели `<a href="#product-reviews">` якорно прокручивает страницу к секции.
- Модуль `ps_productcomments` рендерит отзывы через хук `displayProductTabContent` — подключаем в секцию, не в таб.

### 9.2 Структура блока отзывов

```
┌─────────────────────────────────────────────────────┐
│  Відгуки покупців (17)                              │
│  ★★★★☆ 4.2 із 5   [Написати відгук]               │
│  ████████░░ 5★ (12)                                 │
│  ██████░░░░ 4★ (3)                                  │
│  ████░░░░░░ 3★ (2)                                  │
│  ░░░░░░░░░░ 2★ (0)                                  │
│  ░░░░░░░░░░ 1★ (0)                                  │
├─────────────────────────────────────────────────────┤
│  [Сортування: Найновіші ▼]  [Фільтр: Всі оцінки ▼] │
├─────────────────────────────────────────────────────┤
│  ★★★★★  Іван К.  ·  12.02.2026  ✓ Підтверджена     │
│  «Відмінна якість, беру вже рік...»                  │
│  [Корисно (3)] [Не корисно (0)]                      │
├─────────────────────────────────────────────────────┤
│  (ещё отзывы)                                        │
│  [Завантажити ще відгуки]                            │
└─────────────────────────────────────────────────────┘
```

**Рекомендации по показу:**
- Desktop: показывать 6–15 отзывов, mobile: не более 10. Кнопка «Завантажити ще» вместо пагинации.
- Рейтинговая разбивка (distribution bar) — обязательна: пользователи ищут плохие отзывы первыми.
- Метка «Підтверджена покупка» — важна для доверия.
- Сортировка: Найновіші / Найкорисніші / За оцінкою.

### 9.3 JSON-LD AggregateRating

`schema-product.tpl` (v0.4.0) уже содержит `AggregateRating`. Условие: `{if $product.comment_count > 0}`. Google показывает звёзды в поисковой выдаче — мощный инструмент для CTR.

---

## 10. FAQ ПО ТОВАРУ

### 10.1 Размещение и реализация

FAQ по товару размещается как последняя информационная секция, перед блоком отзывов. Реализация — такая же как на главной: Bootstrap accordion + JSON-LD `FAQPage` через `schema-faq.tpl` (v0.4.0).

**Типичные вопросы для G&G (шаблон):**
- «Чи можна приймати разом з іншими вітамінами?»
- «Підходить для вагітних?»
- «Коли очікувати результат?»
- «Чи містить алергени?»
- «Яка форма випуску — капсули чи таблетки?»

**SEO-ценность FAQ:** Google может выдать Rich Result «FAQ» в поисковой выдаче, что значительно увеличивает занимаемое место в SERP и CTR. AI-агенты используют FAQ для ответов на пользовательские запросы о продукте.

### 10.2 `schema-faq.tpl` — интеграция

```smarty
{* В product.tpl, после информационных секций: *}
{if isset($product_faq_items) && $product_faq_items|@count > 0}
  {assign var='faq_items' value=$product_faq_items}
  {hook h='displaySchemaMarkup'} {* → schema-faq.tpl *}
  {* HTML accordion ниже *}
{/if}
```

---

## 11. СХОЖІ ТОВАРИ (Related Products)

### 11.1 Расположение и источник

Полноширинный блок после секции отзывов.
Источник: `{hook h='displayFooterProduct'}` — PS9 запускает модули рекомендаций.

**Рекомендуемые типы:**
- «Також купують» — `ps_crossselling`
- «З цієї категорії» — `ps_categoryproducts`

### 11.2 Карточки схожих товаров

Используем уже готовый `product-miniature.tpl` (v0.6.0) в горизонтальном скроллируемом ряду (не grid):

```
← [Товар 1] [Товар 2] [Товар 3] [Товар 4] [Товар 5] →
          scroll-snap, horizontal
```

На десктопе: 4 карточки видны. На mobile: 2 карточки + частично видна третья (scroll hint).

---

## 12. SEO И AI-АГЕНТЫ — специфика страницы товара

### 12.1 Структура заголовков

```
H1: Назва товару (один раз, в покупательской панели)
  H2: Опис
  H2: Склад та харчова цінність
  H2: Спосіб застосування
  H2: Обов'язкові застереження (закон)
  H2: Деталі та характеристики
  H2: Сертифікати
  H2: FAQ
  H2: Відгуки покупців (N)
  H2: Схожі товари
```

### 12.2 JSON-LD схемы (все в `{hook h='displaySchemaMarkup'}`)

| Схема | Файл | Условие |
|---|---|---|
| `Product + Offer` | `schema-product.tpl` ✅ | Всегда |
| `AggregateRating` | внутри `schema-product.tpl` ✅ | `comment_count > 0` |
| `BreadcrumbList` | `schema-breadcrumb.tpl` ✅ | Всегда (уже в head.tpl) |
| `FAQPage` | `schema-faq.tpl` ✅ | Если есть FAQ по товару |

### 12.3 Требования AI-агентов 2026

- **Состав продукта в тексте DOM** — не только в фото. AI-агенты читают текст, не изображения. Supplement Facts в тексте помогает Perplexity, Gemini, SearchGPT корректно отвечать на вопросы о составе.
- **Застережения в DOM** — обязательные юридические тексты должны быть в HTML, не в изображениях.
- **Structured data полная** — AI-агенты используют `Product` schema для ответов на «compare vitamins C».
- **Canonical URL** — уже в head.tpl. Для страниц с вариантами: canonical на основной товар, а не на вариант.
- **Язык `lang="uk"`** — на `<html>` (уже в head.tpl). AI ранжирует украинские ответы для UA пользователей.

### 12.4 Core Web Vitals — страница товара

| Метрика | Цель | Меры |
|---|---|---|
| **LCP** | < 2.5s | Главное фото: `loading="eager"` + `fetchpriority="high"`. Остальные: `lazy`. |
| **CLS** | < 0.1 | `aspect-ratio` на контейнере галереи. Резервировать место под варианты. |
| **INP** | < 200ms | AJAX вариантов без блокировки main thread. Debounce на qty stepper. |

---

## 13. РАЗМЕРЫ — АДАПТИВ ПО BREAKPOINTS

### 13.1 Desktop широкий (≥1400px)

```
Галерея: 600px | Покупательская панель: ~550px | Gap: 40px
Главное фото: 600×600px
Миниатюры: 80px колонка, 72×72px фото
```

### 13.2 Desktop стандарт (1200–1399px)

```
Галерея: 520px | Покупательская панель: ~480px | Gap: 32px
Главное фото: 520×520px
```

### 13.3 Desktop минимум / планшет горизонтально (992–1199px)

```
Галерея: 45% | Покупательская панель: 55% | Gap: 24px
Миниатюры: 64px, 56×56px
```

### 13.4 Планшет вертикально (768–991px)

```
Галерея: полная ширина
Покупательская панель: полная ширина
Миниатюры: горизонтальный strip снизу, 4 видны
```

### 13.5 Mobile (< 768px)

```
Галерея: полная ширина, swipe, без миниатюр
Покупательская панель: полная ширина
Sticky bottom bar: высота 64px + safe-area
Информационные секции: accordion (закрытые по умолчанию)
```

---

## 14. АНИМАЦИИ — страница товара

### 14.1 Галерея

```css
/* Смена фото — плавный crossfade */
.product-gallery__main-img {
  transition: opacity 0.25s ease;
}
.product-gallery__main-img.is-loading {
  opacity: 0.3;
}

/* Активная миниатюра */
.product-gallery__thumb {
  transition: border-color 0.15s ease, transform 0.15s ease;
}
.product-gallery__thumb--active {
  transform: scale(1.05);
}
```

### 14.2 Варианты

```css
/* Выбор пилюли */
.product-variants__pill {
  transition: background 0.15s ease, border-color 0.15s ease, color 0.15s ease;
}
```

### 14.3 Sticky bottom bar — появление

```css
@media (prefers-reduced-motion: no-preference) {
  .product-sticky-bar {
    transform: translateY(100%);
    transition: transform 0.25s ease;
  }
  .product-sticky-bar.is-visible {
    transform: translateY(0);
  }
}
```

### 14.4 Кнопка «До кошика»

Аналогично `product-miniature.tpl`: иконка корзины `scale(1.2)` при клике. Текст меняется на «✓ Додано» на 2s (вместо 1.5s в листинге — больше времени для чтения).

---

## 15. ФАЙЛЫ ДЛЯ СОЗДАНИЯ В v0.7.0

```
templates/catalog/
├── product.tpl                      ← главная страница товара
└── _partials/
    ├── product-images.tpl           ← галерея (desktop + mobile)
    ├── product-prices.tpl           ← блок цен
    ├── product-variants.tpl         ← выбор вариантов (пилюли)
    └── product-add-to-cart.tpl      ← qty stepper + кнопка + sticky bar

assets/css/pages/
└── product.css                      ← страничные стили (v0.14.0)

assets/js/pages/
└── product.js                       ← галерея, варианты, sticky bar (v0.14.0)
```

**Зависимости v0.7.0 (все готовы):**
```
layouts/layout-full-width.tpl        ✅ v0.5.0
_partials/breadcrumb.tpl             ✅ v0.5.1
_partials/notifications.tpl          ✅ v0.5.1
microdata/schema-product.tpl         ✅ v0.4.0
microdata/schema-faq.tpl             ✅ v0.4.0
catalog/listing/rating-stars.tpl     ✅ v0.6.0  ← переиспользуем!
```

---

## 16. ЗАКРЫТЫЕ РЕШЕНИЯ — все вопросы

| Вопрос | Решение | Версия |
|---|---|---|
| FAQ по товару — источник данных | Кастомный модуль `ggproductfaq` | v0.7.0 |
| «Спосіб застосування» — хранение | Features (Характеристики PS9), не Attributes | v0.7.0 |
| Нотифікація ДПСС — хранение | Features (Характеристики PS9) | v0.7.0 |
| Lightbox | Нативный `<dialog>` + CSS, без сторонних библиотек | v0.7.0 |
| Sticky TOC на десктопе | Не в v0.7.0 — беклог v0.7.x | v0.7.x |
| Схожі товари — модуль | `ps_crossselling` + `ps_categoryproducts` (нативные) | v0.11.0 |
| Відео для товара | Отдельная секція «Відеоогляд», lazy iframe, v0.7.x | v0.7.x |
| Sticky bar vs mobile-bottom-nav | `bottom: calc(var(--mobile-bottom-nav-height) + env(safe-area-inset-bottom))` | v0.7.0 |

---

## 17. ДЕТАЛЬНЫЕ РЕШЕНИЯ ПО ЗАКРЫТЫМ ВОПРОСАМ

### 17.1 Модуль FAQ — `ggproductfaq`

Кастомный модуль (создать в рамках v0.7.0 или установить готовый):
- Хранит вопросы/ответы в отдельной таблице БД с привязкой к `id_product`
- Выводит через `{hook h='displayFooterProduct'}` или кастомный хук
- Передаёт `$product_faq_items` в Smarty — подхватывает `schema-faq.tpl` (v0.4.0)
- Редактируется в BO → Каталог → Товары → вкладка модуля

```smarty
{* В product.tpl — FAQ секция *}
{assign var='product_faq' value={hook h='displayProductFaq'}}
{if $product_faq}
  {* Модуль передаёт $faq_items в Smarty *}
  {include file='_partials/microdata/schema-faq.tpl'}
  {* HTML accordion ниже *}
  {$product_faq nofilter}
{/if}
```

### 17.2 Характеристики (Features) PS9 — структура для G&G

Создать в BO → Каталог → Характеристики:

| Feature (назва) | Приклад значення | Виводити в |
|---|---|---|
| Спосіб застосування | «1 капсула на день під час їжі» | Секція «Спосіб застосування» |
| Добова доза | «1 капсула» | Секція «Деталі» |
| Форма випуску | «Капсули» | Секція «Деталі» + варіанти |
| Кількість у упаковці | «60 капсул» | Покупательська панель |
| Умови зберігання | «При t° до 25°C, сухе місце» | Секція «Застереження» |
| Термін придатності | «Дивіться на упаковці» | Секція «Деталі» |
| Виробник | «G&G Vitamins Ltd, Велика Британія» | Секція «Виробник» |
| Країна виробництва | «Велика Британія» | Покупательська панель |
| Нотифікація ДПСС | «№ МОЗ України ...» | Секція «Деталі» + мета |
| Product Code | «GA651» | Покупательська панель |
| Штрихкод EAN | «5060327540123» | Секція «Деталі» |

**Обход лимита 255 символов Features:**
- «Спосіб застосування» часто длиннее 255 символов
- Решение: хранить в `$product.description_short` (поле «Короткий опис» в BO), которое поддерживает HTML
- Логически переименовать поле в BO — использовать его только для «Спосіб застосування»
- В шаблоне: `{$product.description_short nofilter}` в соответствующей секции

### 17.3 Lightbox — нативный `<dialog>`

Поддержка в 2026 году: 100% актуальных браузеров. Никаких библиотек.

```html
<!-- Lightbox HTML в product-images.tpl -->
<dialog class="product-lightbox" id="js-product-lightbox" aria-label="Повноекранний перегляд фото">
  <div class="product-lightbox__inner">
    <button class="product-lightbox__close" aria-label="Закрити">
      <i class="fa-solid fa-xmark" aria-hidden="true"></i>
    </button>
    <button class="product-lightbox__prev" aria-label="Попереднє фото">
      <i class="fa-solid fa-chevron-left" aria-hidden="true"></i>
    </button>
    <div class="product-lightbox__stage">
      <img class="product-lightbox__img" src="" alt="" id="js-lightbox-img">
    </div>
    <button class="product-lightbox__next" aria-label="Наступне фото">
      <i class="fa-solid fa-chevron-right" aria-hidden="true"></i>
    </button>
  </div>
</dialog>
```

```css
/* CSS ::backdrop — нативный оверлей без JS */
.product-lightbox::backdrop {
  background: oklch(10% 0 0 / 0.92);
  backdrop-filter: blur(4px);
}

.product-lightbox {
  border: none;
  border-radius: var(--radius-lg);
  max-width: min(90vw, 900px);
  max-height: 90vh;
  padding: 0;
  overflow: hidden;
}
```

```javascript
// product.js (v0.14.0) — открытие/закрытие
const lightbox = document.getElementById('js-product-lightbox');
// Открыть:
lightbox.showModal();
// Закрыть (Esc работает нативно):
lightbox.close();
// Закрыть по клику на backdrop:
lightbox.addEventListener('click', (e) => {
  if (e.target === lightbox) lightbox.close();
});
```

### 17.4 Схожі товари — горизонтальный scroll-snap

Переиспользуем `product-miniature.tpl` (v0.6.0):

```css
.product-related__scroll {
  display: flex;
  gap: 1rem;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  scrollbar-width: none; /* скрываем скроллбар */
  -webkit-overflow-scrolling: touch;
}

.product-related__scroll .col {
  flex: 0 0 calc(25% - 0.75rem); /* 4 карточки desktop */
  scroll-snap-align: start;
}

@media (max-width: 767px) {
  .product-related__scroll .col {
    flex: 0 0 calc(50% - 0.5rem); /* 2+ карточки mobile */
  }
}
```

### 17.5 Відеоогляд — lazy iframe

```html
<!-- Секція відеоогляд — отложенная загрузка -->
{if isset($product.video_url) && $product.video_url}
<section class="product-section" id="product-video">
  <h2 class="product-section__title">Відеоогляд</h2>
  <div class="product-section__body">
    <div class="product-video">
      <!-- Плейсхолдер — iframe грузится только по клику -->
      <button class="product-video__placeholder" data-video-url="{$product.video_url|escape:'html':'UTF-8'}"
              aria-label="Відтворити відео">
        <img class="product-video__thumb" src="..." alt="Відео про {$product.name|escape:'html':'UTF-8'}"
             loading="lazy">
        <span class="product-video__play-icon" aria-hidden="true">
          <i class="fa-solid fa-circle-play"></i>
        </span>
      </button>
    </div>
  </div>
</section>
{/if}
```

LCP-безопасно: iframe не загружается до клика → не влияет на LCP страницы.

---

## 18. ПОЛНАЯ СТРУКТУРА СТРАНИЦЫ ТОВАРА — финальная схема

```
product.tpl
│
├── {block head_extra}
│     <meta noindex если нужно>
│     Schema: displaySchemaMarkup → schema-product.tpl + schema-faq.tpl
│
├── {block content}
│     │
│     ├── breadcrumb.tpl (категорія > товар)
│     ├── notifications.tpl
│     │
│     ├── .product-layout (двухколоночный, ≥992px)
│     │   ├── .product-layout__gallery (55%, sticky desktop)
│     │   │     └── product-images.tpl
│     │   │           ├── Миниатюры слева (вертикальная колонка, desktop)
│     │   │           ├── Главное фото (800×800, object-fit:contain)
│     │   │           ├── Hover-зум (CSS scale)
│     │   │           ├── Lightbox (<dialog>, по клику)
│     │   │           └── Swipe + dots (mobile)
│     │   │
│     │   └── .product-layout__panel (45%)
│     │         ├── Breadcrumb (повтор только текст, не ссылки) [опц.]
│     │         ├── H1: $product.name
│     │         ├── rating-stars.tpl + ссылка на #product-reviews
│     │         ├── .product-identity (артикул, Product Code, Made in UK)
│     │         ├── product-prices.tpl (цена + скидка + цена/единица)
│     │         ├── .product-trust (нотификація ДПСС, Made in England badge)
│     │         ├── product-variants.tpl (кнопки-пилюли)
│     │         ├── product-add-to-cart.tpl (qty stepper + кнопка)
│     │         ├── .product-wishlist-share (wishlist + поделиться)
│     │         ├── .product-delivery (наличие + доставка краткий блок)
│     │         └── .product-guarantees (иконки: возврат, оплата, поддержка)
│     │
│     ├── .product-info-sections (full width)
│     │     ├── <section id="product-description"> Опис
│     │     ├── <section id="product-composition"> Склад та харчова цінність
│     │     ├── <section id="product-usage"> Спосіб застосування та дозування
│     │     ├── <section id="product-warnings"> ⚠️ Обов'язкові застереження (закон)
│     │     ├── <section id="product-details"> Деталі та характеристики
│     │     │     (Features из PS9: нотификація, виробник, штрихкод, EAN...)
│     │     ├── <section id="product-manufacturer"> Виробник та представник
│     │     ├── <section id="product-certificates"> Сертифікати та документи
│     │     ├── <section id="product-video"> Відеоогляд [если есть]
│     │     └── <section id="product-faq"> FAQ по товару + schema-faq.tpl
│     │
│     ├── <section id="product-reviews"> Відгуки (full width)
│     │     ├── Рейтинговая разбивка (distribution bar)
│     │     ├── {hook h='displayProductTabContent'} → ps_productcomments
│     │     └── Кнопка «Написати відгук»
│     │
│     ├── .product-related (full width)
│     │     └── Горизонтальный scroll-snap из product-miniature.tpl (v0.6.0)
│     │
│     └── {hook h='displayFooterProduct'}
│
└── .product-sticky-bar (fixed, mobile, появляется при скролле)
      ├── Текущая цена
      └── Кнопка «До кошика» / «Обрати варіант»
```

---

*Документ составлен на основе: Baymard Institute Vitamins & Supplements UX Benchmark (2025), Baymard Product Page UX (2025), Nielsen Norman Group (2024), Закон України № 4122-IX від 05.12.2024 (вступил в силу 27.09.2025), Наказ МОЗ № 1114 від 19.12.2013, Держпродспоживслужба України (вимоги до маркування), Google Search Central Product structured data (2025–2026), рішення по відкритим питанням (архітектурні рішення, березень 2026).*
