{**
 * cms/category.tpl — CMS категория
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='page.tpl'}

{block name='page_title'}
  {$cms_category.name|escape:'html':'UTF-8'}
{/block}

{block name='page_content'}
  {if isset($cms_category.description) && $cms_category.description}
    {$cms_category.description nofilter}
  {/if}
  {if isset($sub_categories) && $sub_categories|@count > 0}
    <ul>
      {foreach from=$sub_categories item=subcategory}
        <li><a href="{$subcategory.link}">{$subcategory.name|escape:'html':'UTF-8'}</a></li>
      {/foreach}
    </ul>
  {/if}
{/block}
