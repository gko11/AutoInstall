setup#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    echo "Этот скрипт должен быть запущен с правами root"
    exit 1
fi

TEMP_DIR=$(mktemp -d)

if [ -d "/opt/autoinstall" ]; then
    echo "Removing existing RemnaSetup installation..."
    echo "Удаление существующей установки AutoInstall..."
    rm -rf /opt/autoinstall
fi

if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    echo "Установка curl..."
    if command -v apt-get &> /dev/null; then
        apt update -y && apt install -y curl
    elif command -v yum &> /dev/null; then
        yum install -y curl
    elif command -v dnf &> /dev/null; then
        dnf install -y curl
    else
        echo "Failed to install curl. Please install it manually."
        echo "Не удалось установить curl. Пожалуйста, установите его вручную."
        exit 1
    fi
fi

cd "$TEMP_DIR" || exit 1

echo "Downloading AutoInstall..."
echo "Загрузка AutoInstall..."
curl -L https://github.com/gko11/AutoInstall/archive/refs/heads/main.zip -o autoinstall.zip

if [ ! -f autoinstall.zip ]; then
    echo "Error: Failed to download archive"
    echo "Ошибка: Не удалось загрузить архив"
    rm -rf "$TEMP_DIR"
    exit 1
fi

if ! command -v unzip &> /dev/null; then
    echo "Installing unzip..."
    echo "Установка unzip..."
    if command -v apt-get &> /dev/null; then
        echo "Updating package list..."
        echo "Обновление списка пакетов..."
        sudo apt update -y && sudo apt install -y unzip
    elif command -v yum &> /dev/null; then
        sudo yum install -y unzip
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y unzip
    else
        echo "Failed to install unzip. Please install it manually."
        echo "Не удалось установить unzip. Пожалуйста, установите его вручную."
        rm -rf "$TEMP_DIR"
        exit 1
    fi
fi

echo "Extracting files..."
echo "Распаковка файлов..."
unzip -q autoinstall.zip

if [ ! -d "AutoInstall-main" ]; then
    echo "Error: Failed to extract archive"
    echo "Ошибка: Не удалось распаковать архив"
    rm -rf "$TEMP_DIR"
    exit 1
fi

mkdir -p /opt/autoinstall

echo "Installing AutoInstall to /opt/autoinstall..."
echo "Установка AutoInstall в /opt/autoinstall..."
cp -r AutoInstall-main/* /opt/autoinstall/

if [ ! -f "/opt/autoinstall/install.sh" ]; then
    echo "Error: Failed to copy files"
    echo "Ошибка: Не удалось скопировать файлы"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Setting permissions..."
echo "Установка прав доступа..."
chown -R $SUDO_USER:$SUDO_USER /opt/autoinstall
chmod -R 755 /opt/autoinstall
chmod +x /opt/autoinstall/setup.sh
chmod +x /opt/autoinstall/scripts/common/*.sh

rm -rf "$TEMP_DIR"

cd /opt/autoinstall || exit 1

echo "Starting AutoInstall..."
echo "Запуск AutoInstall..."
bash /opt/autoinstall/setup.sh 
