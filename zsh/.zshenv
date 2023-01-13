# Define zsh environment variables

export ZDOTDIR=~/.config/zsh

# XDG
XDG_PROFILE_HOME=$HOME/.config
XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache

# Editors
VIM='nvim'
alias vim=$VIM
export GIT_EDITOR=$VIM
export EDITOR=$VIM

# Path
export PATH=$PATH:$HOME/.local/bin:$HOME/.local/hmbin:/usr/local/avr/bin:$HOME/.cargo/bin
