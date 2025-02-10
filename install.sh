#!/bin/bash

# ------------------------------
# Script para instalación de software en Ubuntu
# ------------------------------

install_package() {
    package="$1"
    echo "Instalando: $package"
    if sudo apt install -y "$package"; then
        echo "$package instalado correctamente."
    else
        echo "Error instalando $package. Continuando con el siguiente..."
    fi
}

install_snap_package() {
    package="$1"
    echo "Instalando: $package (Snap)"
    if sudo snap install "$package"; then
        echo "$package instalado correctamente."
    else
        echo "Error instalando $package. Continuando con el siguiente..."
    fi
}

install_base_tools() {
    echo "Actualizando sistema y añadiendo herramientas básicas..."
    sudo apt update && sudo apt upgrade -y
    for pkg in build-essential curl wget git vim net-tools htop gnome-tweaks cargo unzip cmatrix tmux fzf ninja-build latexmk zathura black; do
        install_package "$pkg"
    done
    cargo install exa || echo "Error instalando exa."
    npm install -g vscode-langservers-extracted || echo "Error instalando vscode-langservers-extracted."
}

install_development_tools() {
    echo "Instalando herramientas de desarrollo..."
    for pkg in gcc g++ make cmake python3 python3-pip openjdk-17-jdk nodejs npm docker.io docker-compose postgresql postgresql-contrib libpq-dev; do
        install_package "$pkg"
    done
    sudo snap install code --classic || echo "Error instalando Visual Studio Code."
}

install_deep_learning_packages() {
    echo "Instalando paquetes y entornos para Deep Learning..."
    pip3 install --upgrade pip
    for pkg in numpy scipy matplotlib pandas scikit-learn tensorflow keras torch torchvision jupyter jupyterlab; do
        pip3 install "$pkg" || echo "Error instalando $pkg."
    done
}

install_productivity_tools() {
    echo "Instalando aplicaciones de productividad..."
    for pkg in libreoffice onlyoffice-desktopeditors notion-snap obsidian discord; do
        install_snap_package "$pkg"
    done
}

install_multimedia_tools() {
    echo "Instalando aplicaciones multimedia y utilidades..."
    for pkg in vlc gimp inkscape obs-studio; do
        install_package "$pkg"
    done
    install_snap_package spotify
}

install_neovim() {
    echo "Instalando neovim v.10..."
    cd ~
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git checkout v0.10.0
    make CMAKE_BUILD_TYPE=Release
    sudo make install || echo "Error instalando Neovim."
    rm -rf ~/neovim
    cd ~
}

setup_dotfiles() {
    echo "Descargando y configurando dotfiles..."
    git clone https://github.com/urubiog/dotfiles
    cd dotfiles
    for file in .bashrc .gitconfig .clang-format .tmux.conf; do
        mv "$file" ~/
    done
    mv nvim ~/.config/nvim/
    cd ~
    rm -rf dotfiles
}

install_markdown_preview() {
    path="/home/$(whoami)/.local/share/nvim/lazy/markdown-preview.nvim/app"
    if [ -d "$path" ]; then
        cd "$path"
        npm install || echo "Error instalando dependencias de markdown-preview."
    else
        echo "El directorio de markdown-preview no existe."
    fi
    cd ~
}

clean_system() {
    echo "Limpiando el sistema..."
    sudo apt autoremove -y && sudo apt autoclean
}

update_system() {
    echo "Últimas actualizaciones..."
    sudo apt update && sudo apt upgrade -y
}

# Ejecución de las funciones
install_base_tools
install_development_tools
install_deep_learning_packages
install_productivity_tools
install_multimedia_tools
install_neovim
setup_dotfiles

# Abrir nvim
echo "Abriendo nvim e instalando plugins (no toque nada)..."
nvim -c 'Lazy' -c 'MasonInstallAll' -c 'q!'

install_markdown_preview
clean_system
update_system
