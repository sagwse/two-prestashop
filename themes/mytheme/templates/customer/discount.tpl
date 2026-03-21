{**
 * discount.tpl — Скидки и купоны
 * mytheme v0.7.1 — PS9 stub
 *}
{extends file='customer/page.tpl'}

{block name='page_title'}
  {l s='Мої знижки' d='Shop.Theme.Customeraccount'}
{/block}

{block name='page_content'}
  {if isset($cart_rules) && $cart_rules|@count > 0}
    {foreach from=$cart_rules item=rule}
      <div class="discount-item">
        <strong>{$rule.code}</strong> — {$rule.name}
        {if $rule.value}<span>{$rule.value}</span>{/if}
      </div>
    {/foreach}
  {else}
    <p>{l s='У вас немає доступних знижок.' d='Shop.Theme.Customeraccount'}</p>
  {/if}
{/block}
