# Enable colors
autoload -U colors && colors

# Load version control info
autoload -Uz vcs_info

# Format version control info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "%{$fg[yellow]%}"
zstyle ':vcs_info:*' stagedstr "%{$fg[red]%}"
zstyle ':vcs_info:git*' formats " %{$fg[green]%}%c%u(%r:%b)"
zstyle ':vcs_info:git*' actionformats " %{$fg[green]%}(%r:%b %m%u%c)"
precmd() {vcs_info}

# Set prompt
setopt prompt_subst
PS1='%B%{$fg[white]%}[%{$fg[blue]%}%n%{$fg[cyan]%}@%{$fg[green]%}%M %{$fg[blue]%}%~${vcs_info_msg_0_}%{$fg[white]%}]%{$reset_color%}$%b '

# History in cache directory
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # include hidden files

# vi mode
bindkey -v
export KEYTIMEOUT=1

## Change cursor shape for different vi modes.
#function zle-keymap-select () {
	#case $KEYMAP in
		#vicmd) echo -ne '\e[1 q';;      # block shape
		#viins|main) echo -ne '\e[5 q';; # beam shape
	#esac
#}
#zle -N zle-keymap-select
#zle-line-init() {
	#zle -K viins # initiate 'vi insert' as keymap
	#echo -ne "\e[5 q"
#}
#zle -N zle-line-init
#echo -ne '\e[5 q' # use beam shape cursor on startup
#preexec() { echo -ne '\e[5 q'; } # use beam shape cursor for each new prompt.

# FZF find dirs
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

# Simple calculator
bindkey -s '^a' 'bc -lq\n'

# Use colors in ls
alias ls='ls --color=auto'
