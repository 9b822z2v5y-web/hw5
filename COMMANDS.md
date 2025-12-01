# Все команды для Ansible-Pull Deployment

## 🔧 КОМАНДЫ ДЛЯ АДМИНИСТРАТОРА (на своем компьютере)

### 1. Проверка структуры проекта
```bash
cd /Users/bogdanchupakhin/Documents/hw5
ls -la ansible-repo/
find ansible-repo -type f
```

### 2. Проверка синтаксиса плейбука
```bash
ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml
```

### 3. Проверка подключения к localhost
```bash
ansible localhost -i ansible-repo/inventory -m ping
```

### 4. Локальное выполнение плейбука (тестирование)
```bash
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v
```

### 5. Выполнение через ansible-pull (с локальным репозиторием)
```bash
sudo ansible-pull -U /Users/bogdanchupakhin/Documents/hw5/ansible-repo -d /tmp/ansible-pull -i inventory local.yml -v
```

### 6. Запуск демо-скриптов
```bash
# Интерактивная полная демонстрация
bash /Users/bogdanchupakhin/Documents/hw5/demo.sh

# Краткая демонстрация
bash /Users/bogdanchupakhin/Documents/hw5/demo-simple.sh
```

### 7. Просмотр содержимого файлов
```bash
# Основной плейбук
cat ansible-repo/local.yml

# Роли
cat ansible-repo/roles/common/tasks/main.yml
cat ansible-repo/roles/web/tasks/main.yml
cat ansible-repo/roles/monitoring/tasks/main.yml

# Конфигурация
cat ansible-repo/ansible.cfg
cat ansible-repo/inventory
```

### 8. Подготовка к загрузке в Git (если нужно)
```bash
cd ansible-repo
git init
git add .
git config user.email "admin@example.com"
git config user.name "Admin"
git commit -m "Initial ansible-pull configuration"

# Добавить удаленный репозиторий (замените URL)
git remote add origin https://github.com/your-repo/ansible-pull.git
git branch -M main
git push -u origin main
```

---

## 💻 КОМАНДЫ НА ЦЕЛЕВОЙ ВИРТУАЛЬНОЙ МАШИНЕ (VM)

### 1. SSH на целевую машину
```bash
ssh user@target-vm-ip
# или
ssh user@target-vm-hostname
```

### 2. Обновление системы
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### 3. Установка необходимых пакетов
```bash
sudo apt-get install -y ansible git curl wget python3
```

### 4. ПЕРВОЕ РАЗВЕРТЫВАНИЕ - вариант 1 (с GitHub)
```bash
sudo ansible-pull \
  -U https://github.com/your-username/ansible-pull.git \
  -d /var/lib/ansible/pull \
  -i inventory \
  -l localhost \
  local.yml \
  -v
```

### 5. ПЕРВОЕ РАЗВЕРТЫВАНИЕ - вариант 2 (с локального сервера)
```bash
sudo ansible-pull \
  -U ssh://user@admin-server:/path/to/ansible-repo \
  -d /var/lib/ansible/pull \
  local.yml \
  -v
```

### 6. Проверка результатов развертывания
```bash
# Просмотр статуса
cat /opt/monitoring/status.conf

# Просмотр конфигурации приложения
cat /opt/application/config/app.conf

# Просмотр логов
tail -50 /var/log/ansible-pull.log

# Список файлов развертывания
ls -la /opt/monitoring/
ls -la /opt/application/config/
```

### 7. Запуск скрипта мониторинга
```bash
/opt/monitoring/check_system.sh
```

### 8. Просмотр логов ansible-pull в реальном времени
```bash
sudo tail -f /var/log/ansible-pull.log
```

### 9. Настройка crontab для автоматических обновлений
```bash
sudo crontab -e
```

Добавить одну из следующих строк:

#### Вариант А: Каждые 30 минут
```bash
*/30 * * * * /usr/bin/ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull -i inventory -l localhost local.yml >> /var/log/ansible-pull.log 2>&1
```

#### Вариант Б: Ежечасно (в начало часа)
```bash
0 * * * * /usr/bin/ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull -i inventory -l localhost local.yml >> /var/log/ansible-pull.log 2>&1
```

#### Вариант В: Ежедневно в 3:00 AM
```bash
0 3 * * * /usr/bin/ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull -i inventory -l localhost local.yml >> /var/log/ansible-pull.log 2>&1
```

#### Вариант Г: Ежедневно в 22:00 (10 PM)
```bash
0 22 * * * /usr/bin/ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull -i inventory -l localhost local.yml >> /var/log/ansible-pull.log 2>&1
```

### 10. Проверка установленной cron работы
```bash
sudo crontab -l
```

### 11. Проверка логов cron
```bash
# На Ubuntu/Debian
grep CRON /var/log/syslog | tail -20

# На CentOS/RHEL
sudo tail -20 /var/log/cron
```

### 12. Ручное обновление конфигурации (когда обновления в Git)
```bash
sudo ansible-pull \
  -U https://github.com/your-repo/ansible-pull.git \
  -d /var/lib/ansible/pull \
  -i inventory \
  -l localhost \
  local.yml \
  -v
```

### 13. Полное переустановление (удалить старый клон и переустановить)
```bash
sudo ansible-pull \
  -U https://github.com/your-repo/ansible-pull.git \
  -d /var/lib/ansible/pull \
  --full \
  -i inventory \
  -l localhost \
  local.yml \
  -v
```

---

## 📊 КОМАНДЫ ДЛЯ ПРОВЕРКИ И ДИАГНОСТИКИ

### На администраторском компьютере:

#### 1. Проверить установку Ansible
```bash
ansible --version
ansible-playbook --version
ansible-pull --version
```

#### 2. Показать информацию о хостах
```bash
ansible-inventory -i ansible-repo/inventory --host localhost
```

#### 3. Выполнить только определенные теги
```bash
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -t common -v
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -t web -v
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -t monitoring -v
```

#### 4. Dry-run (без применения изменений)
```bash
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml --check -v
```

### На целевой VM:

#### 1. Проверить версию Ansible
```bash
ansible --version
```

#### 2. Просмотреть содержимое клонированного репозитория
```bash
ls -la /var/lib/ansible/pull/
cat /var/lib/ansible/pull/local.yml
```

#### 3. Проверить права доступа
```bash
ls -la /opt/
ls -la /opt/monitoring/
ls -la /opt/application/
```

#### 4. Проверить работу веб-сервера (если установлен)
```bash
sudo systemctl status nginx
# или
sudo systemctl status apache2
# или
sudo service nginx status
```

#### 5. Протестировать веб-страницу
```bash
curl http://localhost/
```

#### 6. Проверить расписание cron
```bash
sudo crontab -l
```

#### 7. Проверить историю cron выполнения
```bash
grep ansible-pull /var/log/syslog | tail -10
```

---

## 🧹 КОМАНДЫ ОЧИСТКИ (если нужно откатить изменения)

### На целевой VM:

```bash
# 1. Удалить клонированный репозиторий
sudo rm -rf /var/lib/ansible/pull/

# 2. Удалить логи
sudo rm /var/log/ansible-pull.log

# 3. Удалить созданные директории приложения
sudo rm -rf /opt/application/
sudo rm -rf /opt/monitoring/

# 4. Удалить веб-содержимое
sudo rm /var/www/html/index.html

# 5. Удалить cron запись
sudo crontab -e
# (удалить строку с ansible-pull)

# 6. Удалить Ansible (опционально)
sudo apt-get remove ansible git -y
```

---

## 📝 ПАРАМЕТРЫ ANSIBLE-PULL

```bash
ansible-pull [OPTIONS] [PLAYBOOK_URL]

ОСНОВНЫЕ ПАРАМЕТРЫ:
  -U URL, --url=URL              URL репозитория для клонирования (обязательный)
  -d DIR, --directory=DIR        Директория для сохранения репозитория
  -i INVENTORY, --inventory=INVENTORY  Файл инвентаря
  -l LIMIT, --limit=LIMIT        Ограничить выполнение определенными хостами
  -t TAG, --tags=TAG             Выполнить только определенные теги
  --skip-tags=TAG                Пропустить определенные теги
  -v, --verbose                  Verbose режим (можно использовать до -vvvv)
  --check                         Dry-run режим (без применения изменений)
  --clean                         Удалить локальный клон перед обновлением
  --full                          Полная переустановка
  -e KEY=VALUE                    Установить переменные
  --accept-host-key              Принять SSH ключ хоста
```

---

## 💡 ПРАКТИЧЕСКИЕ ПРИМЕРЫ

### Пример 1: Первоначальное развертывание с логами
```bash
sudo ansible-pull \
  -U https://github.com/username/ansible-repo.git \
  -d /var/lib/ansible/pull \
  local.yml \
  -v >> /tmp/ansible-pull-initial.log 2>&1
  
cat /tmp/ansible-pull-initial.log
```

### Пример 2: Обновление конфигурации (чистая переустановка)
```bash
sudo ansible-pull \
  -U https://github.com/username/ansible-repo.git \
  -d /var/lib/ansible/pull \
  --full \
  local.yml \
  -v
```

### Пример 3: Запуск только мониторинга роли
```bash
ansible-playbook \
  -i /var/lib/ansible/pull/inventory \
  -c local \
  /var/lib/ansible/pull/local.yml \
  -t monitoring \
  -v
```

### Пример 4: Установка переменной при запуске
```bash
sudo ansible-pull \
  -U https://github.com/username/ansible-repo.git \
  -d /var/lib/ansible/pull \
  -e "env_name=staging" \
  local.yml \
  -v
```

### Пример 5: Cron с отправкой результатов по почте
```bash
0 3 * * * /usr/bin/ansible-pull \
  -U https://github.com/username/ansible-repo.git \
  -d /var/lib/ansible/pull \
  local.yml >> /var/log/ansible-pull.log 2>&1 && \
  echo "Ansible-pull executed successfully" | mail -s "Ansible-Pull Report" admin@example.com
```

---

**Все команды готовы к использованию!** ✅
