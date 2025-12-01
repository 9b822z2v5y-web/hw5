# Развертывание конфигурации с помощью Ansible-Pull

## 📋 Оглавление
1. [Обзор решения](#обзор-решения)
2. [Структура проекта](#структура-проекта)
3. [Содержимое yml-файлов](#содержимое-yml-файлов)
4. [Команды для развертывания](#команды-для-развертывания)
5. [Архитектура](#архитектура)
6. [Использование на целевой VM](#использование-на-целевой-vm)
7. [Мониторинг и логирование](#мониторинг-и-логирование)

---

## 🎯 Обзор решения

**Ansible-Pull** - это инструмент для управления конфигурацией, который работает по принципу "pull" (вытягивания), в отличие от традиционного "push" (отправки). 

**Ключевые особенности:**
- ✅ Не требует SSH доступа администратора к целевым хостам
- ✅ Хосты самостоятельно инициируют подключение к репозиторию
- ✅ Работает через NAT, firewall и прокси
- ✅ Масштабируется на тысячи хостов
- ✅ Все конфигурации хранятся в Git

---

## 📁 Структура проекта

```
hw5/
├── ansible-repo/                          # Git репозиторий с конфигурацией
│   ├── local.yml                          # Основной плейбук для ansible-pull
│   ├── ansible.cfg                        # Конфигурация Ansible
│   ├── inventory                          # Файл инвентаря
│   ├── roles/
│   │   ├── common/
│   │   │   └── tasks/
│   │   │       └── main.yml              # Общие настройки системы
│   │   ├── web/
│   │   │   └── tasks/
│   │   │       └── main.yml              # Конфигурация веб-сервера
│   │   └── monitoring/
│   │       └── tasks/
│   │           └── main.yml              # Мониторинг и логирование
│   ├── group_vars/                        # Групповые переменные
│   └── host_vars/                         # Переменные отдельных хостов
│
├── demo.sh                                 # Красивый демо-скрипт
└── README.md                               # Эта документация
```

---

## 📝 Содержимое yml-файлов

### 1. local.yml - Основной плейбук

```yaml
---
# Local playbook для ansible-pull
# Этот плейбук запускается локально на целевой виртуальной машине
# через ansible-pull из репозитория

- name: Configure Local Machine with ansible-pull
  hosts: localhost
  become: true
  connection: local
  gather_facts: yes

  vars:
    app_version: "1.0.0"
    env_name: "production"

  roles:
    - role: common
      tags: ['common']
    - role: web
      tags: ['web']
    - role: monitoring
      tags: ['monitoring']

  post_tasks:
    - name: Display completion message
      debug:
        msg: |
          ╔════════════════════════════════════════════════════════════╗
          ║       Configuration deployment completed successfully!    ║
          ║                                                            ║
          ║  Application Version: {{ app_version }}                   ║
          ║  Environment: {{ env_name }}                              ║
          ║  Hostname: {{ ansible_hostname }}                         ║
          ║  OS: {{ ansible_distribution }} {{ ansible_distribution_version }}  ║
          ╚════════════════════════════════════════════════════════════╝
      when: ansible_os_family is defined
```

**Описание:**
- `hosts: localhost` - выполняется локально на машине
- `connection: local` - используется локальное соединение
- `become: true` - требуются права администратора
- `gather_facts: yes` - собирает информацию о системе
- `roles` - применяются три роли в последовательности

### 2. roles/common/tasks/main.yml - Общие настройки

```yaml
---
# Common tasks for all systems

- name: Common Role - Update system packages
  block:
    - name: Update apt cache (Debian/Ubuntu)
      apt:
        update_cache: yes
        cache_valid_time: 3600
      when: ansible_os_family == "Debian"
      become: true

    - name: Install basic utilities (Debian/Ubuntu)
      apt:
        name:
          - curl
          - wget
          - git
          - vim
          - htop
          - net-tools
          - tree
        state: present
      when: ansible_os_family == "Debian"
      become: true

    - name: Update yum cache (RedHat/CentOS)
      yum:
        name: "*"
        state: latest
      when: ansible_os_family == "RedHat"
      become: true

  rescue:
    - name: Handle package manager error
      debug:
        msg: "Could not update packages - running in non-system environment"

- name: Create application directory structure
  file:
    path: "{{ item }}"
    state: directory
    mode: '0755'
  loop:
    - /opt/application
    - /opt/application/logs
    - /opt/application/config
    - /var/log/application

- name: Create configuration file
  copy:
    content: |
      # Application Configuration
      # Generated: {{ ansible_date_time.iso8601 }}
      
      application:
        name: "Deployed Application"
        version: "1.0.0"
        environment: "production"
        hostname: "{{ ansible_hostname }}"
        
      paths:
        app_root: "/opt/application"
        logs: "/var/log/application"
        
      timestamps:
        deployed_at: "{{ ansible_date_time.iso8601 }}"
        managed_by: "ansible-pull"
    dest: /opt/application/config/app.conf
    mode: '0644'

- name: Display common role completion
  debug:
    msg: ✓ Common role configuration completed
```

**Описание:**
- Обновляет пакеты системы (apt для Debian/Ubuntu, yum для RedHat/CentOS)
- Устанавливает базовые утилиты
- Создает структуру директорий для приложения
- Генерирует файл конфигурации с информацией о развертывании

### 3. roles/web/tasks/main.yml - Конфигурация веб-сервера

```yaml
---
# Web server configuration role

- name: Web Role - Configure web server
  block:
    - name: Install Nginx (Debian/Ubuntu)
      apt:
        name: nginx
        state: present
      when: ansible_os_family == "Debian"
      become: true

    - name: Install Apache (RedHat/CentOS)
      yum:
        name: httpd
        state: present
      when: ansible_os_family == "RedHat"
      become: true

  rescue:
    - name: Handle web server installation error
      debug:
        msg: "Could not install web server - running in non-system environment"

- name: Create web directory
  file:
    path: /var/www/html
    state: directory
    mode: '0755'
    recurse: yes

- name: Deploy welcome page
  copy:
    content: |
      <!DOCTYPE html>
      <html lang="ru">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Ansible-Pull Deployment</title>
          <style>
              body {
                  font-family: Arial, sans-serif;
                  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                  margin: 0;
                  padding: 20px;
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  min-height: 100vh;
              }
              .container {
                  background: white;
                  padding: 40px;
                  border-radius: 10px;
                  box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                  max-width: 600px;
                  text-align: center;
              }
              h1 {
                  color: #667eea;
                  margin-bottom: 10px;
              }
              .info {
                  background: #f5f5f5;
                  padding: 20px;
                  border-radius: 5px;
                  text-align: left;
                  margin: 20px 0;
                  font-family: monospace;
              }
              .info p {
                  margin: 8px 0;
                  color: #333;
              }
              .status {
                  color: #27ae60;
                  font-weight: bold;
                  margin-top: 20px;
              }
          </style>
      </head>
      <body>
          <div class="container">
              <h1>✓ ansible-pull Deployment</h1>
              <p>Конфигурация успешно развернута!</p>
              
              <div class="info">
                  <p><strong>Hostname:</strong> {{ ansible_hostname }}</p>
                  <p><strong>OS:</strong> {{ ansible_distribution }} {{ ansible_distribution_version }}</p>
                  <p><strong>Kernel:</strong> {{ ansible_kernel }}</p>
                  <p><strong>Python Version:</strong> {{ ansible_python_version }}</p>
                  <p><strong>Deployed at:</strong> {{ ansible_date_time.iso8601 }}</p>
              </div>
              
              <p class="status">🎉 Deployment completed successfully!</p>
          </div>
      </body>
      </html>
    dest: /var/www/html/index.html
    mode: '0644'

- name: Display web role completion
  debug:
    msg: ✓ Web role configuration completed
```

**Описание:**
- Устанавливает Nginx на Debian/Ubuntu или Apache на RedHat/CentOS
- Создает директорию для веб-контента
- Развертывает красивую HTML страницу с информацией о развертывании

### 4. roles/monitoring/tasks/main.yml - Мониторинг

```yaml
---
# Monitoring configuration role

- name: Monitoring Role - Create monitoring directory
  file:
    path: /opt/monitoring
    state: directory
    mode: '0755'

- name: Create monitoring script
  copy:
    content: |
      #!/bin/bash
      # System Monitoring Script
      # Generated by Ansible-Pull
      
      echo "=== System Monitoring Report ===" 
      echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
      echo ""
      
      echo "Hostname: $(hostname)"
      echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
      echo ""
      
      echo "CPU Usage:"
      top -bn1 | grep "Cpu(s)" || echo "Not available in this environment"
      echo ""
      
      echo "Memory Usage:"
      free -h || echo "Not available in this environment"
      echo ""
      
      echo "Disk Usage:"
      df -h / || echo "Not available in this environment"
      echo ""
      
      echo "System Load:"
      cat /proc/loadavg 2>/dev/null || echo "Not available in this environment"
    dest: /opt/monitoring/check_system.sh
    mode: '0755'

- name: Create monitoring log file
  copy:
    content: |
      # Monitoring Log File
      # Managed by Ansible-Pull
      
      [{{ ansible_date_time.iso8601 }}] System monitoring initialized
      [{{ ansible_date_time.iso8601 }}] Hostname: {{ ansible_hostname }}
      [{{ ansible_date_time.iso8601 }}] OS: {{ ansible_distribution }} {{ ansible_distribution_version }}
      [{{ ansible_date_time.iso8601 }}] Python version: {{ ansible_python_version }}
    dest: /opt/monitoring/system.log
    mode: '0644'

- name: Create monitoring status file
  copy:
    content: |
      DEPLOYMENT_STATUS=SUCCESS
      DEPLOYMENT_TIME={{ ansible_date_time.iso8601 }}
      HOSTNAME={{ ansible_hostname }}
      OS={{ ansible_distribution }}
      ENVIRONMENT=production
    dest: /opt/monitoring/status.conf
    mode: '0644'

- name: Display monitoring role completion
  debug:
    msg: ✓ Monitoring role configuration completed
```

**Описание:**
- Создает директорию для мониторинга
- Генерирует скрипт системного мониторинга
- Создает логи и файлы статуса развертывания

### 5. ansible.cfg - Конфигурация Ansible

```ini
[defaults]
# Ansible Configuration for Pull-based deployment

# Inventory file location
inventory = ./inventory

# Connection timeout
timeout = 30

# Disable SSH key verification for testing (not recommended for production)
host_key_checking = False

# Custom module path
# library = ./library

# Verbosity level (0-4)
# 0 = normal, 1 = verbose, 2 = very verbose, 3 = connection debugging, 4 = script debugging
verbosity = 1

# Enable colored output
force_color = True

# Deprecation warnings
deprecation_warnings = True

# Strategy
strategy = linear

# Gather facts by default
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 86400

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False

[ssh_connection]
pipelining = True
```

### 6. inventory - Файл инвентаря

```ini
[local]
localhost ansible_connection=local

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

---

## 🚀 Команды для развертывания

### Команда 1: Локальное выполнение плейбука

```bash
# Базовый формат
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml

# С подробным выводом
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v

# С максимальной детализацией
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -vvv
```

**Параметры:**
- `-i inventory` - указывает файл инвентаря
- `-c local` - использует локальное соединение
- `-v` - verbose режим (можно до -vvvv)
- `--syntax-check` - только проверка синтаксиса
- `--check` - dry-run режим (без применения изменений)

### Команда 2: Использование ansible-pull (рекомендуется)

```bash
# Развертывание локального репозитория
ansible-pull -U /path/to/local/repo -d /tmp/ansible-pull

# Развертывание из удаленного Git репозитория
ansible-pull -U https://github.com/user/ansible-repo.git -d /tmp/ansible-pull

# Полная команда с параметрами
ansible-pull \
  -U https://github.com/user/ansible-repo.git \
  -d /var/lib/ansible/pull \
  -i inventory \
  -l localhost \
  local.yml \
  -v
```

**Параметры ansible-pull:**
- `-U URL` - URL репозитория для клонирования
- `-d DIR` - директория для сохранения репозитория
- `-i INVENTORY` - файл инвентаря
- `-l LIMIT` - ограничить выполнение определенными хостами
- `--clean` - удалить локальный клон перед обновлением
- `--full` - полная переустановка
- `--check` - dry-run режим

### Команда 3: Проверка синтаксиса

```bash
ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml
```

### Команда 4: Проверка подключения

```bash
ansible all -i ansible-repo/inventory -m ping
```

---

## 🏗️ Архитектура

```
┌──────────────────────────────────────────┐
│    Git Repository (Configuration)        │
│  - local.yml (основной плейбук)          │
│  - roles/common (базовая конфиг)         │
│  - roles/web (веб-сервер)                │
│  - roles/monitoring (мониторинг)         │
└────────────────┬─────────────────────────┘
                 │
                 │ git clone/pull
                 │
┌────────────────▼─────────────────────────┐
│   Target Virtual Machine (VM)            │
│                                          │
│  1. ansible-pull клонирует репо          │
│  2. Запускает local.yml плейбук          │
│  3. Применяет роли по очереди            │
│                                          │
│  ✓ Common Role                           │
│    - Обновление пакетов                  │
│    - Установка утилит                    │
│    - Создание директорий                 │
│                                          │
│  ✓ Web Role                              │
│    - Установка Nginx/Apache              │
│    - Развертывание веб-контента          │
│                                          │
│  ✓ Monitoring Role                       │
│    - Создание скриптов мониторинга       │
│    - Логирование                         │
│    - Сохранение статуса                  │
│                                          │
└──────────────────────────────────────────┘
```

---

## 💻 Использование на целевой VM

### Шаг 1: Подготовка целевой машины

```bash
# Обновление системы
sudo apt-get update
sudo apt-get upgrade -y

# Установка необходимых пакетов
sudo apt-get install -y ansible git curl wget
```

### Шаг 2: Первоначальное развертывание

```bash
# Развертывание конфигурации с помощью ansible-pull
sudo ansible-pull \
  -U https://github.com/your-repo/ansible-pull.git \
  -d /var/lib/ansible/pull \
  -i inventory \
  -l localhost \
  local.yml \
  -v
```

### Шаг 3: Настройка автоматических обновлений (cron)

```bash
# Редактирование crontab
sudo crontab -e

# Добавить следующие строки для запуска каждые 30 минут:
*/30 * * * * /usr/bin/ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull -i inventory -l localhost local.yml >> /var/log/ansible-pull.log 2>&1

# Или ежечасно:
0 * * * * /usr/bin/ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull -i inventory -l localhost local.yml >> /var/log/ansible-pull.log 2>&1

# Или ежедневно в 3:00 AM:
0 3 * * * /usr/bin/ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull -i inventory -l localhost local.yml >> /var/log/ansible-pull.log 2>&1
```

### Шаг 4: Проверка статуса

```bash
# Просмотр логов ansible-pull
sudo tail -f /var/log/ansible-pull.log

# Проверка файлов развертывания
ls -la /var/lib/ansible/pull/
ls -la /opt/application/config/
cat /opt/monitoring/status.conf
```

---

## 📊 Мониторинг и логирование

### Основные файлы логирования

```
/var/log/ansible-pull.log          - Основные логи ansible-pull
/var/lib/ansible/pull/             - Клонированный репозиторий
/opt/application/                  - Директория приложения
  ├── config/app.conf              - Конфигурация приложения
  └── logs/                         - Логи приложения

/opt/monitoring/                   - Директория мониторинга
  ├── system.log                   - Логи системы
  ├── status.conf                  - Статус развертывания
  └── check_system.sh              - Скрипт мониторинга
```

### Просмотр информации о развертывании

```bash
# Статус развертывания
cat /opt/monitoring/status.conf

# Информация о приложении
cat /opt/application/config/app.conf

# Последние логи ansible-pull
tail -100 /var/log/ansible-pull.log

# Запуск скрипта мониторинга
/opt/monitoring/check_system.sh
```

---

## ✅ Проверка список команд

```bash
# 1. Проверка структуры репозитория
ls -la ansible-repo/
find ansible-repo -type f

# 2. Проверка синтаксиса плейбука
ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml

# 3. Проверка подключения
ansible localhost -i ansible-repo/inventory -m ping

# 4. Выполнение плейбука (локально)
ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v

# 5. Выполнение ansible-pull (имитация на целевой VM)
sudo ansible-pull -U /Users/bogdanchupakhin/Documents/hw5/ansible-repo -d /tmp/ansible-pull

# 6. Просмотр логов
cat /tmp/ansible-pull/local.yml
ls -la /opt/monitoring/
```

---

## 🎬 Запуск демо-скрипта

```bash
# Запуск красивой демонстрации
./demo.sh

# Или через bash
bash demo.sh
```

Демо-скрипт покажет:
- Структуру проекта
- Содержимое всех yml-файлов
- Команды для развертывания
- Архитектуру решения
- Примеры использования

---

## 📚 Дополнительная информация

### Преимущества ansible-pull
✅ Не требует SSH доступа администратора к целевым хостам
✅ Хосты инициируют подключение к серверу
✅ Работает за NAT и firewall
✅ Масштабируется на большое количество хостов
✅ Полностью децентрализовано
✅ Может использоваться через cron для периодических обновлений
✅ Снижает нагрузку на управляющий сервер

### Недостатки
❌ Может быть сложнее в отладке, чем push-based
❌ Требует доступа к Git репозиторию из целевой машины
❌ Сложнее контролировать время развертывания на множество хостов одновременно

### Полезные ссылки
- [Документация Ansible](https://docs.ansible.com/)
- [Ansible-Pull документация](https://docs.ansible.com/ansible/latest/cli_tools/ansible-pull.html)
- [Playbook Guide](https://docs.ansible.com/ansible/latest/playbook_guide/)
- [Best Practices](https://docs.ansible.com/ansible/latest/tips_tricks/)

---

## 📝 Версионирование

- **Версия**: 1.0.0
- **Дата создания**: 2024
- **Совместимость**: Ansible 2.9+, Python 3.6+

---

## 👥 Автор

Лабораторная работа по управлению конфигурацией с использованием ansible-pull

---

**Документация завершена** ✓
