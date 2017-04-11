#!/usr/bin/env bash

SCRIPT_PATH="$(dirname "${BASH_SOURCE}")";
CURRENT_PATH="$(pwd)"

git pull origin master;

git submodule update --init

function install_it() {
    mkdir -p "$HOME/.config"
    if [ -d "$HOME/.config/nvim" ]; then
        rm -rf "$HOME/.config/nvim";
    fi
    cd "$HOME/.config" || return 1
    ln -s "$SCRIPT_PATH/.vim" nvim;
    cd "$HOME" || return 1
    ln -s "$SCRIPT_PATH/.vim" .vim;
    echo "source $SCRIPT_PATH/.zsh_files/.zshrc" >> "$HOME/.zshrc"


    cd "$CURRENT_PATH" || return 0
}
