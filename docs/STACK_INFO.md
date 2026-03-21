# 🖥️ Desktop Environment — DESKTOP-TPFTTO1

> Файл создан: 21.03.2026 | Проект: `two-prestashop` | Тема: `mytheme v0.7.3`

---

## 📦 Stack

| Компонент | Версия       | Путь                                                              |
|-----------|--------------|-------------------------------------------------------------------|
| PHP       | 8.4.19       | `C:\laragon\bin\php\php-8.4.19-Win32-vs17-x64\php.exe`           |
| MySQL     | 8.4.3        | `C:\laragon\bin\mysql\mysql-8.4.3-winx64\bin\mysql.exe`          |
| Apache    | 2.4.62       | `C:\laragon\bin\apache\httpd-2.4.62-240904-win64-VS17\bin\httpd.exe` |
| Node.js   | —            | не установлен                                                     |
| Composer  | —            | не установлен                                                     |
| Git       | 2.43.0 (WSL) | `C:\laragon\bin\git\`                                             |

---

## ⚙️ PHP Key Settings

| Параметр             | Значение |
|----------------------|----------|
| max_execution_time   | 0        |
| memory_limit         | 512M     |
| post_max_size        | 2G       |
| upload_max_filesize  | 2G       |
| date.timezone        | UTC      |
| php.ini              | `C:\laragon\bin\php\php-8.4.19-Win32-vs17-x64\php.ini` |

---

## 🌐 PrestaShop

| Параметр              | Значение                                                    |
|-----------------------|-------------------------------------------------------------|
| Версия                | 9.0.3                                                       |
| Distribution          | classic 3.0                                                 |
| Тема                  | mytheme                                                     |
| URL магазина          | `https://two-prestashop.test/`                              |
| Путь                  | `C:\laragon\www\two-prestashop`                             |
| Админка               | `https://two-prestashop.test/admin300tn3xux2vgh3moqqo/`     |

---

## 🗄️ База данных

| Параметр        | Значение      |
|-----------------|---------------|
| Host            | 127.0.0.1     |
| Port            | 3306          |
| База            | prestashop    |
| Пользователь    | root          |
| Пароль          | —             |
| Префикс таблиц  | w513y_        |
| Движок          | InnoDB        |
| Драйвер         | DbPDO         |
| datadir         | `C:\laragon\data\mysql-8.4\` |

---

## 🗂️ Virtual Host

| Параметр  | Значение                       |
|-----------|--------------------------------|
| Домен     | `two-prestashop.test`          |
| hosts     | `127.0.0.1 two-prestashop.test` |
| Конфиг    | `C:\laragon\etc\apache2\sites-enabled\auto.two-prestashop.test.conf` |
| SSL       | `C:\laragon\etc\ssl\`          |

---

## 📁 Проекты в WWW (`C:\laragon\www`)

- `apexrehab`
- `download-idO8pyOFG4-1771785562204`
- `files`
- `gandg-v3`
- `info`
- `Nova-Poshta-Logo-Vector`
- `one-prestaShop`
- `two-prestashop` ← текущий проект

---

## 💻 Система

| Параметр      | Значение                    |
|---------------|-----------------------------|
| Hostname      | DESKTOP-TPFTTO1             |
| OS            | Windows 10 (build 19045) x64 |
| Username      | OptiPlex960                 |
| UserProfile   | `C:\Users\OptiPlex960`      |

---

## ⚠️ Примечания

- `app/config/parameters.php` — в `.gitignore`, хранится локально, **не в репо**
- Дамп БД: `db-dump/prestashop_desktop.sql`
- Отсутствующий файл: `var/cache/CACHEDIR.TAG` — не критично
- Метод отправки почты: `/usr/sbin/sendmail`
