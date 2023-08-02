#!/usr/bin/env bash

GH_SSH_KEY=$HOME/.ssh/github 

# Check for github ssh key
if ! [ -f $GH_SSH_KEY ]; then
    echo "Github ssh key not found. Place under $HOME/.ssh/github"
    exit 1
fi

eval "$(ssh-agent -s)"
ssh-add $GH_SSH_KEY

git clone git@github.com:mhtoribio/dotfiles.git $HOME/.dotfiles

if [[ -d "$HOME/.config" ]]; then
    MOVE_CONFIG=true
fi

if [[ $MOVE_CONFIG ]]; then
    echo "Moving config"
    mv ~/.config ~/_temp_config
fi

mkdir -p ~/.config

# Setup symlinks
ln -sv $HOME/.dotfiles/tmux $HOME/.config/tmux
ln -sv $HOME/.dotfiles/zsh $HOME/.config/zsh
ln -sv $HOME/.config/zsh/.zshenv $HOME/.zshenv
ln -sv $HOME/.dotfiles/i3 $HOME/.config/i3
ln -sv $HOME/.dotfiles/i3status $HOME/.config/i3status
ln -sv $HOME/.dotfiles/alacritty $HOME/.config/alacritty
ln -sv $HOME/.dotfiles/zathura $HOME/.config/zathura
ln -sv $HOME/.dotfiles/x11/.xprofile ~/.xsessionrc
ln -sv $HOME/.dotfiles/x11/.xprofile ~/.xprofile

# Neovim
git clone git@github.com:mhtoribio/nvim.conf $HOME/.config/nvim

# Scripts
git clone git@github.com:mhtoribio/hmbin $HOME/.local/hmbin

# Cleanup temp_config
if [[ $MOVE_CONFIG ]]; then
    cp -r ~/_temp_config/* ~/.config/
    rm -rf ~/_temp_config
fi

# Cleanup
killall ssh-agent
