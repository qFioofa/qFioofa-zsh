#!/bin/bash

set -e

ZSH_CONFIG_DIR="$HOME/.config/zsh"
ZDOTDIR_ENV="$HOME/.zshenv"
CURRENT_DIR="$(pwd)"
SRC_DIR="$CURRENT_DIR/src"

show_help() {
    echo "Развертывание конфигурации Zsh из $SRC_DIR"
    echo "Использование: $0 [опции]"
    echo "  -r, --remove    Удалить старую конфигурацию перед установкой"
    echo "  -b, --backup    Создать резервную копию старой конфигурации"
    echo "  -x, --xdg       Принудительно использовать XDG-структуру (по умолчанию)"
    echo "  -l, --legacy    Использовать legacy-структуру (~/.zshrc)"
    echo "  -h, --help      Показать это сообщение"
}

REMOVE=false
BACKUP=false
USE_XDG=true

while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--remove) REMOVE=true; shift ;;
        -b|--backup) BACKUP=true; shift ;;
        -x|--xdg) USE_XDG=true; shift ;;
        -l|--legacy) USE_XDG=false; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Неизвестный параметр: $1"; show_help; exit 1 ;;
    esac
done

if [ ! -d "$SRC_DIR" ]; then
    echo "Ошибка: Директория src/ не найдена в $CURRENT_DIR"
    echo "Создайте директорию src/ и поместите туда конфигурационные файлы"
    exit 1
fi

if [ "$USE_XDG" = true ]; then
    TARGET_DIR="$ZSH_CONFIG_DIR"
    ENV_FILE="$ZDOTDIR_ENV"
    
    if [ -f "$ENV_FILE" ] || [ -d "$TARGET_DIR" ]; then
        if [ "$REMOVE" = true ]; then
            [ -f "$ENV_FILE" ] && rm -f "$ENV_FILE"
            [ -d "$TARGET_DIR" ] && rm -rf "$TARGET_DIR"
            echo "Старая конфигурация удалена"
        elif [ "$BACKUP" = true ]; then
            BACKUP_DIR="$HOME/.zsh_backup_$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$BACKUP_DIR"
            [ -f "$ENV_FILE" ] && mv "$ENV_FILE" "$BACKUP_DIR/"
            [ -d "$TARGET_DIR" ] && mv "$TARGET_DIR" "$BACKUP_DIR/"
            echo "Резервная копия создана: $BACKUP_DIR"
        else
            echo "Обнаружена существующая конфигурация"
            echo "Используйте -r для удаления или -b для резервного копирования"
            exit 1
        fi
    fi

    mkdir -p "$TARGET_DIR"
    cp -r "$SRC_DIR/." "$TARGET_DIR/"
    
    echo "export ZDOTDIR=\"$TARGET_DIR\"" > "$ENV_FILE"
    echo -e "\nКонфигурация развёрнута в XDG-стиле:"
    echo "   • Основные файлы: $TARGET_DIR"
    echo "   • Управляющий файл: $ENV_FILE"
    echo -e "\nЧтобы применить изменения, выполните:"
    echo "   exec zsh  # или откройте новый терминал"

else
    TARGET_DIR="$HOME"
    LEGACY_FILES=(".zshrc" ".zshenv" ".zprofile" ".zlogin" ".zlogout")
    
    NEEDS_ACTION=false
    for file in "${LEGACY_FILES[@]}"; do
        if [ -f "$TARGET_DIR/$file" ]; then
            NEEDS_ACTION=true
            break
        fi
    done

    if [ "$NEEDS_ACTION" = true ]; then
        if [ "$REMOVE" = true ]; then
            for file in "${LEGACY_FILES[@]}"; do
                [ -f "$TARGET_DIR/$file" ] && rm -f "$TARGET_DIR/$file"
            done
            echo "Старые файлы конфигурации удалены"
        elif [ "$BACKUP" = true ]; then
            BACKUP_DIR="$HOME/.zsh_legacy_backup_$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$BACKUP_DIR"
            for file in "${LEGACY_FILES[@]}"; do
                [ -f "$TARGET_DIR/$file" ] && mv "$TARGET_DIR/$file" "$BACKUP_DIR/"
            done
            echo "Резервная копия создана: $BACKUP_DIR"
        else
            echo "Обнаружены существующие файлы конфигурации в $HOME"
            echo "Используйте -r для удаления или -b для резервного копирования"
            exit 1
        fi
    fi

    for file in "${SRC_DIR}"/*; do
        [ -f "$file" ] && cp "$file" "$TARGET_DIR/"
    done
    echo -e "\nКонфигурация развёрнута в legacy-стиле:"
    echo "   • Файлы скопированы в $HOME"
    echo -e "\nЧтобы применить изменения, выполните:"
    echo "   exec zsh  # или откройте новый терминал"
fi

echo -e "\nПроверка установки:"
echo "• Текущий shell: $(basename "$SHELL")"
echo "• Режим развертывания: $(if [ "$USE_XDG" = true ]; then echo "XDG"; else echo "Legacy"; fi)"
echo "• Расположение конфига: $(if [ "$USE_XDG" = true ]; then echo "$ZSH_CONFIG_DIR"; else echo "$HOME"; fi)"
