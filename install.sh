#!/bin/bash

# ------------------------------
# Script para instalación de software en Ubuntu
# ------------------------------

install_base_tools() {
    echo "Actualizando sistema y añadiendo herramientas básicas..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y build-essential curl wget git vim net-tools htop gnome-tweaks cargo unzip xselb cmatrix git tmux fzf ninja-build
    cargo install exa
}

install_development_tools() {
    echo "Instalando herramientas de desarrollo..."
    sudo apt install -y gcc g++ make cmake python3 python3-pip openjdk-17-jdk nodejs npm docker.io docker-compose
    sudo snap install code --classic # Visual Studio Code
    sudo apt install -y postgresql postgresql-contrib libpq-dev
}

install_deep_learning_packages() {
    echo "Instalando paquetes y entornos para Deep Learning..."
    pip3 install --upgrade pip
    pip3 install numpy scipy matplotlib pandas scikit-learn tensorflow keras torch torchvision jupyter jupyterlab
}

install_productivity_tools() {
    echo "Instalando aplicaciones de productividad..."
    sudo snap install libreoffice
    sudo snap install onlyoffice-desktopeditors
    sudo snap install notion-snap
    sudo snap install obsidian
    sudo snap install discord
}

install_multimedia_tools() {
    echo "Instalando aplicaciones multimedia y utilidades..."
    sudo apt install -y vlc gimp inkscape
    sudo snap install spotify
    sudo apt install -y obs-studio
}

install_neovim() {
    echo "Instalando neovim v.10..."
    cd ~
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git checkout v0.10.0
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    rm -rf ~/neovim
    cd ~
}

setup_dotfiles() {
    echo "Descargando y configurando dotfiles..."
    git clone https://github.com/urubiog/dotfiles 
    cd dotfiles
    mv nvim ~/.config/nvim/
    mv ./.bashrc ~/.bashrc 
    mv ./.gitconfig ~/.gitconfig 
    mv ./.clang-format ~/.clang-format 
    mv ./.tmux.conf ~/.tmux.conf 
    cd ~ 
    rm -rf dotfiles
}

install_markdown_preview() {
    if [ -d "/home/$(whoami)/.local/share/nvim/lazy/markdown-preview.nvim/app" ]; then
        cd /home/$(whoami)/.local/share/nvim/lazy/markdown-preview.nvim/app
        npm install
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
