# 🚀 БЫСТРЫЙ СТАРТ - ANSIBLE-PULL

## Интерактивная демонстрация

```bash
bash demo-ansible-pull.sh
```

Запустите этот скрипт для просмотра полной пошаговой демонстрации с красивым оформлением.

---

## ⚡ ВСЕ КОМАНДЫ (для копирования)

### 1️⃣ Установка Ansible

```bash
# На Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y ansible git

# На macOS
brew install ansible
```

### 2️⃣ Проверка синтаксиса плейбука

```bash
ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml
```

### 3️⃣ Локальное тестирование (режим check)

```bash
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v --check
```

### 4️⃣ Локальное выполнение плейбука

```bash
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v
```

### 5️⃣ Первый запуск ansible-pull

```bash
# Базовая команда
sudo ansible-pull -U https://github.com/your-username/ansible-repo.git \
  -d /var/lib/ansible/pull \
  local.yml -v

# С указанием инвентори
sudo ansible-pull -U https://github.com/your-username/ansible-repo.git \
  -i ansible-repo/inventory \
  -d /var/lib/ansible/pull \
  local.yml -v
```

### 6️⃣ Подготовка целевой машины (ВМ)

```bash
# 1. Установка зависимостей
sudo apt-get update
sudo apt-get install -y ansible git

# 2. Создание директории
sudo mkdir -p /var/lib/ansible/pull
sudo chown ansible:ansible /var/lib/ansible/pull

# 3. Первый запуск ansible-pull
sudo ansible-pull \
  -U https://github.com/your-username/ansible-repo.git \
  -d /var/lib/ansible/pull \
  local.yml -v
```

### 7️⃣ Добавление в cron (автоматическое выполнение)

```bash
# Открыть crontab
sudo crontab -e

# Добавить одну из строк:

# Каждые 15 минут
*/15 * * * * ansible-pull -U https://github.com/your-username/ansible-repo.git -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1

# Каждый час
0 * * * * ansible-pull -U https://github.com/your-username/ansible-repo.git -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1

# Каждый день в 3 утра
0 3 * * * ansible-pull -U https://github.com/your-username/ansible-repo.git -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1

# Каждый день в 00:00 и 12:00
0 0,12 * * * ansible-pull -U https://github.com/your-username/ansible-repo.git -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1
```

### 8️⃣ Проверка логов

```bash
# Просмотр последних записей
sudo tail -f /var/log/ansible-pull.log

# Полный лог
sudo cat /var/log/ansible-pull.log

# Поиск ошибок
sudo grep -i "error\|failed" /var/log/ansible-pull.log
```

### 9️⃣ Проверка статуса git

```bash
# Проверить состояние репозитория
cd /var/lib/ansible/pull
git status
git log --oneline -10
```

---

## 📋 Параметры ansible-pull

| Параметр | Описание |
|----------|---------|
| `-U, --url` | URL репозитория (обязательный) |
| `-d, --directory` | Директория для клонирования (по умолчанию: ~/.ansible/pull) |
| `-i, --inventory` | Файл inventory |
| `-v, --verbose` | Подробный вывод |
| `-C, --checkout` | Ветка/тег для checkout |
| `-m, --module-name` | Модуль для загрузки репозитория (git, hg, svn) |
| `--clean` | Удалить репозиторий перед обновлением |

---

## 🔧 Устранение неполадок

### Проблема: Permission denied при запуске cron

```bash
# Решение: Добавить необходимые права в sudoers
sudo visudo

# Добавить строку:
%ansible ALL=(ALL) NOPASSWD: /usr/bin/ansible-pull
```

### Проблема: Git ошибка при pull

```bash
# Решение: Очистить репозиторий
sudo rm -rf /var/lib/ansible/pull
sudo ansible-pull -U https://github.com/your-username/ansible-repo.git --clean -d /var/lib/ansible/pull local.yml
```

### Проблема: Плейбук не выполняется

```bash
# Проверка синтаксиса
ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml

# Расширенный вывод
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -vvv
```

---

## 📁 Структура проекта

```
ansible-repo/
├── ansible.cfg              # Конфигурация Ansible
├── inventory                # Файл inventory (localhost)
├── local.yml               # Основной плейбук
├── group_vars/             # Переменные для групп
├── host_vars/              # Переменные для хостов
└── roles/
    ├── common/
    │   └── tasks/main.yml  # Общие задачи
    ├── web/
    │   └── tasks/main.yml  # Задачи для веб-сервера
    └── monitoring/
        └── tasks/main.yml  # Задачи для мониторинга
```

---

## 📚 Документация

- **REPORT.md** - Полный отчет для сдачи с примерами
- **README.md** - Подробная документация
- **COMMANDS.md** - Все команды с объяснениями
- **ansible-repo/** - Готовые конфигурационные файлы

---

## ✨ Полезные ссылки

- [Официальная документация Ansible](https://docs.ansible.com/)
- [ansible-pull документация](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html)
- [Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

