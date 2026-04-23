#!/bin/bash

set -e

OS="$(uname -s)"

install_macos() {
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing ImageMagick via Homebrew..."
    brew install imagemagick
}

install_linux() {
    if command -v apt-get &>/dev/null; then
        echo "Detected apt — installing ImageMagick..."
        sudo apt-get update -qq
        sudo apt-get install -y imagemagick
    elif command -v dnf &>/dev/null; then
        echo "Detected dnf — installing ImageMagick..."
        sudo dnf install -y ImageMagick
    elif command -v yum &>/dev/null; then
        echo "Detected yum — installing ImageMagick..."
        sudo yum install -y ImageMagick
    elif command -v pacman &>/dev/null; then
        echo "Detected pacman — installing ImageMagick..."
        sudo pacman -Sy --noconfirm imagemagick
    elif command -v zypper &>/dev/null; then
        echo "Detected zypper — installing ImageMagick..."
        sudo zypper install -y ImageMagick
    else
        echo "Error: No supported package manager found (apt, dnf, yum, pacman, zypper)."
        echo "Please install ImageMagick manually: https://imagemagick.org/script/download.php"
        exit 1
    fi
}

case "$OS" in
    Darwin)
        install_macos
        ;;
    Linux)
        install_linux
        ;;
    *)
        echo "Error: Unsupported OS '$OS'. This script supports macOS and Linux only."
        exit 1
        ;;
esac

if command -v magick &>/dev/null; then
    echo "ImageMagick installed successfully: $(magick --version | head -1)"
else
    echo "Warning: 'magick' command not found after install. You may need to restart your shell."
fi
