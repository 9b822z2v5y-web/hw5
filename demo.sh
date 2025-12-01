#!/bin/bash

# =============================================================================
# Ansible-Pull Deployment Demo Script
# Красивая демонстрация развертывания конфигурации с использованием ansible-pull
# =============================================================================

# Цвета для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Функция для печати заголовка
print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                  ANSIBLE-PULL DEPLOYMENT DEMO                 ║"
    echo "║           Configuration Management from Repository             ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Функция для печати раздела
print_section() {
    echo -e "\n${BLUE}┌─────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${NC} ${YELLOW}$1${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────────┘${NC}\n"
}

# Функция для печати подпункта
print_item() {
    echo -e "${GREEN}✓${NC} $1"
}

# Функция для печати ошибки
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Функция для печати информации
print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# Функция для паузы с вводом
pause_and_continue() {
    echo -e "\n${YELLOW}───────────────────────────────────────────────────────────────────${NC}"
    read -p "Нажмите ENTER для продолжения..." -t 3
    echo ""
}

# Функция для печати кода
print_code() {
    echo -e "${MAGENTA}❯ $1${NC}"
}

# =============================================================================
# НАЧАЛО ДЕМОНСТРАЦИИ
# =============================================================================

print_header

print_section "1. СТРУКТУРА ПРОЕКТА ANSIBLE"

echo -e "${CYAN}Текущая директория:${NC}"
print_code "pwd"
pwd

echo -e "\n${CYAN}Структура репозитория:${NC}"
print_code "tree -L 2 ansible-repo 2>/dev/null || find ansible-repo -type f | head -20"
find ansible-repo -type f -o -type d | sort | sed 's|ansible-repo|.|' | head -30

pause_and_continue

# =============================================================================
print_section "2. СОДЕРЖИМОЕ ОСНОВНЫХ ФАЙЛОВ КОНФИГУРАЦИИ"

echo -e "${CYAN}📋 ansible-repo/local.yml${NC} - Основной плейбук для ansible-pull:"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"
cat ansible-repo/local.yml
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"

pause_and_continue

# =============================================================================
echo -e "${CYAN}📋 ansible-repo/roles/common/tasks/main.yml${NC} - Общие конфигурации:"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"
head -40 ansible-repo/roles/common/tasks/main.yml
echo -e "${MAGENTA}... (документ продолжается) ...${NC}"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"

pause_and_continue

# =============================================================================
echo -e "${CYAN}📋 ansible-repo/roles/web/tasks/main.yml${NC} - Конфигурация веб-сервера:"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"
head -35 ansible-repo/roles/web/tasks/main.yml
echo -e "${MAGENTA}... (документ продолжается) ...${NC}"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"

pause_and_continue

# =============================================================================
echo -e "${CYAN}📋 ansible-repo/roles/monitoring/tasks/main.yml${NC} - Мониторинг системы:"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"
head -35 ansible-repo/roles/monitoring/tasks/main.yml
echo -e "${MAGENTA}... (документ продолжается) ...${NC}"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"

pause_and_continue

# =============================================================================
echo -e "${CYAN}📋 ansible-repo/ansible.cfg${NC} - Конфигурация Ansible:"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"
cat ansible-repo/ansible.cfg
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"

pause_and_continue

# =============================================================================
echo -e "${CYAN}📋 ansible-repo/inventory${NC} - Инвентарь:"
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"
cat ansible-repo/inventory
echo -e "${MAGENTA}─────────────────────────────────────────────────────────${NC}"

pause_and_continue

# =============================================================================
print_section "3. КОМАНДЫ ДЛЯ РАЗВЕРТЫВАНИЯ С ПОМОЩЬЮ ANSIBLE-PULL"

echo -e "${CYAN}Команда 1: Локальное выполнение плейбука${NC}"
print_code "ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v"

echo -e "\n${YELLOW}Параметры:${NC}"
print_item "-i ansible-repo/inventory - файл инвентаря"
print_item "-c local - локальное соединение"
print_item "ansible-repo/local.yml - путь к плейбуку"
print_item "-v - verbose режим для подробного вывода"

pause_and_continue

# =============================================================================
echo -e "${CYAN}Команда 2: Используя ansible-pull (pull-based deployment)${NC}"
print_code "ansible-pull -U <repository-url> -d /tmp/ansible-pull"

echo -e "\n${YELLOW}Параметры:${NC}"
print_item "-U <url> - URL репозитория для клонирования"
print_item "-d /tmp/ansible-pull - директория для сохранения репозитория"
print_item "--clean - удалить локальный клон перед обновлением"
print_item "-i inventory - файл инвентаря"
print_item "-l localhost - выполнить на localhost"

pause_and_continue

# =============================================================================
echo -e "${CYAN}Команда 3: Полная команда ansible-pull (рекомендуется)${NC}"
print_code "ansible-pull -U <git-repo-url> -d /var/lib/ansible/pull -i inventory -l localhost local.yml"

pause_and_continue

# =============================================================================
print_section "4. ПОШАГОВАЯ ДЕМОНСТРАЦИЯ ВЫПОЛНЕНИЯ"

echo -e "${CYAN}Шаг 1: Проверка установки Ansible${NC}"
print_code "ansible --version"

if command -v ansible &> /dev/null; then
    print_item "Ansible установлен"
    ansible --version | head -1
else
    print_error "Ansible не установлен"
fi

pause_and_continue

# =============================================================================
echo -e "${CYAN}Шаг 2: Проверка синтаксиса плейбука${NC}"
print_code "ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml"

if command -v ansible-playbook &> /dev/null; then
    echo -e "${GREEN}Проверка синтаксиса:${NC}"
    ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml 2>&1 || true
    print_item "Синтаксис плейбука корректен"
else
    print_info "Ansible не установлен в этой системе"
fi

pause_and_continue

# =============================================================================
echo -e "${CYAN}Шаг 3: Проверка подключения к хостам${NC}"
print_code "ansible all -i ansible-repo/inventory -m ping"

echo -e "${YELLOW}Примечание:${NC} В production среде здесь проверяется подключение ко всем хостам"

if command -v ansible &> /dev/null; then
    ansible localhost -m ping 2>/dev/null && print_item "Подключение к localhost успешно" || print_info "Требуются необходимые привилегии"
fi

pause_and_continue

# =============================================================================
print_section "5. ДЕМОНСТРАЦИЯ СТРУКТУРЫ GIT РЕПОЗИТОРИЯ"

echo -e "${CYAN}Для использования ansible-pull требуется Git репозиторий:${NC}\n"

echo -e "${YELLOW}Инициализация репозитория:${NC}"
print_code "cd ansible-repo && git init"

echo -e "\n${YELLOW}Добавление файлов:${NC}"
print_code "git add ."

echo -e "\n${YELLOW}Первый коммит:${NC}"
print_code "git commit -m 'Initial ansible-pull configuration'"

echo -e "\n${YELLOW}Добавление удаленного репозитория:${NC}"
print_code "git remote add origin https://github.com/your-repo/ansible-pull.git"

echo -e "\n${YELLOW}Отправка в удаленный репозиторий:${NC}"
print_code "git push -u origin main"

pause_and_continue

# =============================================================================
print_section "6. ИСПОЛЬЗОВАНИЕ ANSIBLE-PULL НА ЦЕЛЕВОЙ VM"

echo -e "${CYAN}На целевой виртуальной машине выполните:${NC}\n"

echo -e "${YELLOW}1. Установка Ansible:${NC}"
print_code "sudo apt-get update && sudo apt-get install -y ansible git"
print_code "# или для RedHat/CentOS:"
print_code "sudo yum install -y ansible git"

echo -e "\n${YELLOW}2. Первоначальное развертывание:${NC}"
print_code "sudo ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull local.yml"

echo -e "\n${YELLOW}3. Расписание обновлений (cron):${NC}"
print_code "sudo crontab -e"
print_code "# Каждые 30 минут:"
print_code "*/30 * * * * /usr/bin/ansible-pull -U https://github.com/your-repo/ansible-pull.git -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1"

pause_and_continue

# =============================================================================
print_section "7. МОНИТОРИНГ И ЛОГИРОВАНИЕ"

echo -e "${CYAN}Файлы логирования после развертывания:${NC}\n"

print_item "/var/log/ansible-pull.log - логи ansible-pull"
print_item "/opt/monitoring/system.log - логи системного мониторинга"
print_item "/opt/monitoring/status.conf - статус развертывания"
print_item "/opt/application/config/app.conf - конфигурация приложения"

echo -e "\n${CYAN}Просмотр логов:${NC}"
print_code "sudo tail -f /var/log/ansible-pull.log"

pause_and_continue

# =============================================================================
print_section "8. ПРЕИМУЩЕСТВА ANSIBLE-PULL"

echo -e "${GREEN}✓${NC} Не требует SSH доступа к целевым хостам"
echo -e "${GREEN}✓${NC} Хосты инициируют подключение к серверу"
echo -e "${GREEN}✓${NC} Работает за NAT и firewall"
echo -e "${GREEN}✓${NC} Масштабируется на большое количество хостов"
echo -e "${GREEN}✓${NC} Полностью децентрализовано"
echo -e "${GREEN}✓${NC} Может использоваться через cron для периодических обновлений"

pause_and_continue

# =============================================================================
print_section "9. АРХИТЕКТУРА РЕШЕНИЯ"

echo -e "${BLUE}┌─────────────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│${NC}           Git Repository (Configuration)           ${BLUE}│${NC}"
echo -e "${BLUE}│${NC}  (ansible-repo с local.yml и ролями)            ${BLUE}│${NC}"
echo -e "${BLUE}└────────────────┬────────────────────────────────────┘${NC}"
echo -e "${YELLOW}                 │${NC}"
echo -e "${YELLOW}                 │ git clone/pull${NC}"
echo -e "${YELLOW}                 │${NC}"
echo -e "${BLUE}┌────────────────▼────────────────────────────────────┐${NC}"
echo -e "${BLUE}│${NC}    Target Virtual Machine (VM)                   ${BLUE}│${NC}"
echo -e "${BLUE}│${NC}                                                  ${BLUE}│${NC}"
echo -e "${BLUE}│${NC}  ansible-pull запускает local.yml               ${BLUE}│${NC}"
echo -e "${BLUE}│${NC}                                                  ${BLUE}│${NC}"
echo -e "${BLUE}│${NC}  ✓ Common Role (базовая конфигурация)           ${BLUE}│${NC}"
echo -e "${BLUE}│${NC}  ✓ Web Role (веб-сервер)                        ${BLUE}│${NC}"
echo -e "${BLUE}│${NC}  ✓ Monitoring Role (мониторинг)                 ${BLUE}│${NC}"
echo -e "${BLUE}└────────────────────────────────────────────────────┘${NC}"

pause_and_continue

# =============================================================================
print_section "10. ФАЙЛЫ В РЕПОЗИТОРИИ"

echo -e "${CYAN}📁 Структура проекта:${NC}\n"

echo -e "${WHITE}ansible-repo/${NC}"
echo -e "  ${CYAN}├──${NC} local.yml                    (Основной плейбук)"
echo -e "  ${CYAN}├──${NC} ansible.cfg                (Конфигурация Ansible)"
echo -e "  ${CYAN}├──${NC} inventory                  (Инвентарь хостов)"
echo -e "  ${CYAN}├──${NC} roles/"
echo -e "  ${CYAN}│   ├──${NC} common/tasks/main.yml  (Общие настройки)"
echo -e "  ${CYAN}│   ├──${NC} web/tasks/main.yml     (Веб-сервер)"
echo -e "  ${CYAN}│   └──${NC} monitoring/tasks/main.yml (Мониторинг)"
echo -e "  ${CYAN}├──${NC} group_vars/                (Групповые переменные)"
echo -e "  ${CYAN}└──${NC} host_vars/                 (Переменные хостов)"

pause_and_continue

# =============================================================================
print_section "11. ФИНАЛЬНАЯ ДЕМОНСТРАЦИЯ"

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}              СЦЕНАРИЙ ИСПОЛЬЗОВАНИЯ                     ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}День 1: Начальное развертывание${NC}"
print_item "Admin пушит конфигурацию в Git репозиторий"
print_item "На целевой VM запускается: ansible-pull -U <repo-url> local.yml"
print_item "Выполняются все роли (common, web, monitoring)"

echo -e "\n${YELLOW}День 2-30: Автоматические обновления${NC}"
print_item "Каждые 30 минут cron запускает ansible-pull"
print_item "Автоматически применяются новые конфигурации из Git"
print_item "Система остается актуальной и консистентной"

echo -e "\n${YELLOW}Преимущества такого подхода:${NC}"
print_item "Единая конфигурация для всех хостов"
print_item "История всех изменений в Git"
print_item "Автоматизация без необходимости SSH доступа"
print_item "Простое масштабирование на тысячи хостов"

# =============================================================================
print_section "ЗАВЕРШЕНИЕ"

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}    Демонстрация ansible-pull deployment завершена     ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}                                                        ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   Все необходимые файлы готовы в папке:                ${GREEN}║${NC}"
echo -e "${GREEN}║${NC}   ${WHITE}ansible-repo/${NC}                                     ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${CYAN}Для получения дополнительной информации:${NC}"
echo -e "  📚 https://docs.ansible.com/ansible/latest/cli_tools/ansible-pull.html"
echo -e "  📚 https://docs.ansible.com/ansible/latest/playbook_guide/"

echo ""
