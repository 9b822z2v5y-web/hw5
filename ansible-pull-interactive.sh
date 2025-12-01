#!/bin/bash

# 🎯 ИНТЕРАКТИВНЫЙ ANSIBLE-PULL С GITHUB РЕПОЗИТОРИЕМ
# Скрипт для работы с любым GitHub репозиторием

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

# Переменные
REPO_URL=""
REPO_NAME=""
WORK_DIR="/tmp/ansible-pull-work"
CLONE_DIR=""

# ════════════════════════════════════════════════════════════════
# ФУНКЦИИ ВЫВОДА
# ════════════════════════════════════════════════════════════════

print_header() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ╔════════════════════════════════════════════════════════════════╗
    ║                                                                ║
    ║     🚀  ИНТЕРАКТИВНЫЙ ANSIBLE-PULL С GITHUB                  ║
    ║                                                                ║
    ║     Работа с любым GitHub репозиторием для ansible-pull       ║
    ║                                                                ║
    ╚════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_separator() {
    echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 1: ВВОД РЕПОЗИТОРИЯ
# ════════════════════════════════════════════════════════════════

input_repo() {
    print_header
    
    echo -e "${CYAN}📝 ШАГ 1: ВВОД URL РЕПОЗИТОРИЯ${NC}"
    print_separator
    echo ""
    
    echo -e "${YELLOW}Введите URL GitHub репозитория:${NC}"
    echo -e "${GRAY}Примеры:${NC}"
    echo "  • https://github.com/user/ansible-repo.git"
    echo "  • https://github.com/org/config-management"
    echo "  • git@github.com:user/ansible-repo.git"
    echo ""
    
    read -p "URL репозитория: " REPO_URL
    
    if [ -z "$REPO_URL" ]; then
        print_error "URL не введен"
        return 1
    fi
    
    # Извлекаем имя репозитория
    REPO_NAME=$(echo "$REPO_URL" | grep -oE '[^/]+\.git$|[^/]+$' | sed 's/\.git$//')
    
    print_success "Репозиторий: $REPO_NAME"
    print_success "URL: $REPO_URL"
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
    return 0
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 2: ПРОВЕРКА РЕПОЗИТОРИЯ
# ════════════════════════════════════════════════════════════════

check_repo() {
    print_header
    
    echo -e "${CYAN}🔍 ШАГ 2: ПРОВЕРКА РЕПОЗИТОРИЯ${NC}"
    print_separator
    echo ""
    
    print_info "Проверка доступности репозитория..."
    echo ""
    
    # Создаем рабочую директорию
    mkdir -p "$WORK_DIR"
    CLONE_DIR="$WORK_DIR/$REPO_NAME"
    
    # Удаляем старый клон если существует
    rm -rf "$CLONE_DIR"
    
    print_info "Клонирование репозитория в $CLONE_DIR..."
    echo -e "${MAGENTA}$ git clone $REPO_URL $CLONE_DIR${NC}"
    echo ""
    
    if git clone "$REPO_URL" "$CLONE_DIR" 2>&1 | sed 's/^/  /'; then
        print_success "Репозиторий успешно клонирован"
    else
        print_error "Ошибка при клонировании репозитория"
        echo -e "${YELLOW}Проверьте:${NC}"
        echo "  • Правильность URL"
        echo "  • Доступ к репозиторию"
        echo "  • Наличие интернета"
        echo ""
        read -p "Нажмите Enter для возврата..."
        return 1
    fi
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
    return 0
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 3: ПРОСМОТР СТРУКТУРЫ
# ════════════════════════════════════════════════════════════════

show_structure() {
    print_header
    
    echo -e "${CYAN}📁 ШАГ 3: СТРУКТУРА РЕПОЗИТОРИЯ${NC}"
    print_separator
    echo ""
    
    print_info "Структура репозитория $REPO_NAME:"
    echo ""
    
    if command -v tree &> /dev/null; then
        tree -L 3 "$CLONE_DIR" 2>/dev/null | sed 's/^/  /'
    else
        find "$CLONE_DIR" -type f | head -20 | sed 's/^/  /'
        if [ $(find "$CLONE_DIR" -type f | wc -l) -gt 20 ]; then
            echo "  ... и еще файлы"
        fi
    fi
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 4: ПРОВЕРКА ANSIBLE ФАЙЛОВ
# ════════════════════════════════════════════════════════════════

check_ansible_files() {
    print_header
    
    echo -e "${CYAN}🔧 ШАГ 4: ПРОВЕРКА ANSIBLE ФАЙЛОВ${NC}"
    print_separator
    echo ""
    
    local found_playbook=0
    local found_roles=0
    local found_inventory=0
    
    # Проверка плейбуков
    echo -e "${YELLOW}📄 YAML файлы и плейбуки:${NC}"
    echo ""
    
    if find "$CLONE_DIR" -name "*.yml" -o -name "*.yaml" | grep -q .; then
        print_success "Найдены YAML файлы:"
        find "$CLONE_DIR" \( -name "*.yml" -o -name "*.yaml" \) | sed 's/^/  /'
        found_playbook=1
    else
        print_error "YAML файлы не найдены"
    fi
    
    echo ""
    
    # Проверка ролей
    echo -e "${YELLOW}🎭 Роли Ansible:${NC}"
    echo ""
    
    # Ищем роли в любой подпапке с именем 'roles'
    local roles_found=$(find "$CLONE_DIR" -type d -name "roles" 2>/dev/null)
    
    if [ -n "$roles_found" ]; then
        print_success "Найдены директории roles:"
        echo "$roles_found" | while read roles_dir; do
            if [ -d "$roles_dir" ]; then
                local role_count=$(ls -1 "$roles_dir" 2>/dev/null | wc -l)
                echo "  📁 $roles_dir ($role_count ролей)"
                ls -1 "$roles_dir" 2>/dev/null | sed 's/^/    - /'
            fi
        done
        found_roles=1
    else
        print_error "Директория roles не найдена"
    fi
    
    echo ""
    
    # Проверка инвентаря
    echo -e "${YELLOW}📋 Файлы инвентаря:${NC}"
    echo ""
    
    if [ -f "$CLONE_DIR/inventory" ] || find "$CLONE_DIR" -name "inventory*" | grep -q .; then
        print_success "Найден файл инвентаря:"
        find "$CLONE_DIR" -name "inventory*" -type f | sed 's/^/  /'
        found_inventory=1
    else
        print_error "Файл инвентаря не найден"
    fi
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 5: ПРОСМОТР СОДЕРЖИМОГО ФАЙЛОВ
# ════════════════════════════════════════════════════════════════

view_files() {
    print_header
    
    echo -e "${CYAN}📖 ШАГ 5: ПРОСМОТР СОДЕРЖИМОГО ФАЙЛОВ${NC}"
    print_separator
    echo ""
    
    # Основной плейбук
    local main_playbook=$(find "$CLONE_DIR" -maxdepth 1 \( -name "*.yml" -o -name "*.yaml" \) | head -1)
    
    if [ -f "$main_playbook" ]; then
        echo -e "${YELLOW}📄 Основной плейбук: $(basename $main_playbook)${NC}"
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        head -30 "$main_playbook" | sed 's/^/  /'
        if [ $(wc -l < "$main_playbook") -gt 30 ]; then
            echo "  ... (остальное содержимое)"
        fi
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        echo ""
    fi
    
    # Инвентарь
    if [ -f "$CLONE_DIR/inventory" ]; then
        echo -e "${YELLOW}📋 Файл инвентаря:${NC}"
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        cat "$CLONE_DIR/inventory" | sed 's/^/  /'
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        echo ""
    fi
    
    # Конфигурация Ansible
    if [ -f "$CLONE_DIR/ansible.cfg" ]; then
        echo -e "${YELLOW}🔧 Файл конфигурации:${NC}"
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        head -20 "$CLONE_DIR/ansible.cfg" | sed 's/^/  /'
        echo -e "${GRAY}────────────────────────────────────────${NC}"
        echo ""
    fi
    
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 6: ПРОВЕРКА СИНТАКСИСА
# ════════════════════════════════════════════════════════════════

check_syntax() {
    print_header
    
    echo -e "${CYAN}✓ ШАГ 6: ПРОВЕРКА СИНТАКСИСА ANSIBLE${NC}"
    print_separator
    echo ""
    
    # Проверяем наличие Ansible
    if ! command -v ansible-playbook &> /dev/null; then
        print_error "Ansible не установлен"
        echo -e "${YELLOW}Для установки выполните:${NC}"
        echo "  pip install ansible"
        echo ""
        read -p "Нажмите Enter для продолжения..."
        return 1
    fi
    
    # Находим основной плейбук
    local main_playbook=$(find "$CLONE_DIR" -maxdepth 1 \( -name "*.yml" -o -name "*.yaml" \) | head -1)
    
    if [ -z "$main_playbook" ]; then
        print_error "Плейбук не найден"
        read -p "Нажмите Enter для продолжения..."
        return 1
    fi
    
    local inventory_file="$CLONE_DIR/inventory"
    if [ ! -f "$inventory_file" ]; then
        inventory_file=$(find "$CLONE_DIR" -name "inventory*" -type f | head -1)
    fi
    
    if [ -z "$inventory_file" ]; then
        print_error "Инвентарь не найден"
        read -p "Нажмите Enter для продолжения..."
        return 1
    fi
    
    echo -e "${YELLOW}Проверка синтаксиса плейбука...${NC}"
    echo -e "${MAGENTA}$ ansible-playbook --syntax-check -i $inventory_file $main_playbook${NC}"
    echo ""
    
    if ansible-playbook --syntax-check -i "$inventory_file" "$main_playbook" 2>&1 | sed 's/^/  /'; then
        print_success "Синтаксис проверен успешно!"
    else
        print_error "Ошибки при проверке синтаксиса"
    fi
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 7: ГЕНЕРАЦИЯ КОМАНД ANSIBLE-PULL
# ════════════════════════════════════════════════════════════════

generate_commands() {
    print_header
    
    echo -e "${CYAN}🚀 ШАГ 7: КОМАНДЫ ДЛЯ ANSIBLE-PULL${NC}"
    print_separator
    echo ""
    
    local main_playbook=$(find "$CLONE_DIR" -maxdepth 1 \( -name "*.yml" -o -name "*.yaml" \) | head -1)
    local playbook_name=$(basename "$main_playbook")
    
    echo -e "${YELLOW}Команда для развертывания на целевой машине:${NC}"
    echo ""
    
    echo -e "${MAGENTA}# Вариант 1: Базовая команда${NC}"
    echo -e "${MAGENTA}$ sudo ansible-pull \\${NC}"
    echo -e "${MAGENTA}    -U $REPO_URL \\${NC}"
    echo -e "${MAGENTA}    -d /var/lib/ansible/pull \\${NC}"
    echo -e "${MAGENTA}    $playbook_name -v${NC}"
    echo ""
    
    echo -e "${MAGENTA}# Вариант 2: С указанием инвентаря${NC}"
    echo -e "${MAGENTA}$ sudo ansible-pull \\${NC}"
    echo -e "${MAGENTA}    -U $REPO_URL \\${NC}"
    echo -e "${MAGENTA}    -i inventory \\${NC}"
    echo -e "${MAGENTA}    -d /var/lib/ansible/pull \\${NC}"
    echo -e "${MAGENTA}    $playbook_name -v${NC}"
    echo ""
    
    echo -e "${MAGENTA}# Вариант 3: Для cron (каждые 30 минут)${NC}"
    echo -e "${MAGENTA}*/30 * * * * ansible-pull \\${NC}"
    echo -e "${MAGENTA}  -U $REPO_URL \\${NC}"
    echo -e "${MAGENTA}  -d /var/lib/ansible/pull \\${NC}"
    echo -e "${MAGENTA}  $playbook_name >> /var/log/ansible-pull.log 2>&1${NC}"
    echo ""
    
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 8: ЛОКАЛЬНОЕ ТЕСТИРОВАНИЕ
# ════════════════════════════════════════════════════════════════

local_test() {
    print_header
    
    echo -e "${CYAN}🧪 ШАГ 8: ЛОКАЛЬНОЕ ТЕСТИРОВАНИЕ${NC}"
    print_separator
    echo ""
    
    if ! command -v ansible-playbook &> /dev/null; then
        print_error "Ansible не установлен"
        echo -e "${YELLOW}Для установки выполните:${NC}"
        echo "  pip install ansible"
        echo ""
        read -p "Нажмите Enter для продолжения..."
        return 1
    fi
    
    local main_playbook=$(find "$CLONE_DIR" -maxdepth 1 \( -name "*.yml" -o -name "*.yaml" \) | head -1)
    local inventory_file=$(find "$CLONE_DIR" -name "inventory*" -type f | head -1)
    
    if [ -z "$main_playbook" ]; then
        print_error "Плейбук не найден"
        read -p "Нажмите Enter для продолжения..."
        return 1
    fi
    
    echo -e "${YELLOW}Запуск плейбука в режиме check (без изменений):${NC}"
    echo -e "${MAGENTA}$ ansible-playbook -i $inventory_file -c local $main_playbook --check -v${NC}"
    echo ""
    
    cd "$CLONE_DIR"
    
    if [ -n "$inventory_file" ]; then
        ansible-playbook -i "$inventory_file" -c local "$main_playbook" --check -v 2>&1 | head -50 | sed 's/^/  /'
    else
        ansible-playbook -c local "$main_playbook" --check -v 2>&1 | head -50 | sed 's/^/  /'
    fi
    
    echo ""
    if [ $(ansible-playbook -i "$inventory_file" -c local "$main_playbook" --check -v 2>&1 | wc -l) -gt 50 ]; then
        echo "  ... (остальной вывод)"
    fi
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 9: ИНФОРМАЦИЯ ДЛЯ GIT
# ════════════════════════════════════════════════════════════════

git_info() {
    print_header
    
    echo -e "${CYAN}📊 ШАГ 9: ИНФОРМАЦИЯ О РЕПОЗИТОРИИ${NC}"
    print_separator
    echo ""
    
    cd "$CLONE_DIR"
    
    echo -e "${YELLOW}История коммитов:${NC}"
    echo ""
    git log --oneline -10 | sed 's/^/  /'
    
    echo ""
    
    echo -e "${YELLOW}Текущая ветка:${NC}"
    echo ""
    git branch | sed 's/^/  /'
    
    echo ""
    
    echo -e "${YELLOW}Статус репозитория:${NC}"
    echo ""
    git status | sed 's/^/  /'
    
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# ════════════════════════════════════════════════════════════════
# ЭТАП 10: ИТОГОВАЯ ИНФОРМАЦИЯ
# ════════════════════════════════════════════════════════════════

final_info() {
    print_header
    
    echo -e "${CYAN}✅ ИТОГОВАЯ ИНФОРМАЦИЯ${NC}"
    print_separator
    echo ""
    
    echo -e "${GREEN}Репозиторий успешно обработан!${NC}"
    echo ""
    
    echo -e "${YELLOW}📋 Информация о репозитории:${NC}"
    echo "  Название: $REPO_NAME"
    echo "  URL: $REPO_URL"
    echo "  Локальная копия: $CLONE_DIR"
    echo ""
    
    echo -e "${YELLOW}📁 Найденные файлы:${NC}"
    echo "  • $(find "$CLONE_DIR" -name "*.yml" -o -name "*.yaml" | wc -l) YAML файлов"
    echo "  • $(find "$CLONE_DIR" -type f | wc -l) всего файлов"
    
    local total_roles=$(find "$CLONE_DIR" -type d -name "roles" -exec sh -c 'ls -1 "$1" 2>/dev/null | wc -l' _ {} \; | awk '{s+=$1} END {print s}')
    if [ "$total_roles" -gt 0 ]; then
        echo "  • $total_roles ролей"
    fi
    
    echo ""
    
    echo -e "${YELLOW}🚀 Следующие шаги:${NC}"
    echo "  1. Загрузить репозиторий на GitHub/GitLab"
    echo "  2. Выполнить ansible-pull на целевой машине"
    echo "  3. Добавить в cron для автоматизации"
    echo ""
    
    echo -e "${YELLOW}💾 Репозиторий находится в:${NC}"
    echo "  $CLONE_DIR"
    echo ""
    
    read -p "Нажмите Enter для завершения..."
}

# ════════════════════════════════════════════════════════════════
# ГЛАВНОЕ МЕНЮ
# ════════════════════════════════════════════════════════════════

main_menu() {
    while true; do
        print_header
        
        echo -e "${CYAN}Выберите действие:${NC}"
        echo ""
        
        if [ -z "$REPO_URL" ]; then
            echo -e "${YELLOW}1️⃣  Введить URL репозитория${NC}"
        else
            echo -e "${GREEN}1️⃣  Ввести новый URL репозитория${NC} (текущий: $REPO_NAME)"
        fi
        
        if [ -n "$REPO_URL" ]; then
            echo -e "${YELLOW}2️⃣  Проверить репозиторий${NC}"
            echo -e "${YELLOW}3️⃣  Просмотреть структуру${NC}"
            echo -e "${YELLOW}4️⃣  Проверить ansible файлы${NC}"
            echo -e "${YELLOW}5️⃣  Просмотреть содержимое файлов${NC}"
            echo -e "${YELLOW}6️⃣  Проверить синтаксис{{NC}"
            echo -e "${YELLOW}7️⃣  Генерировать команды ansible-pull{{NC}"
            echo -e "${YELLOW}8️⃣  Локальное тестирование{{NC}"
            echo -e "${YELLOW}9️⃣  Информация о Git{{NC}"
            echo -e "${YELLOW}🔟 Итоговая информация{{NC}"
        fi
        
        echo ""
        echo -e "${YELLOW}0️⃣  Выход{{NC}"
        echo ""
        echo -n "Выберите номер: "
        read choice
        
        case $choice in
            1)
                if input_repo; then
                    continue
                fi
                ;;
            2)
                if [ -n "$REPO_URL" ]; then
                    check_repo
                else
                    print_error "Сначала введите URL репозитория"
                    sleep 2
                fi
                ;;
            3)
                if [ -n "$REPO_URL" ] && [ -d "$CLONE_DIR" ]; then
                    show_structure
                else
                    print_error "Сначала проверьте репозиторий"
                    sleep 2
                fi
                ;;
            4)
                if [ -n "$REPO_URL" ] && [ -d "$CLONE_DIR" ]; then
                    check_ansible_files
                else
                    print_error "Сначала проверьте репозиторий"
                    sleep 2
                fi
                ;;
            5)
                if [ -n "$REPO_URL" ] && [ -d "$CLONE_DIR" ]; then
                    view_files
                else
                    print_error "Сначала проверьте репозиторий"
                    sleep 2
                fi
                ;;
            6)
                if [ -n "$REPO_URL" ] && [ -d "$CLONE_DIR" ]; then
                    check_syntax
                else
                    print_error "Сначала проверьте репозиторий"
                    sleep 2
                fi
                ;;
            7)
                if [ -n "$REPO_URL" ]; then
                    generate_commands
                else
                    print_error "Сначала введите URL репозитория"
                    sleep 2
                fi
                ;;
            8)
                if [ -n "$REPO_URL" ] && [ -d "$CLONE_DIR" ]; then
                    local_test
                else
                    print_error "Сначала проверьте репозиторий"
                    sleep 2
                fi
                ;;
            9)
                if [ -n "$REPO_URL" ] && [ -d "$CLONE_DIR" ]; then
                    git_info
                else
                    print_error "Сначала проверьте репозиторий"
                    sleep 2
                fi
                ;;
            10)
                if [ -n "$REPO_URL" ]; then
                    final_info
                else
                    print_error "Сначала проверьте репозиторий"
                    sleep 2
                fi
                ;;
            0)
                clear
                echo -e "${GREEN}До встречи! 👋${NC}"
                exit 0
                ;;
            *)
                print_error "Неверный выбор"
                sleep 1
                ;;
        esac
    done
}

# ════════════════════════════════════════════════════════════════
# ГЛАВНАЯ ПРОГРАММА
# ════════════════════════════════════════════════════════════════

# Проверяем аргументы командной строки
if [ -n "$1" ]; then
    REPO_URL="$1"
    REPO_NAME=$(echo "$REPO_URL" | grep -oE '[^/]+\.git$|[^/]+$' | sed 's/\.git$//')
    CLONE_DIR="$WORK_DIR/$REPO_NAME"
    
    # Автоматически проверяем репозиторий
    check_repo
    
    # Показываем меню
    main_menu
else
    # Интерактивный режим
    main_menu
fi
