{**
 * page.tpl — Базовый шаблон для наследования
 *
 * mytheme v0.7.1 — PS9 minimum required stub
 * Используется: customer/*, cms/*, errors/*, contact.tpl
 *
 * Ребёнок наследует: {extends file='page.tpl'}
 * Переопределяемые блоки:
 *   {block name='page_title'}       — заголовок H1
 *   {block name='page_content'}     — контент страницы
 *   {block name='page_footer'}      — футер страницы
 *}
{extends file=$layout}

{block name='content'}
  {block name='page_header_container'}
    {block name='page_title'}
      <div class="page-header">
        <h1>{$smarty.block.child}</h1>
      </div>
    {/block}
  {/block}

  {block name='page_content_container'}
    <section id="content" class="page-content">
      {block name='page_content_top'}{/block}

      {block name='page_content'}
        {* Page content — override in child template *}
      {/block}
    </section>
  {/block}

  {block name='page_footer_container'}
    <footer class="page-footer">
      {block name='page_footer'}
      {/block}
    </footer>
  {/block}
{/block}
