#!/bin/bash

# 🎯 ГЛАВНЫЙ СКРИПТ ДЛЯ ДЕМОНСТРАЦИИ И СКРИНШОТОВ

# Цвета ANSI для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m'

clear

# 🎬 ГЛАВНЫЙ ЭКРАН
echo -e "${CYAN}"
cat << "EOF"

    ╔════════════════════════════════════════════════════════════════╗
    ║                                                                ║
    ║           🚀  ANSIBLE-PULL DEPLOYMENT SHOWCASE 🚀             ║
    ║                                                                ║
    ║     Развертывание конфигурации из GitHub репозитория          ║
    ║     Pull-based Configuration Management                       ║
    ║                                                                ║
    ╚════════════════════════════════════════════════════════════════╝

EOF
echo -e "${NC}"

echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}📚 КРАТКОЕ ОПИСАНИЕ:${NC}"
echo ""
echo "  Ansible-pull это инструмент для управления конфигурацией машин"
echo "  на основе Pull-модели. Целевые машины сами подтягивают конфигурацию"
echo "  из GitHub репозитория и применяют её локально."
echo ""

echo -e "${YELLOW}✨ ОСНОВНЫЕ КОМПОНЕНТЫ:${NC}"
echo ""
echo -e "  ${CYAN}📁 ansible-repo/${NC}"
echo "     ├── local.yml                  ← Основной плейбук"
echo "     ├── ansible.cfg                ← Конфигурация"
echo "     ├── inventory                  ← Файл инвентаря"
echo "     └── roles/"
echo "         ├── common/tasks/main.yml  ← Базовая конфигурация"
echo "         ├── web/tasks/main.yml     ← Веб-сервер"
echo "         └── monitoring/tasks/main.yml ← Мониторинг"
echo ""

echo -e "${YELLOW}📋 ПОЛЕЗНЫЕ ФАЙЛЫ:${NC}"
echo ""
echo -e "  ${GREEN}✓${NC} ${MAGENTA}REPORT.md${NC}         - Полный отчет с содержимым файлов"
echo -e "  ${GREEN}✓${NC} ${MAGENTA}QUICK-START.md${NC}    - Быстрый старт и примеры"
echo -e "  ${GREEN}✓${NC} ${MAGENTA}COMMANDS.md${NC}       - Все команды для копирования"
echo -e "  ${GREEN}✓${NC} ${MAGENTA}README.md{{NC}        - Подробная документация"
echo ""

echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}🎬 ДЕМОНСТРАЦИОННЫЕ СКРИПТЫ:${NC}"
echo ""
echo -e "  ${YELLOW}Вариант 1: Интерактивная демонстрация (выбирайте слайды)${NC}"
echo -e "  ${MAGENTA}$ bash demo-pretty.sh${NC}"
echo ""
echo -e "  ${YELLOW}Вариант 2: Автоматическая демонстрация (все слайды подряд)${NC}"
echo -e "  ${MAGENTA}$ bash demo-pretty.sh auto${NC}"
echo ""
echo -e "  ${YELLOW}Вариант 3: Краткая демонстрация{{NC}"
echo -e "  ${MAGENTA}$ bash demo-simple.sh{{NC}"
echo ""
echo -e "  ${YELLOW}Вариант 4: Полная интерактивная демонстрация{{NC}"
echo -e "  ${MAGENTA}$ bash demo.sh{{NC}"
echo ""

echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}⚡ БЫСТРЫЙ СТАРТ:{{NC}"
echo ""
echo "  1️⃣  Посмотрите структуру проекта:"
echo -e "     ${MAGENTA}tree ansible-repo/{{NC} или ${MAGENTA}ls -la ansible-repo/{{NC}"
echo ""
echo "  2️⃣  Запустите демонстрацию для скриншотов:"
echo -e "     ${MAGENTA}bash demo-pretty.sh{{NC}"
echo ""
echo "  3️⃣  Прочитайте отчет:"
echo -e "     ${MAGENTA}cat REPORT.md{{NC}"
echo ""
echo "  4️⃣  Скопируйте команды из COMMANDS.md:"
echo -e "     ${MAGENTA}cat COMMANDS.md{{NC}"
echo ""

echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}🎯 КЛЮЧЕВЫЕ КОМАНДЫ:{{NC}"
echo ""
echo -e "  ${CYAN}Проверка синтаксиса:{{NC}"
echo -e "  ${MAGENTA}$ ansible-playbook --syntax-check -i ansible-repo/inventory ansible-repo/local.yml{{NC}"
echo ""
echo -e "  ${CYAN}Локальное тестирование:{{NC}"
echo -e "  ${MAGENTA}$ ansible-playbook -i ansible-repo/inventory -c local ansible-repo/local.yml -v{{NC}"
echo ""
echo -e "  ${CYAN}Развертывание на ВМ (ansible-pull):{{NC}"
echo -e "  ${MAGENTA}$ sudo ansible-pull -U https://github.com/repo/ansible-repo.git \\{{NC}"
echo -e "  ${MAGENTA}    -d /var/lib/ansible/pull local.yml -v{{NC}"
echo ""
echo -e "  ${CYAN}Добавление в cron (автоматизация):{{NC}"
echo -e "  ${MAGENTA}$ sudo crontab -e{{NC}"
echo -e "  ${MAGENTA}*/30 * * * * ansible-pull -U ... >> /var/log/ansible-pull.log 2>&1{{NC}"
echo ""

echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}📊 ЧТО ДЕЛАЕТ КАЖДАЯ РОЛЬ:{{NC}"
echo ""
echo -e "  ${CYAN}🔧 common{{NC}} - Установка пакетов, создание директорий"
echo -e "  ${CYAN}🌐 web{{NC}}    - Установка Nginx, развертывание страницы"
echo -e "  ${CYAN}📈 monitoring{{NC}} - Инструменты мониторинга, логирование"
echo ""

echo -e "${GREEN}════════════════════════════════════════════════════════════════{{NC}"
echo ""

echo -e "${WHITE}🎬 ГОТОВО К СОЗДАНИЮ СКРИНШОТОВ!{{NC}"
echo ""
echo -e "Используйте команды выше для демонстрации в терминале."
echo "Каждый скрипт содержит красивый и информативный вывод."
echo ""

echo -e "${CYAN}💡 СОВЕТ: Запустите ${MAGENTA}bash demo-pretty.sh{{NC}${CYAN} прямо сейчас!{{NC}"
echo ""

echo -e "${GREEN}════════════════════════════════════════════════════════════════{{NC}"
