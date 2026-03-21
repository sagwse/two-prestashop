{**
 * layout-right-column.tpl — Layout с правой боковой колонкой
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='layouts/layout-full-width.tpl'}

{block name='content'}
  <div class="container">
    <div class="row">
      <div id="content-wrapper" class="col-12 col-lg-9">
        {$smarty.block.parent}
      </div>
      <div id="right-column" class="col-12 col-lg-3">
        {block name='right_column'}
          {hook h='displayRightColumn'}
        {/block}
      </div>
    </div>
  </div>
{/block}
