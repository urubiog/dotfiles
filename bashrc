# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Check if we have color support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=
fi

# Define colors
if [ "$color_prompt" = yes ]; then
    # Color definitions
    GREEN="\[\033[01;32m\]"
    BLUE="\[\033[01;34m\]"
    YELLOW="\[\033[01;33m\]"
    RESET="\[\033[00m\]"
else
    GREEN=""
    BLUE=""
    YELLOW=""
    RESET=""
fi

# Define prompt with new line above
PS1="
${debian_chroot:+($debian_chroot)}\
${GREEN}\u@\h ${BLUE}\w \n${YELLOW}$ ${RESET}"

# Define cursor style
echo -e '\e[6 q'

# some more ls aliases
alias ls='exa -F --icons'
alias ll='exa -l --icons'
alias la='exa -a --icons'
alias l='exa -F --icons'
alias cat='batcat --paging=never'
alias fzf='fzf --preview="batcat --paging=never --color=always {}"'
alias n="nvim"
alias cdc="cd /mnt/c/Users/Uri26/"
alias py="python3"
alias cmatrix="cmatrix -b -s"


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Source fzf if available
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Custom PS1 from old bashrc (including potential kali configs)
PROMPT_ALTERNATIVE=oneline
NEWLINE_BEFORE_PROMPT=yes

# Adjust PS1 for different termianls
case "$TERM" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
        PS1="\[\]$PS1"
        ;;
    *)
        ;;
esac

[ "$NEWLINE_BEFORE_PROMPT" = yes ] && PROMPT_COMMAND="PROMPT_COMMAND=echo"

# Not case sensible for autcomplete
shopt -s nocaseglob

# Autocompletado insensible a mayúsculas y minúsculas
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "TAB: menu-complete"
. "$HOME/.cargo/env"
