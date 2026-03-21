{**
 * layout-left-column.tpl — Layout с левой боковой колонкой
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='layouts/layout-full-width.tpl'}

{block name='content'}
  <div class="container">
    <div class="row">
      <div id="left-column" class="col-12 col-lg-3">
        {block name='left_column'}
          {hook h='displayLeftColumn'}
        {/block}
      </div>
      <div id="content-wrapper" class="col-12 col-lg-9">
        {$smarty.block.parent}
      </div>
    </div>
  </div>
{/block}
