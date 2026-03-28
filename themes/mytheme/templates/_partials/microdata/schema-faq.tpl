{**
 * schema-faq.tpl
 * MyShop — PrestaShop 9.0 Theme · v0.4.0
 *
 * Schema   : FAQPage
 * Где      : на любой странице, где есть блок вопрос-ответ (FAQ)
 *            Чаще всего: cms.tpl, product.tpl (вкладка FAQ), index.tpl (секция FAQ)
 * Хук      : displaySchemaMarkup
 *
 * КАК ПЕРЕДАТЬ ДАННЫЕ ($faq_items):
 *   Вариант A — через assign перед include (для статического FAQ в CMS):
 *     {assign var='faq_items' value=[
 *       ['question' => 'Как оформить заказ?', 'answer' => 'Добавьте товар в корзину...'],
 *       ['question' => 'Какие способы оплаты?', 'answer' => 'Наличные, карта, безнал.']
 *     ]}
 *     {include file='_partials/microdata/schema-faq.tpl'}
 *
 *   Вариант B — через модуль FAQ (кастомный модуль передаёт $faq_items в Smarty):
 *     Модуль должен добавить переменную через:
 *     $this->context->smarty->assign('faq_items', $items);
 *     Формат элемента: ['question' => string, 'answer' => string]
 *
 *   Вариант C — из accordion-секции на странице товара:
 *     Если на странице товара есть табы/аккордеон с вопросами,
 *     заполните $faq_items из базы или конфигурации перед include.
 *
 * PS9 Smarty-переменные:
 *   $faq_items — массив объектов: [{question: string, answer: string}, ...]
 *
 * ВАЖНО по спецификации Google:
 *   - Ответ (acceptedAnswer.text) должен быть видим пользователю на странице.
 *   - Не используйте FAQPage для рекламного контента.
 *   - Максимум ~10 пар вопрос-ответ — Google показывает первые 3 в Rich Results.
 *   - Текст очищается от HTML через strip_tags — убедитесь что HTML-теги в ответах
 *     не несут структурного смысла (таблицы, списки со сложной иерархией).
 *}

{if isset($faq_items) && $faq_items|@count > 0}
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {foreach from=$faq_items item=_faq name=_faq_loop}
          {
            "@type": "Question",
            "name": "{$_faq.question|strip_tags|trim|escape:'javascript'}",
            "acceptedAnswer": {
              "@type": "Answer",
              "text": "{$_faq.answer|strip_tags|trim|escape:'javascript'}"
            }
            }{if !$smarty.foreach._faq_loop.last},{/if}
          {/foreach}
        ]
      }
  </script>
{/if}