{**
 * layout-both-columns.tpl — Layout с двумя боковыми колонками
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
      <div id="content-wrapper" class="col-12 col-lg-6">
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
