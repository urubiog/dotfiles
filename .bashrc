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
    LILA="\[\033[01;35m\]"
else
    GREEN=""
    BLUE=""
    YELLOW=""
    RESET=""
    LILA=""
fi

# Define prompt with new line above
PS1="${debian_chroot:+($debian_chroot)}\
${LILA}\u@\h ${BLUE}/\W \n${LILA}$ ${RESET}"

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

export EDITOR=nvim

function pyscript() {
    sourcenv && nvim /tmp/main.py && : > /tmp/main.py && source ~/.bashrc
}

function upc() {
    explorer https://raco.fib.upc.edu/home/portada/uriel.rubio
    explorer https://atenea.upc.edu/my/
    explorer https://mail.google.com/mail/u/1/#inbox

    cd /home/uri/NextCloud/DADES/
    wt.exe -w 0 split-pane -p Debian wsl.exe --cd /home/uri/OneDrive/CS/
}

# fnm
FNM_PATH="/home/uri/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/usr/local/go/bin

# zoxide 
eval "$(zoxide init bash)"

fastfetch --pipe false | while IFS= read -r line; do
    for (( i=0; i<${#line}; i++ )); do
        printf "%s" "${line:$i:1}"
    done
    sleep 0.005
    printf "\n"
done

