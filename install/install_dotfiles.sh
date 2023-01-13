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

# Setup symlinks
ln -s $HOME/.dotfiles/tmux $HOME/.config/tmux
ln -s $HOME/.dotfiles/zsh $HOME/.config/zsh
ln -s $HOME/.config/zsh/.zprofile $HOME/.zprofile
ln -s $HOME/.dotfiles/i3 $HOME/.config/i3

# Neovim
git clone git@github.com:mhtoribio/nvim.conf $HOME/.config/nvim

# Cleanup
killall ssh-agent
