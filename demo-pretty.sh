#!/bin/bash

# 🎬 КРАСИВАЯ ДЕМОНСТРАЦИЯ ANSIBLE-PULL
# Полный вывод для скриншотов и презентации

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m'

# Функция для паузы между выводами
press_enter() {
    echo ""
    read -p "$(echo -e "${YELLOW}Нажмите Enter для продолжения...${NC}")"
}

# Функция для красивого заголовка
print_header() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║     🚀  ANSIBLE-PULL: РАЗВЕРТЫВАНИЕ ИЗ GIT РЕПОЗИТОРИЯ      ║
    ║                                                               ║
    ║     Pull-based Configuration Management                       ║
    ║     (Вытягивающее управление конфигурацией)                 ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 1: ЧТО ТАКОЕ ANSIBLE-PULL
# ════════════════════════════════════════════════════════════════

slide_1_what_is() {
    print_header
    
    echo -e "${CYAN}📚 ЧТО ТАКОЕ ANSIBLE-PULL?${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}Ansible-pull${NC} - это инструмент для управления конфигурацией машин"
    echo "на основе Pull-модели (вытягивающей архитектуры)."
    echo ""
    
    echo -e "${WHITE}Как это работает:${NC}"
    echo ""
    echo "  1️⃣  Целевая машина подключается к репозиторию (GitHub, GitLab, etc.)"
    echo "  2️⃣  Клонирует или обновляет репозиторий"
    echo "  3️⃣  Выполняет плейбук локально"
    echo "  4️⃣  Логирует результаты выполнения"
    echo ""
    
    echo -e "${WHITE}Преимущества:${NC}"
    echo "  ✅ Не требует SSH доступа администратора к целевым хостам"
    echo "  ✅ Работает за NAT и firewall"
    echo "  ✅ Масштабируется на тысячи машин"
    echo "  ✅ Автоматизация через cron (периодическое применение)"
    echo "  ✅ Git-based версионирование конфигурации"
    echo "  ✅ Каждая машина работает независимо"
    echo ""
    
    echo -e "${CYAN}Сравнение с обычным Ansible:${NC}"
    echo ""
    echo -e "${MAGENTA}Обычный Ansible:${NC}"
    echo "  ansible@admin-machine → (SSH) → target-vm"
    echo "  PUSH-модель (администратор отправляет конфигурацию)"
    echo ""
    echo -e "${MAGENTA}Ansible-Pull:${NC}"
    echo "  target-vm → (git clone) → GitHub/GitLab"
    echo "  PULL-модель (машина сама забирает конфигурацию)"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 2: АРХИТЕКТУРА
# ════════════════════════════════════════════════════════════════

slide_2_architecture() {
    print_header
    
    echo -e "${CYAN}🏗️  АРХИТЕКТУРА ANSIBLE-PULL${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${MAGENTA}"
    cat << "EOF"
                        ┌─────────────────────┐
                        │  GitHub Репозиторий │
                        │  (ansible-repo)     │
                        │                     │
                        │ ├─ local.yml        │
                        │ ├─ inventory        │
                        │ └─ roles/           │
                        │   ├─ common/        │
                        │   ├─ web/           │
                        │   └─ monitoring/    │
                        └──────────┬──────────┘
                                   │
                                   │ git clone/pull
                                   │ (по HTTP/SSH)
                                   │
                        ┌──────────▼──────────┐
                        │  Целевая VM #1      │
                        │ (ansible-pull)      │
                        │                     │
                        │ 1. Клонирует        │
                        │ 2. Выполняет        │
                        │ 3. Логирует         │
                        └─────────────────────┘
                        
                        ┌─────────────────────┐
                        │  Целевая VM #2      │
                        │ (ansible-pull)      │
                        └─────────────────────┘
                        
                        ┌─────────────────────┐
                        │  Целевая VM #N      │
                        │ (ansible-pull)      │
                        └─────────────────────┘
EOF
    echo -e "${NC}"
    echo ""
    echo -e "${YELLOW}Каждая машина работает НЕЗАВИСИМО!${NC}"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 3: СТРУКТУРА ПРОЕКТА
# ════════════════════════════════════════════════════════════════

slide_3_structure() {
    print_header
    
    echo -e "${CYAN}📁 СТРУКТУРА ПРОЕКТА${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${MAGENTA}ansible-repo/${NC}"
    echo "│"
    echo "├─ 📄 ${YELLOW}local.yml${NC}                  ← Основной плейбук"
    echo "├─ 📄 ${YELLOW}ansible.cfg${NC}                ← Конфигурация Ansible"
    echo "├─ 📄 ${YELLOW}inventory${NC}                  ← Файл инвентаря"
    echo "│"
    echo "├─ 📁 ${CYAN}roles/${NC}"
    echo "│  │"
    echo "│  ├─ 📁 ${CYAN}common/${NC}"
    echo "│  │  └─ 📁 ${CYAN}tasks/${NC}"
    echo "│  │     └─ 📄 ${YELLOW}main.yml${NC}          ← Установка пакетов, создание директорий"
    echo "│  │"
    echo "│  ├─ 📁 ${CYAN}web/${NC}"
    echo "│  │  └─ 📁 ${CYAN}tasks/${NC}"
    echo "│  │     └─ 📄 ${YELLOW}main.yml${NC}          ← Настройка веб-сервера (Nginx)"
    echo "│  │"
    echo "│  └─ 📁 ${CYAN}monitoring/${NC}"
    echo "│     └─ 📁 ${CYAN}tasks/${NC}"
    echo "│        └─ 📄 ${YELLOW}main.yml${NC}          ← Инструменты мониторинга"
    echo "│"
    echo "├─ 📁 ${CYAN}group_vars/${NC}                 ← Переменные для групп"
    echo "├─ 📁 ${CYAN}host_vars/${NC}                  ← Переменные для хостов"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 4: СОДЕРЖИМОЕ ФАЙЛОВ
# ════════════════════════════════════════════════════════════════

slide_4_files() {
    print_header
    
    echo -e "${CYAN}📄 СОДЕРЖИМОЕ КЛЮЧЕВЫХ ФАЙЛОВ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # local.yml
    echo -e "${YELLOW}1️⃣  local.yml (основной плейбук):${NC}"
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    cat << 'EOF'
---
- name: Configure Local Machine with ansible-pull
  hosts: localhost
  become: true
  connection: local
  gather_facts: yes

  roles:
    - role: common
      tags: ['common']
    - role: web
      tags: ['web']
    - role: monitoring
      tags: ['monitoring']
EOF
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    echo ""
    
    # inventory
    echo -e "${YELLOW}2️⃣  inventory (хосты):${NC}"
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    cat << 'EOF'
[local]
localhost ansible_connection=local

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 5: РОЛИ - COMMON
# ════════════════════════════════════════════════════════════════

slide_5_common_role() {
    print_header
    
    echo -e "${CYAN}🔧 РОЛЬ: COMMON (базовая конфигурация)${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}Что делает эта роль:${NC}"
    echo "  ✓ Обновляет кэш пакетов (apt/yum)"
    echo "  ✓ Устанавливает базовые утилиты:"
    echo "    - curl, wget, git, vim, htop, net-tools, tree"
    echo "  ✓ Создает структуру директорий для приложения:"
    echo "    - /opt/application/"
    echo "    - /opt/application/logs/"
    echo "    - /opt/application/config/"
    echo "  ✓ Генерирует конфигурационный файл приложения"
    echo ""
    
    echo -e "${YELLOW}Пример задачи:${NC}"
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    cat << 'EOF'
- name: Install basic utilities
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
EOF
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 6: РОЛИ - WEB
# ════════════════════════════════════════════════════════════════

slide_6_web_role() {
    print_header
    
    echo -e "${CYAN}🌐 РОЛЬ: WEB (веб-сервер)${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}Что делает эта роль:${NC}"
    echo "  ✓ Устанавливает Nginx (на Debian/Ubuntu)"
    echo "    или Apache (на RedHat/CentOS)"
    echo "  ✓ Включает и запускает сервис"
    echo "  ✓ Создает и развертывает приветственную HTML страницу"
    echo "  ✓ Проверяет статус сервиса"
    echo ""
    
    echo -e "${YELLOW}Результат:${NC}"
    echo "  📍 Веб-сервер доступен по адресу: http://localhost/"
    echo "  📍 Главная страница: /var/www/html/index.html"
    echo ""
    
    echo -e "${YELLOW}Пример задачи:${NC}"
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    cat << 'EOF'
- name: Install Nginx
  apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"
  become: true

- name: Enable nginx service
  systemd:
    name: nginx
    enabled: yes
    state: started
EOF
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 7: РОЛИ - MONITORING
# ════════════════════════════════════════════════════════════════

slide_7_monitoring_role() {
    print_header
    
    echo -e "${CYAN}📊 РОЛЬ: MONITORING (мониторинг и логирование)${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}Что делает эта роль:${NC}"
    echo "  ✓ Устанавливает инструменты мониторинга:"
    echo "    - htop, sysstat, iotop, nethogs"
    echo "  ✓ Создает директорию /opt/monitoring/"
    echo "  ✓ Создает скрипт проверки статуса системы"
    echo "  ✓ Генерирует файл конфигурации мониторинга"
    echo "  ✓ Создает логи развертывания"
    echo ""
    
    echo -e "${YELLOW}Результат:${NC}"
    echo "  📁 /opt/monitoring/system.log    - логи системы"
    echo "  📁 /opt/monitoring/status.conf   - статус развертывания"
    echo "  📁 /opt/monitoring/check_system.sh - скрипт проверки"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 8: КОМАНДЫ - ПОДГОТОВКА
# ════════════════════════════════════════════════════════════════

slide_8_commands_prep() {
    print_header
    
    echo -e "${CYAN}🚀 КОМАНДЫ: ПОДГОТОВКА И ПРОВЕРКА${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}1️⃣  Установка Ansible:${NC}"
    echo -e "${MAGENTA}$ sudo apt-get update${NC}"
    echo -e "${MAGENTA}$ sudo apt-get install -y ansible git${NC}"
    echo ""
    
    echo -e "${YELLOW}2️⃣  Проверка синтаксиса плейбука:${NC}"
    echo -e "${MAGENTA}$ ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml${NC}"
    echo ""
    
    echo -e "${YELLOW}3️⃣  Проверка подключения:${NC}"
    echo -e "${MAGENTA}$ ansible localhost -i ansible-repo/inventory -m ping${NC}"
    echo ""
    echo -e "${GREEN}# Вывод: localhost | SUCCESS => { \"ping\": \"pong\" }${NC}"
    echo ""
    
    echo -e "${YELLOW}4️⃣  Локальное тестирование:${NC}"
    echo -e "${MAGENTA}$ ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v${NC}"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 9: КОМАНДЫ - ANSIBLE-PULL
# ════════════════════════════════════════════════════════════════

slide_9_commands_pull() {
    print_header
    
    echo -e "${CYAN}🚀 КОМАНДЫ: ANSIBLE-PULL РАЗВЕРТЫВАНИЕ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}НА ЦЕЛЕВОЙ ВИРТУАЛЬНОЙ МАШИНЕ:${NC}"
    echo ""
    
    echo -e "${YELLOW}1️⃣  Установка зависимостей:${NC}"
    echo -e "${MAGENTA}$ sudo apt-get update${NC}"
    echo -e "${MAGENTA}$ sudo apt-get install -y ansible git python3${NC}"
    echo ""
    
    echo -e "${YELLOW}2️⃣  Создание директории для клона:${NC}"
    echo -e "${MAGENTA}$ sudo mkdir -p /var/lib/ansible/pull${NC}"
    echo -e "${MAGENTA}$ sudo chown ansible:ansible /var/lib/ansible/pull${NC}"
    echo ""
    
    echo -e "${YELLOW}3️⃣  ПЕРВЫЙ ЗАПУСК ansible-pull:${NC}"
    echo -e "${MAGENTA}$ sudo ansible-pull \\${NC}"
    echo -e "${MAGENTA}    -U https://github.com/your-repo/ansible-repo.git \\${NC}"
    echo -e "${MAGENTA}    -d /var/lib/ansible/pull \\${NC}"
    echo -e "${MAGENTA}    local.yml -v${NC}"
    echo ""
    
    echo -e "${YELLOW}Что происходит:${NC}"
    echo "  1. Репозиторий клонируется в /var/lib/ansible/pull"
    echo "  2. Запускается плейбук local.yml"
    echo "  3. Применяются все роли (common, web, monitoring)"
    echo "  4. Результаты логируются в /var/log/ansible-pull.log"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 10: АВТОМАТИЗАЦИЯ ЧЕРЕЗ CRON
# ════════════════════════════════════════════════════════════════

slide_10_cron() {
    print_header
    
    echo -e "${CYAN}⏰ АВТОМАТИЗАЦИЯ: CRON ДЛЯ ПЕРИОДИЧЕСКОГО ОБНОВЛЕНИЯ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}Отредактируем crontab:${NC}"
    echo -e "${MAGENTA}$ sudo crontab -e${NC}"
    echo ""
    
    echo -e "${YELLOW}Добавим одну из строк:${NC}"
    echo ""
    
    echo -e "${CYAN}📌 Вариант 1: Каждые 30 минут${NC}"
    echo -e "${MAGENTA}*/30 * * * * ansible-pull -U https://github.com/user/ansible-repo.git \\${NC}"
    echo -e "${MAGENTA}  -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1${NC}"
    echo ""
    
    echo -e "${CYAN}📌 Вариант 2: Ежечасно (в начало часа)${NC}"
    echo -e "${MAGENTA}0 * * * * ansible-pull -U https://github.com/user/ansible-repo.git \\${NC}"
    echo -e "${MAGENTA}  -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1${NC}"
    echo ""
    
    echo -e "${CYAN}📌 Вариант 3: Ежедневно в 3:00 AM${NC}"
    echo -e "${MAGENTA}0 3 * * * ansible-pull -U https://github.com/user/ansible-repo.git \\${NC}"
    echo -e "${MAGENTA}  -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1${NC}"
    echo ""
    
    echo -e "${YELLOW}Преимущества:${NC}"
    echo "  ✓ Конфигурация обновляется автоматически"
    echo "  ✓ Изменения в Git репозитории применяются автоматически"
    echo "  ✓ Логируются в /var/log/ansible-pull.log"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 11: ПРОВЕРКА РЕЗУЛЬТАТОВ
# ════════════════════════════════════════════════════════════════

slide_11_check_results() {
    print_header
    
    echo -e "${CYAN}✅ ПРОВЕРКА РЕЗУЛЬТАТОВ РАЗВЕРТЫВАНИЯ${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}1️⃣  Проверить статус:${NC}"
    echo -e "${MAGENTA}$ cat /opt/monitoring/status.conf${NC}"
    echo -e "${GREEN}# Результат:${NC}"
    echo "DEPLOYMENT_STATUS=SUCCESS"
    echo "DEPLOYMENT_TIME=2024-12-01T10:30:45.123456Z"
    echo "HOSTNAME=target-vm"
    echo "OS=Ubuntu"
    echo ""
    
    echo -e "${YELLOW}2️⃣  Проверить конфигурацию:${NC}"
    echo -e "${MAGENTA}$ cat /opt/application/config/app.conf${NC}"
    echo ""
    
    echo -e "${YELLOW}3️⃣  Проверить логи ansible-pull:${NC}"
    echo -e "${MAGENTA}$ sudo tail -50 /var/log/ansible-pull.log${NC}"
    echo ""
    
    echo -e "${YELLOW}4️⃣  Проверить веб-сервер:${NC}"
    echo -e "${MAGENTA}$ curl http://localhost/${NC}"
    echo -e "${GREEN}# Результат: HTML страница с информацией о развертывании${NC}"
    echo ""
    
    echo -e "${YELLOW}5️⃣  Запустить скрипт мониторинга:${NC}"
    echo -e "${MAGENTA}$ /opt/monitoring/check_system.sh${NC}"
    echo ""
    
    press_enter
}

# ════════════════════════════════════════════════════════════════
# СЛАЙД 12: ИТОГОВАЯ СВОДКА
# ════════════════════════════════════════════════════════════════

slide_12_summary() {
    print_header
    
    echo -e "${CYAN}📋 ИТОГОВАЯ СВОДКА${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${WHITE}✅ ЧТО МЫ РЕАЛИЗОВАЛИ:${NC}"
    echo ""
    echo "  1️⃣  Структура ansible-pull проекта с 3 ролями"
    echo "  2️⃣  Автоматизированное развертывание конфигурации"
    echo "  3️⃣  Установку базовых пакетов и утилит"
    echo "  4️⃣  Настройку веб-сервера (Nginx)"
    echo "  5️⃣  Инструменты мониторинга и логирования"
    echo ""
    
    echo -e "${WHITE}✅ ПРЕИМУЩЕСТВА РЕШЕНИЯ:${NC}"
    echo ""
    echo "  🔄 Децентрализованная архитектура"
    echo "  📈 Масштабируется на тысячи машин"
    echo "  🔐 Не требует SSH доступа администратора"
    echo "  🚀 Работает за NAT и firewall"
    echo "  ⏰ Автоматизация через cron"
    echo "  📝 Git-based версионирование"
    echo "  📊 Полное логирование операций"
    echo ""
    
    echo -e "${WHITE}📁 КЛЮЧЕВЫЕ ФАЙЛЫ:${NC}"
    echo ""
    echo "  • REPORT.md           - Полный отчет"
    echo "  • QUICK-START.md      - Быстрый старт"
    echo "  • COMMANDS.md         - Все команды"
    echo "  • demo-ansible-pull.sh - Интерактивная демонстрация"
    echo ""
    
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✨ ДЕМОНСТРАЦИЯ ЗАВЕРШЕНА!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Используйте эту демонстрацию для создания скриншотов.${NC}"
    echo -e "${YELLOW}Каждый слайд содержит информацию для презентации.${NC}"
    echo ""
}

# ════════════════════════════════════════════════════════════════
# ГЛАВНОЕ МЕНЮ
# ════════════════════════════════════════════════════════════════

show_menu() {
    while true; do
        clear
        echo -e "${CYAN}"
        cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════╗
    ║     🎬  ИНТЕРАКТИВНАЯ ДЕМОНСТРАЦИЯ ANSIBLE-PULL              ║
    ║                                                               ║
    ║            Выберите слайд для просмотра                      ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
        
        echo -e "${YELLOW}Слайды:${NC}"
        echo ""
        echo "  1️⃣  Что такое Ansible-Pull?"
        echo "  2️⃣  Архитектура решения"
        echo "  3️⃣  Структура проекта"
        echo "  4️⃣  Содержимое файлов"
        echo "  5️⃣  Роль: Common"
        echo "  6️⃣  Роль: Web"
        echo "  7️⃣  Роль: Monitoring"
        echo "  8️⃣  Команды: Подготовка и проверка"
        echo "  9️⃣  Команды: Ansible-Pull"
        echo "  🔟 Автоматизация: Cron"
        echo "  1️⃣1️⃣  Проверка результатов"
        echo "  1️⃣2️⃣  Итоговая сводка"
        echo "  🎯 Все слайды подряд (автоматически)"
        echo ""
        echo "  0️⃣  Выход"
        echo ""
        echo -e "${YELLOW}Выберите номер:${NC} "
        read -r choice
        
        case $choice in
            1) slide_1_what_is ;;
            2) slide_2_architecture ;;
            3) slide_3_structure ;;
            4) slide_4_files ;;
            5) slide_5_common_role ;;
            6) slide_6_web_role ;;
            7) slide_7_monitoring_role ;;
            8) slide_8_commands_prep ;;
            9) slide_9_commands_pull ;;
            10) slide_10_cron ;;
            11) slide_11_check_results ;;
            12) slide_12_summary ;;
            *)
                # Автоматическое прохождение всех слайдов
                clear
                slide_1_what_is
                slide_2_architecture
                slide_3_structure
                slide_4_files
                slide_5_common_role
                slide_6_web_role
                slide_7_monitoring_role
                slide_8_commands_prep
                slide_9_commands_pull
                slide_10_cron
                slide_11_check_results
                slide_12_summary
                echo ""
                echo -e "${GREEN}✅ Все слайды показаны!${NC}"
                echo ""
                read -p "Нажмите Enter для возврата в меню..."
                continue
                ;;
            0)
                clear
                echo -e "${GREEN}👋 До встречи!${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Неверный выбор${NC}"
                sleep 1
                ;;
        esac
    done
}

# ════════════════════════════════════════════════════════════════
# ГЛАВНАЯ ПРОГРАММА
# ════════════════════════════════════════════════════════════════

if [ "$1" == "auto" ]; then
    # Автоматическое прохождение всех слайдов
    slide_1_what_is
    slide_2_architecture
    slide_3_structure
    slide_4_files
    slide_5_common_role
    slide_6_web_role
    slide_7_monitoring_role
    slide_8_commands_prep
    slide_9_commands_pull
    slide_10_cron
    slide_11_check_results
    slide_12_summary
else
    # Интерактивное меню
    show_menu
fi
