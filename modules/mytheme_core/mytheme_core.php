<?php
/**
 * Espinolla Asset Optimizer
 *
 * @author    Oleksander Semenov <info@espinolla.com>
 * @copyright 2026 Web Studio "Espinolla" (https://espinolla.com)
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * @version   1.8.0
 * @date      2026-04-01
 *
 * =============================================================================
 * CHANGELOG
 * =============================================================================
 *
 * v1.8.0 — 2026-04-01
 * ─────────────────────────────────────────────────────────────────────────────
 * НОВОЕ:
 *  - REMOVE_MODULE_CSS = true  — удаляет ВСЕ <link> из /modules/, оставляет
 *    только CSS темы. Выключить: false.
 *  - REMOVE_MODULE_JS = false  — аналогично для <script> из /modules/.
 *    По умолчанию выключено (модульный JS может быть нужен).
 *  - EXTRA_SCRIPT_SUBSTRINGS / EXTRA_LINK_SUBSTRINGS — простые списки подстрок
 *    для точечного удаления конкретных файлов. Без регулярок — просто часть URL.
 *  - Дедупликация: одинаковые <script src> и <link href> на одной странице
 *    убираются автоматически (theme.js и theme.css грузились дважды).
 *
 * v1.7.0 — 2026-04-01
 * ─────────────────────────────────────────────────────────────────────────────
 *  - Output buffering. processHtml() перехватывает весь HTML и вырезает
 *    jQuery / Bootstrap теги регулярками.
 *    Диагноз: jQuery вшит в шаблон темы, не в PS-систему ресурсов.
 */

declare(strict_types=1);

if (!defined('_PS_VERSION_')) {
    exit;
}

class Mytheme_Core extends Module
{
    // =========================================================================
    // ╔══════════════════════════════════════════════════════════════════════╗
    // ║                  КОНФИГУРАЦИЯ — РЕДАКТИРУЙТЕ ЗДЕСЬ                  ║
    // ╚══════════════════════════════════════════════════════════════════════╝
    // =========================================================================

    /**
     * Удалить ВСЕ <link rel="stylesheet"> из /modules/.
     * true  — весь CSS модулей убирается, остаётся только CSS темы.
     * false — CSS модулей не трогается.
     */
    private const REMOVE_MODULE_CSS = true;

    /**
     * Удалить ВСЕ <script src="..."> из /modules/.
     * true  — весь JS модулей убирается (осторожно: корзина, поиск и т.д. перестанут работать).
     * false — JS модулей не трогается (рекомендуется).
     */
    private const REMOVE_MODULE_JS = false;

    /**
     * Точечное удаление конкретных JS-файлов по подстроке URL.
     * Просто часть адреса файла — без регулярок, без звёздочек.
     *
     * Примеры:
     *   'ps_imageslider/js/responsiveslides.min.js'  — конкретный файл
     *   'ps_imageslider'                             — всё из этого модуля
     *   'core.js'                                    — файл core.js откуда угодно
     */
    private const EXTRA_SCRIPT_SUBSTRINGS = [
       'ps_imageslider/js/responsiveslides.min.js',
        'ps_imageslider/js/homeslider.js', 
        'ps_facebook/views/js/front/conversion-api.js',
        'blockreassurance/views/dist/front.js',     
        // Добавляйте сюда подстроки URL JS-файлов которые нужно удалить, например:
        // 'ps_imageslider/js/responsiveslides.min.js',
        // 'ps_imageslider/js/homeslider.js',
    ];

    /**
     * Точечное удаление конкретных CSS-файлов по подстроке URL.
     * Работает когда REMOVE_MODULE_CSS = false, но нужно убрать отдельные файлы.
     *
     * Примеры:
     *   'ps_socialfollow/views/css/ps_socialfollow.css'
     *   'ps_searchbar/ps_searchbar.css'
     */
    private const EXTRA_LINK_SUBSTRINGS = [
        // Добавляйте сюда подстроки URL CSS-файлов которые нужно удалить, например:
        // 'ps_socialfollow/views/css/ps_socialfollow.css',
    ];

    /**
     * Дедупликация — убирать дублирующиеся <script> и <link> теги.
     * (theme.js и theme.css грузились дважды — это исправляет автоматически.)
     */
    private const DEDUPLICATE_ASSETS = true;

    // =========================================================================
    // Встроенные паттерны jQuery / Bootstrap (не трогать без необходимости)
    // =========================================================================

    private const SCRIPT_PATTERNS = [
        // jQuery core
        '~<script\b[^>]*\bsrc=["\'][^"\']*\/jquery(?:[.-][^"\']*)?\.js[^"\']*["\'][^>]*>\s*<\/script>~i',
        // jQuery Migrate
        '~<script\b[^>]*\bsrc=["\'][^"\']*\/jquery[-.]migrate[^"\']*\.js[^"\']*["\'][^>]*>\s*<\/script>~i',
        // jQuery UI
        '~<script\b[^>]*\bsrc=["\'][^"\']*\/jquery[-.]ui[^"\']*\.js[^"\']*["\'][^>]*>\s*<\/script>~i',
        // jQuery из папок /js/jquery/ и /jquery-plugins/
        '~<script\b[^>]*\bsrc=["\'][^"\']*\/js\/jquery\/[^"\']*\.js[^"\']*["\'][^>]*>\s*<\/script>~i',
        '~<script\b[^>]*\bsrc=["\'][^"\']*\/jquery[-_]?plugins?\/[^"\']*\.js[^"\']*["\'][^>]*>\s*<\/script>~i',
        // Bootstrap JS
        '~<script\b[^>]*\bsrc=["\'][^"\']*\/bootstrap(?:\.bundle)?(?:\.min)?\.js[^"\']*["\'][^>]*>\s*<\/script>~i',
        '~<script\b[^>]*\bsrc=["\'][^"\']*\/bootstrap\/[^"\']*\.js[^"\']*["\'][^>]*>\s*<\/script>~i',
    ];

    private const LINK_PATTERNS = [
        // jQuery UI CSS
        '~<link\b[^>]*\bhref=["\'][^"\']*\/jquery[-.]ui[^"\']*\.css[^"\']*["\'][^>]*\/?>~i',
        // Bootstrap CSS
        '~<link\b[^>]*\bhref=["\'][^"\']*\/bootstrap(?:\.min)?\.css[^"\']*["\'][^>]*\/?>~i',
        '~<link\b[^>]*\bhref=["\'][^"\']*\/bootstrap\/[^"\']*\.css[^"\']*["\'][^>]*\/?>~i',
    ];

    // =========================================================================
    // Конструктор
    // =========================================================================

    public function __construct()
    {
        $this->name          = 'mytheme_core';
        $this->tab           = 'front_office_features';
        $this->version       = '1.8.0';
        $this->author        = 'Web Studio Espinolla';
        $this->need_instance = 0;
        $this->bootstrap     = true;

        $this->ps_versions_compliancy = ['min' => '9.0.0', 'max' => _PS_VERSION_];

        parent::__construct();

        $this->displayName = $this->trans(
            'Espinolla Asset Optimizer',
            [],
            'Modules.Mythemecore.Admin'
        );
        $this->description = $this->trans(
            'Удаляет jQuery, Bootstrap и ненужные CSS/JS модулей из HTML-вывода темы.',
            [],
            'Modules.Mythemecore.Admin'
        );
        $this->confirmUninstall = $this->trans(
            'Удалить модуль? Все заблокированные ресурсы снова будут подключаться.',
            [],
            'Modules.Mythemecore.Admin'
        );
    }

    // =========================================================================
    // Установка / Удаление
    // =========================================================================

    public function install(): bool
    {
        return parent::install()
            && $this->registerHook('actionFrontControllerSetMedia');
    }

    public function uninstall(): bool
    {
        return parent::uninstall();
    }

    // =========================================================================
    // Хук
    // =========================================================================

    /**
     * Запускаем буферизацию вывода.
     * Callback processHtml() получит полный HTML страницы и вырежет ненужные теги.
     */
    public function hookActionFrontControllerSetMedia(): void
    {
        ob_start([$this, 'processHtml']);
    }

    // =========================================================================
    // Обработка HTML
    // =========================================================================

    /**
     * Callback для ob_start(). Получает весь HTML страницы, возвращает
     * очищенный — без нежелательных тегов.
     */
    public function processHtml(string $html): string
    {
        if (empty($html)) {
            return $html;
        }

        // ── 1. jQuery / Bootstrap (встроенные паттерны) ───────────────────────
        foreach (self::SCRIPT_PATTERNS as $pattern) {
            $html = (string) preg_replace($pattern, '', $html);
        }
        foreach (self::LINK_PATTERNS as $pattern) {
            $html = (string) preg_replace($pattern, '', $html);
        }

        // ── 2. Весь CSS из /modules/ ──────────────────────────────────────────
        if (self::REMOVE_MODULE_CSS) {
            $html = (string) preg_replace(
                '~<link\b[^>]*\bhref=["\'][^"\']*\/modules\/[^"\']*\.css[^"\']*["\'][^>]*\/?>~i',
                '',
                $html
            );
        }

        // ── 3. Весь JS из /modules/ ───────────────────────────────────────────
        if (self::REMOVE_MODULE_JS) {
            $html = (string) preg_replace(
                '~<script\b[^>]*\bsrc=["\'][^"\']*\/modules\/[^"\']*\.js[^"\']*["\'][^>]*>\s*<\/script>~i',
                '',
                $html
            );
        }

        // ── 4. Точечное удаление по подстрокам URL ────────────────────────────
        foreach (self::EXTRA_SCRIPT_SUBSTRINGS as $substring) {
            $quoted = preg_quote($substring, '~');
            $html   = (string) preg_replace(
                '~<script\b[^>]*\bsrc=["\'][^"\']*' . $quoted . '[^"\']*["\'][^>]*>\s*<\/script>~i',
                '',
                $html
            );
        }

        foreach (self::EXTRA_LINK_SUBSTRINGS as $substring) {
            $quoted = preg_quote($substring, '~');
            $html   = (string) preg_replace(
                '~<link\b[^>]*\bhref=["\'][^"\']*' . $quoted . '[^"\']*["\'][^>]*\/?>~i',
                '',
                $html
            );
        }

        // ── 5. Дедупликация ───────────────────────────────────────────────────
        if (self::DEDUPLICATE_ASSETS) {
            $html = $this->deduplicateAssets($html);
        }

        return $html;
    }

    /**
     * Убирает дублирующиеся <script src="..."> и <link href="..."> теги.
     * Оставляет первое вхождение, удаляет все повторные.
     */
    private function deduplicateAssets(string $html): string
    {
        $seenScripts = [];
        $html = (string) preg_replace_callback(
            '~<script\b[^>]*\bsrc=["\']([^"\']+)["\'][^>]*>\s*<\/script>~i',
            static function (array $matches) use (&$seenScripts): string {
                $src = strtolower(trim($matches[1]));
                if (isset($seenScripts[$src])) {
                    return '';
                }
                $seenScripts[$src] = true;
                return $matches[0];
            },
            $html
        );

        $seenLinks = [];
        $html = (string) preg_replace_callback(
            '~<link\b[^>]*\bhref=["\']([^"\']+)["\'][^>]*\/?>~i',
            static function (array $matches) use (&$seenLinks): string {
                $href = strtolower(trim($matches[1]));
                if (isset($seenLinks[$href])) {
                    return '';
                }
                $seenLinks[$href] = true;
                return $matches[0];
            },
            $html
        );

        return $html;
    }

    // =========================================================================
    // Страница настроек в бэкенде
    // =========================================================================

    public function getContent(): string
    {
        $message = '';
        if (Tools::isSubmit('fix_hook_position')) {
            $this->setHookPositionLast('actionFrontControllerSetMedia');
            $message = '<div class="alert alert-success"><strong>✓ Позиция хука обновлена.</strong></div>';
        }

        $hookId = (int) Hook::getIdByName('actionFrontControllerSetMedia');
        $shopId = isset($this->context->shop->id) ? (int) $this->context->shop->id : 1;

        $position  = 'N/A';
        $maxOthers = 0;
        $isLast    = false;

        if ($hookId > 0) {
            $row = Db::getInstance()->getRow(sprintf(
                'SELECT `position` FROM `%shook_module`
                 WHERE `id_hook` = %d AND `id_module` = %d AND `id_shop` = %d',
                _DB_PREFIX_, $hookId, (int) $this->id, $shopId
            ));

            $maxOthers = (int) Db::getInstance()->getValue(sprintf(
                'SELECT MAX(`position`) FROM `%shook_module`
                 WHERE `id_hook` = %d AND `id_shop` = %d AND `id_module` != %d',
                _DB_PREFIX_, $hookId, $shopId, (int) $this->id
            ));

            $position = $row ? (string) $row['position'] : 'not found';
            $isLast   = ($row && (int) $row['position'] > $maxOthers);
        }

        $yesNo = static fn(bool $v): string => $v
            ? '<span class="label label-success">ВКЛ</span>'
            : '<span class="label label-default">ВЫКЛ</span>';

        return '
        <div class="panel">
            <div class="panel-heading">
                <i class="icon-cogs"></i> Espinolla Asset Optimizer v1.8.0
            </div>
            <div class="panel-body">
                ' . $message . '

                <div class="alert alert-info">
                    <strong>ℹ Метод:</strong> Output Buffering — перехват HTML-вывода до отправки браузеру.<br>
                    jQuery не в PS-системе ресурсов, он вшит в шаблон темы — методы unregister не помогают.<br>
                    Модуль вырезает теги регулярными выражениями из готового HTML.
                </div>

                <h4>Текущие настройки</h4>
                <table class="table table-bordered" style="max-width:640px">
                    <tbody>
                        <tr>
                            <td><code>REMOVE_MODULE_CSS</code></td>
                            <td>' . $yesNo(self::REMOVE_MODULE_CSS) . '</td>
                            <td>Удалять весь CSS из <code>/modules/</code></td>
                        </tr>
                        <tr>
                            <td><code>REMOVE_MODULE_JS</code></td>
                            <td>' . $yesNo(self::REMOVE_MODULE_JS) . '</td>
                            <td>Удалять весь JS из <code>/modules/</code></td>
                        </tr>
                        <tr>
                            <td><code>DEDUPLICATE_ASSETS</code></td>
                            <td>' . $yesNo(self::DEDUPLICATE_ASSETS) . '</td>
                            <td>Убирать дублирующиеся <code>&lt;script&gt;</code> и <code>&lt;link&gt;</code></td>
                        </tr>
                        <tr>
                            <td><code>EXTRA_SCRIPT_SUBSTRINGS</code></td>
                            <td><strong>' . count(self::EXTRA_SCRIPT_SUBSTRINGS) . '</strong></td>
                            <td>Доп. JS-файлы для точечного удаления</td>
                        </tr>
                        <tr>
                            <td><code>EXTRA_LINK_SUBSTRINGS</code></td>
                            <td><strong>' . count(self::EXTRA_LINK_SUBSTRINGS) . '</strong></td>
                            <td>Доп. CSS-файлы для точечного удаления</td>
                        </tr>
                    </tbody>
                </table>

                <div class="alert alert-warning" style="max-width:720px">
                    <strong>Как добавить точечное удаление конкретного файла:</strong><br>
                    Откройте <code>mytheme_core.php</code>, найдите нужную константу и добавьте подстроку URL:<br><br>
                    <pre style="background:#f5f5f5;padding:8px;border-radius:4px;margin:8px 0 0">private const EXTRA_SCRIPT_SUBSTRINGS = [
    \'ps_imageslider/js/responsiveslides.min.js\',
    \'ps_imageslider/js/homeslider.js\',
];</pre>
                    Подстрока — просто часть URL. Регулярки не нужны.
                </div>

                <hr>
                <h4>Хук <code>actionFrontControllerSetMedia</code></h4>
                <div class="alert ' . ($isLast ? 'alert-success' : 'alert-warning') . '" style="max-width:540px">
                    ' . ($isLast ? '✓' : '⚠') . ' Позиция: <code>'
                        . htmlspecialchars($position, ENT_QUOTES, 'UTF-8') . '</code>
                    &nbsp;|&nbsp; Max других: <code>' . $maxOthers . '</code><br><br>
                    ' . ($isLast
                        ? 'Модуль выполняется последним — всё в порядке.'
                        : 'Модуль не последний. Для output buffering не критично, но рекомендуется исправить.') . '
                </div>
                <form method="post" action="">
                    <input type="hidden" name="fix_hook_position" value="1" />
                    <button type="submit" class="btn btn-default">
                        <i class="icon-refresh"></i> Поставить модуль последним на хуке
                    </button>
                </form>

                <hr>
                <table class="table" style="max-width:500px">
                    <tbody>
                        <tr><td><strong>Автор</strong></td><td>Oleksander Semenov</td></tr>
                        <tr><td><strong>Студия</strong></td><td><a href="https://espinolla.com" target="_blank">Web Studio "Espinolla"</a></td></tr>
                        <tr><td><strong>Версия</strong></td><td>' . $this->version . '</td></tr>
                        <tr><td><strong>Совместимость</strong></td><td>PrestaShop 9.0+, PHP 8.1+</td></tr>
                        <tr><td><strong>Лицензия</strong></td><td>AFL 3.0</td></tr>
                    </tbody>
                </table>
            </div>
        </div>';
    }

    // =========================================================================
    // Приватные методы
    // =========================================================================

    private function setHookPositionLast(string $hookName): void
    {
        $hookId = (int) Hook::getIdByName($hookName);
        if ($hookId <= 0 || $this->id <= 0) {
            return;
        }

        $shopId = isset($this->context->shop->id) ? (int) $this->context->shop->id : 1;

        $maxOthers = (int) Db::getInstance()->getValue(sprintf(
            'SELECT MAX(`position`) FROM `%shook_module`
             WHERE `id_hook` = %d AND `id_shop` = %d AND `id_module` != %d',
            _DB_PREFIX_, $hookId, $shopId, (int) $this->id
        ));

        $newPosition = min($maxOthers + 1, 255);

        Db::getInstance()->execute(sprintf(
            'INSERT INTO `%shook_module` (`id_module`, `id_hook`, `id_shop`, `position`)
             VALUES (%d, %d, %d, %d)
             ON DUPLICATE KEY UPDATE `position` = %d',
            _DB_PREFIX_,
            (int) $this->id, $hookId, $shopId,
            $newPosition, $newPosition
        ));
    }
}