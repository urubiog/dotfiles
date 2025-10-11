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
    for pkg in build-essential curl wget git fastfetch zoxide vim net-tools htop gnome-tweaks cargo unzip cmatrix tmux fzf ninja-build latexmk zathura black bat gettext; do
        install_package "$pkg"
    done
    cargo install exa || echo "Error instalando exa."
    npm install -g vscode-langservers-extracted || echo "Error instalando vscode-langservers-extracted."
}

install_development_tools() {
    echo "Instalando herramientas de desarrollo..."
    for pkg in gcc g++ make cmake python3 python3-pip openjdk-17-jdk nodejs npm docker.io docker-compose postgresql postgresql-contrib libpq-dev virtualenv python3.12-env golang; do
        install_package "$pkg"
    done
    sudo snap install code --classic || echo "Error instalando Visual Studio Code."
}

create_virtualenv() {
    base_path="/home/$(whoami)/Documents"

    echo "Creando entorno virtual en $base_path..."

    if ![ -d "$base_path" ]; then
        mkdir $base_path
    fi

    cd base_path
    mkdir Envs
    cd !$
    virtualenv general
    source $base_path/Envs/general/bin/activate
    pip install uv
    source /home/$(whoami)/.bashrc
}

install_deep_learning_packages() {
    echo "Instalando paquetes y entornos para Deep Learning..."
    source /home/$(whoami)/Documents/Envs/general/bin/activate
    uv pip3 install --upgrade pip
    for pkg in numpy scipy matplotlib pandas scikit-learn keras torch torchvision jupyter jupyterlab; do
        uv pip3 install "$pkg" || echo "Error instalando $pkg."
    done
    source /home/$(whoami)/.bashrc
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
    echo "Instalando Neovim v0.11.4..."
    cd /tmp || exit

    # Descargar el tar.gz de Neovim
    wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz -O nvim-linux-x86_64.tar.gz

    # Extraer el archivo
    tar xzf nvim-linux-x86_64.tar.gz

    # Mover los binarios al directorio adecuado
    sudo mv nvim-linux-x86_64 /usr/local/share/nvim

    # Crear enlaces simbólicos para neovim
    sudo ln -sf /usr/local/share/nvim/bin/nvim /usr/bin/nvim
    sudo ln -sf /usr/local/share/nvim/bin/nvim /usr/local/bin/nvim

    # Limpiar
    rm -f nvim-linux-x86_64.tar.gz
    cd ~
    echo "Neovim v0.11.4 instalado correctamente."
}

setup_dotfiles() {
    echo "Descargando y configurando dotfiles..."
    git clone https://github.com/urubiog/dotfiles
    cd dotfiles
    for file in .bashrc .bash_aliases .gitconfig .clang-format .tmux.conf; do
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
        chmod +x install.sh
        ./install.sh || echo "Error instalando dependencias de markdown-preview."
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
create_virtualenv
install_deep_learning_packages
install_productivity_tools
install_multimedia_tools
install_neovim
setup_dotfiles

# Abrir nvim
echo "Abriendo nvim e instalando plugins (no toque nada)..."
nvim -c 'Lazy' -c 'MasonInstallAll' -c 'TSInstall bash c clojure cpp css dart elixir elm go haskell html java javascript json kotlin lua markdown php python r ruby rust scala sql typescript vim yaml' -c 'q!'

# Set nvchad ui commit
# cd "/home/$(whoami)/.local/share/nvim/lazy/ui/lua/nvchad"
# git checkout 7c51760

install_markdown_preview
clean_system
update_system
