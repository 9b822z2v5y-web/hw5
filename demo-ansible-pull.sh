#!/bin/bash

# 🎬 ДЕМОНСТРАЦИЯ ANSIBLE-PULL С РЕАЛЬНЫМ GITHUB РЕПОЗИТОРИЕМ
# Красивая демонстрация для скриншотов

# Цвета для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Функция для красивого разделителя
print_separator() {
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
}

# Функция для заголовка
print_title() {
    echo -e "\n${CYAN}🚀 $1${NC}"
    print_separator
}

# Функция для подзаголовка
print_subtitle() {
    echo -e "${YELLOW}▸ $1${NC}"
}

# Функция для успеха
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Функция для информации
print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Функция для команды
print_command() {
    echo -e "${MAGENTA}$ $1${NC}"
}

# Функция для вывода файла
print_file_content() {
    local title=$1
    local file=$2
    
    echo -e "${CYAN}${title}:${NC}"
    echo -e "${GRAY}────────────────────────────────────────${NC}"
    cat "$file" 2>/dev/null | sed 's/^/  /'
    echo -e "${GRAY}────────────────────────────────────────${NC}"
}

# Функция для имитации выполнения команды
run_command() {
    local cmd=$1
    local desc=$2
    
    echo ""
    print_subtitle "$desc"
    print_command "$cmd"
    echo ""
    eval "$cmd"
    echo ""
}

# ГЛАВНОЕ МЕНЮ
show_menu() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║     🎯  ДЕМОНСТРАЦИЯ ANSIBLE-PULL                           ║
    ║     Развертывание конфигурации из GitHub репозитория        ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
EOF
    echo -e "${NC}"
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 1: ИНФОРМАЦИЯ О ПРОЕКТЕ
# ════════════════════════════════════════════════════════════════

show_project_info() {
    clear
    show_menu
    
    print_title "ЭТАП 1️⃣ : ИНФОРМАЦИЯ О ПРОЕКТЕ"
    
    print_subtitle "Что такое ansible-pull?"
    cat << "EOF"
    ansible-pull позволяет целевой машине самостоятельно
    извлекать конфигурацию из внешнего репозитория и 
    применять её без необходимости push-операций.
EOF
    
    echo ""
    print_subtitle "Преимущества:"
    echo "  ✓ Децентрализованная архитектура"
    echo "  ✓ Масштабируемость (тысячи машин)"
    echo "  ✓ Работает без доступа к целевой машине"
    echo "  ✓ Может запускаться по cron"
    
    echo ""
    print_subtitle "Как это работает:"
    echo "  1. На целевой машине устанавливается Ansible"
    echo "  2. Запускается ansible-pull с URL репозитория"
    echo "  3. Конфигурация клонируется в /var/lib/ansible/pull"
    echo "  4. Плейбук выполняется локально"
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 2: СТРУКТУРА ПРОЕКТА
# ════════════════════════════════════════════════════════════════

show_structure() {
    clear
    show_menu
    
    print_title "ЭТАП 2️⃣ : СТРУКТУРА ПРОЕКТА"
    
    print_subtitle "Текущая структура файлов:"
    echo ""
    tree -L 3 2>/dev/null || find . -type f -name "*.yml" -o -name "*.yaml" | head -20
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 3: СОДЕРЖИМОЕ КОНФИГУРАЦИОННЫХ ФАЙЛОВ
# ════════════════════════════════════════════════════════════════

show_config_files() {
    clear
    show_menu
    
    print_title "ЭТАП 3️⃣ : КОНФИГУРАЦИОННЫЕ ФАЙЛЫ"
    
    # Inventory файл
    echo ""
    print_subtitle "1. Файл inventory (ansible-repo/inventory):"
    if [ -f "ansible-repo/inventory" ]; then
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        cat ansible-repo/inventory | sed 's/^/  /'
        echo -e "${GRAY}────────────────────────────────────────${NC}"
    fi
    
    # Main playbook
    echo ""
    print_subtitle "2. Основной плейбук (ansible-repo/local.yml):"
    if [ -f "ansible-repo/local.yml" ]; then
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        cat ansible-repo/local.yml | sed 's/^/  /'
        echo -e "${GRAY}────────────────────────────────────────${NC}"
    fi
    
    # Common tasks
    echo ""
    print_subtitle "3. Роль 'common' (tasks/main.yml):"
    if [ -f "ansible-repo/roles/common/tasks/main.yml" ]; then
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        cat ansible-repo/roles/common/tasks/main.yml | sed 's/^/  /'
        echo -e "${GRAY}────────────────────────────────────────${NC}"
    fi
    
    # Web tasks
    echo ""
    print_subtitle "4. Роль 'web' (tasks/main.yml):"
    if [ -f "ansible-repo/roles/web/tasks/main.yml" ]; then
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        cat ansible-repo/roles/web/tasks/main.yml | sed 's/^/  /'
        echo -e "${GRAY}────────────────────────────────────────${NC}"
    fi
    
    # Monitoring tasks
    echo ""
    print_subtitle "5. Роль 'monitoring' (tasks/main.yml):"
    if [ -f "ansible-repo/roles/monitoring/tasks/main.yml" ]; then
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        cat ansible-repo/roles/monitoring/tasks/main.yml | sed 's/^/  /'
        echo -e "${GRAY}────────────────────────────────────────${NC}"
    fi
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 4: ПРОВЕРКА СИНТАКСИСА
# ════════════════════════════════════════════════════════════════

show_syntax_check() {
    clear
    show_menu
    
    print_title "ЭТАП 4️⃣ : ПРОВЕРКА СИНТАКСИСА ПЛЕЙБУКА"
    
    print_subtitle "Проверяем синтаксис плейбука перед запуском:"
    echo ""
    
    local cmd="ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml"
    print_command "$cmd"
    echo ""
    
    if command -v ansible-playbook &> /dev/null; then
        eval "$cmd" 2>&1 | sed 's/^/  /'
        echo ""
        print_success "Синтаксис проверен успешно!"
    else
        print_info "Ansible не установлен, пропускаем проверку"
        echo "  Для установки выполните: pip install ansible"
    fi
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 5: ЛОКАЛЬНОЕ ТЕСТИРОВАНИЕ
# ════════════════════════════════════════════════════════════════

show_local_test() {
    clear
    show_menu
    
    print_title "ЭТАП 5️⃣ : ЛОКАЛЬНОЕ ТЕСТИРОВАНИЕ"
    
    print_subtitle "Команда для локального тестирования:"
    echo ""
    
    local cmd="ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v --check"
    print_command "$cmd"
    echo ""
    
    echo -e "${BLUE}Это выполнит плейбук локально в режиме 'check' (без изменений)${NC}"
    echo ""
    
    if command -v ansible-playbook &> /dev/null; then
        print_subtitle "Запускаем (это может занять время)..."
        echo ""
        eval "$cmd" 2>&1 | sed 's/^/  /' | head -50
        echo "  ..."
        print_success "Тестирование завершено"
    else
        print_info "Ansible не установлен"
    fi
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 6: ИСПОЛЬЗОВАНИЕ ANSIBLE-PULL
# ════════════════════════════════════════════════════════════════

show_ansible_pull() {
    clear
    show_menu
    
    print_title "ЭТАП 6️⃣ : ИСПОЛЬЗОВАНИЕ ANSIBLE-PULL"
    
    print_subtitle "Команда для развертывания с ansible-pull:"
    echo ""
    
    # Используем вымышленный репозиторий для примера
    local repo_url="https://github.com/your-username/ansible-repo.git"
    
    local cmd="sudo ansible-pull -U $repo_url -d /var/lib/ansible/pull local.yml -v"
    
    echo -e "${MAGENTA}$ $cmd${NC}"
    echo ""
    
    echo -e "${BLUE}Параметры команды:${NC}"
    echo "  -U, --url         URL репозитория (обязательный)"
    echo "  -d, --directory   Директория для клонирования (по умолчанию: ~/.ansible/pull)"
    echo "  local.yml         Плейбук для выполнения"
    echo "  -v, --verbose     Подробный вывод"
    echo "  -C, --checkout    Ветка/тег для checkout"
    echo "  -i, --inventory   Файл inventory"
    
    echo ""
    print_subtitle "Что происходит при выполнении:"
    echo ""
    echo "  1️⃣  Ansible клонирует репозиторий"
    echo "  2️⃣  Обновляет код до последней версии (git pull)"
    echo "  3️⃣  Запускает плейбук локально"
    echo "  4️⃣  Логирует результаты выполнения"
    echo ""
    
    print_subtitle "Пример для использования на целевой машине (ВМ):"
    echo ""
    echo -e "${YELLOW}На целевой машине выполните:${NC}"
    local deploy_cmd="sudo ansible-pull -U https://github.com/user/ansible-repo.git \\"
    echo -e "${MAGENTA}$ $deploy_cmd${NC}"
    echo -e "${MAGENTA}    -d /var/lib/ansible/pull \\"
    echo -e "    local.yml -v${NC}"
    echo ""
    
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 7: АВТОМАТИЗАЦИЯ С CRON
# ════════════════════════════════════════════════════════════════

show_cron_setup() {
    clear
    show_menu
    
    print_title "ЭТАП 7️⃣ : АВТОМАТИЗАЦИЯ С CRON"
    
    print_subtitle "Добавляем периодическое выполнение в crontab:"
    echo ""
    
    echo -e "${MAGENTA}$ sudo crontab -e${NC}"
    echo ""
    
    echo -e "${BLUE}Добавьте строку для выполнения каждые 15 минут:${NC}"
    echo ""
    echo -e "${YELLOW}*/15 * * * * ansible-pull -U https://github.com/user/ansible-repo.git \\${NC}"
    echo -e "${YELLOW}  -d /var/lib/ansible/pull local.yml >> /var/log/ansible-pull.log 2>&1${NC}"
    echo ""
    
    print_subtitle "Расшифровка cron расписания:"
    echo "  */15  - каждые 15 минут"
    echo "  *     - каждый час"
    echo "  *     - каждый день месяца"
    echo "  *     - каждый месяц"
    echo "  *     - каждый день недели"
    echo ""
    
    print_subtitle "Проверка логов:"
    echo -e "${MAGENTA}$ sudo tail -f /var/log/ansible-pull.log${NC}"
    echo ""
    
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 8: ПОЛНЫЙ ПРИМЕР
# ════════════════════════════════════════════════════════════════

show_full_example() {
    clear
    show_menu
    
    print_title "ЭТАП 8️⃣ : ПОЛНЫЙ ПРИМЕР ИСПОЛЬЗОВАНИЯ"
    
    print_subtitle "Пошаговое развертывание на целевой машине:"
    echo ""
    
    echo -e "${CYAN}ШАГ 1: Установка Ansible${NC}"
    echo -e "${MAGENTA}$ sudo apt-get update${NC}"
    echo -e "${MAGENTA}$ sudo apt-get install -y ansible git${NC}"
    echo ""
    
    echo -e "${CYAN}ШАГ 2: Создание директории для репозитория${NC}"
    echo -e "${MAGENTA}$ sudo mkdir -p /var/lib/ansible/pull${NC}"
    echo -e "${MAGENTA}$ sudo chown ansible:ansible /var/lib/ansible/pull${NC}"
    echo ""
    
    echo -e "${CYAN}ШАГ 3: Первый запуск ansible-pull${NC}"
    echo -e "${MAGENTA}$ sudo ansible-pull \\${NC}"
    echo -e "${MAGENTA}    -U https://github.com/user/ansible-repo.git \\${NC}"
    echo -e "${MAGENTA}    -d /var/lib/ansible/pull \\${NC}"
    echo -e "${MAGENTA}    local.yml -v${NC}"
    echo ""
    
    echo -e "${CYAN}ШАГ 4: Добавление в cron (опционально)${NC}"
    echo -e "${MAGENTA}$ sudo crontab -e${NC}"
    echo -e "${MAGENTA}# Добавьте: */15 * * * * ansible-pull -U ... >> /var/log/ansible-pull.log 2>&1${NC}"
    echo ""
    
    print_success "Готово! Теперь конфигурация развертывается автоматически"
    echo ""
    
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ИТОГОВАЯ СВОДКА
# ════════════════════════════════════════════════════════════════

show_summary() {
    clear
    show_menu
    
    print_title "ИТОГОВАЯ СВОДКА"
    
    echo ""
    echo -e "${CYAN}📋 ЧТО МЫ РАССМОТРЕЛИ:${NC}"
    echo ""
    echo "  1️⃣  Концепция ansible-pull"
    echo "  2️⃣  Структуру проекта"
    echo "  3️⃣  Содержимое конфигурационных файлов"
    echo "  4️⃣  Проверку синтаксиса"
    echo "  5️⃣  Локальное тестирование"
    echo "  6️⃣  Использование ansible-pull"
    echo "  7️⃣  Автоматизацию с cron"
    echo "  8️⃣  Полный пример использования"
    echo ""
    
    echo -e "${CYAN}📁 КЛЮЧЕВЫЕ ФАЙЛЫ:${NC}"
    echo ""
    echo "  • REPORT.md           - Полный отчет для сдачи"
    echo "  • COMMANDS.md         - Все команды для копирования"
    echo "  • README.md           - Подробная документация"
    echo "  • ansible-repo/       - Структура репозитория"
    echo ""
    
    echo -e "${GREEN}✨ ДЕМОНСТРАЦИЯ ЗАВЕРШЕНА!${NC}"
    echo ""
    echo "Для создания скриншотов используйте эту демонстрацию."
    echo "Каждый этап содержит примеры команд и объяснения."
    echo ""
}

# ════════════════════════════════════════════════════════════════
# ГЛАВНОЕ МЕНЮ ИНТЕРАКТИВНОГО РЕЖИМА
# ════════════════════════════════════════════════════════════════

interactive_menu() {
    while true; do
        clear
        show_menu
        
        echo -e "${CYAN}Выберите действие:${NC}"
        echo ""
        echo "  1️⃣  Информация о проекте"
        echo "  2️⃣  Структура проекта"
        echo "  3️⃣  Конфигурационные файлы"
        echo "  4️⃣  Проверка синтаксиса"
        echo "  5️⃣  Локальное тестирование"
        echo "  6️⃣  Использование ansible-pull"
        echo "  7️⃣  Автоматизация с cron"
        echo "  8️⃣  Полный пример"
        echo "  9️⃣  Итоговая сводка"
        echo ""
        echo "  0️⃣  Выход"
        echo ""
        echo -e "${YELLOW}Введите номер действия:${NC} "
        read -r choice
        
        case $choice in
            1) show_project_info ;;
            2) show_structure ;;
            3) show_config_files ;;
            4) show_syntax_check ;;
            5) show_local_test ;;
            6) show_ansible_pull ;;
            7) show_cron_setup ;;
            8) show_full_example ;;
            9) show_summary ;;
            0) 
                clear
                echo -e "${GREEN}До встречи! 👋${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Неверный выбор. Попробуйте снова.${NC}"
                sleep 1
                ;;
        esac
    done
}

# ════════════════════════════════════════════════════════════════
# ГЛАВНАЯ ПРОГРАММА
# ════════════════════════════════════════════════════════════════

# Определяем режим работы
if [ "$1" == "auto" ]; then
    # Автоматическое прохождение всех этапов
    show_project_info
    show_structure
    show_config_files
    show_syntax_check
    show_local_test
    show_ansible_pull
    show_cron_setup
    show_full_example
    show_summary
else
    # Интерактивное меню
    interactive_menu
fi
