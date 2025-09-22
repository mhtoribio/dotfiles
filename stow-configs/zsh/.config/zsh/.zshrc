# zmodload zsh/zprof #profiling
# (man zshoptions)
setopt nomatch menucomplete

# No beeping, please
unsetopt beep

# Completions
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots) # include hidden files
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Colors
autoload -Uz colors && colors

# Useful functions (required for plugins)
source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-exports"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-keybindings"
if [ -f /etc/wsl.conf ]; then
    zsh_add_file "zsh-wsl"
fi
zsh_add_file "zsh-prompt"
# zprof #profiling
