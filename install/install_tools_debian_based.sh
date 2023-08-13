#!/usr/bin/env bash

mkdir -p ~/build

sudo apt update

sudo apt-get install -y \
    make cmake git \
    gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip \
    make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev git

# Install neovim
if ! [ -d $HOME/build/neovim ]; then
    git clone https://github.com/neovim/neovim ~/build/neovim
    cd ~/build/neovim/
    make -j `nproc`
    sudo make install
fi

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Rust tools
# Check that rust is installed... otherwise should run this
if ! [ -x "$(command -v cargo)" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# ZSH
sudo apt-get install -y zsh

# Install workflow tools
sudo apt-get install -y bc fzf xclip

# Install stuff for remaps
sudo apt-get install -y xdotool xcape

# TMUX
sudo apt-get install -y tmux

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
