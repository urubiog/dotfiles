# .bash_aliases

# Ensuring that we handle environment variables and paths well
# Working Directory (adjust path according to your needs)
WORKDIR=~/OneDrive/CS/

# Virtualenv activation path based on the system type
if [ -d "/mnt/c/Users" ]; then
    # Windows Subsystem for Linux (WSL)
    USER=$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | sed 's/.*\\//' | sed 's/\r//')
    ACTIVATE="/mnt/c/Users/$USER/Documents/Envs/general/bin/activate"
    alias cdc="cd '/mnt/c/Users/$USER/'"  # Shortcuts for easier navigation in WSL
    
    # Define useful aliases for WSL/Windows environment
    alias explorer="explorer.exe"  # Open Explorer
    alias cmd="cmd.exe"  # Access Command Prompt
    alias github="cmd.exe /C start https://github.com"  # Open GitHub in default browser
    
else
    # Linux environment
    ACTIVATE=~/Documents/Envs/venv/bin/activate  # Ensures absolute path expansion for Linux

    # File manager for Linux (nautilus) and fallback for other systems
    if command -v nautilus &>/dev/null; then
        alias explorer="nautilus"  # File Explorer for Linux
    else
        alias explorer="xdg-open"  # Fallback to default file opener if nautilus is not available
    fi

    # Open GitHub in browser via Linux default (e.g., Firefox)
    alias github="firefox https://www.github.com/urubiog" 
fi

# Ensure `ACTIVATE` exists before sourcing it
if [ -f "$ACTIVATE" ]; then
    alias sourcenv="source $ACTIVATE"  # Shorter command to activate the virtual environment
else
    echo "Virtual environment activation script not found: $ACTIVATE"
fi

# Aliases for ls (listing files) with icons and formatting using exa
alias ls='exa -F --icons'  # Display with file type icons
alias ll='exa -l --icons'  # Long listing with icons
alias la='exa -a --icons'  # All files (including hidden)
alias l='exa -F --icons'   # Simplified listing with icons

# Enhance common commands
alias cat='batcat --paging=always --color=always'  # Better cat command with syntax highlighting
alias bat='batcat --paging=always --color=always '  # `bat` alias
alias fzf='fzf --preview="batcat --color=always -n {}"'  # Fuzzy finder with preview
alias n='nvim'  # Neovim shortcut
alias nfzf='n $(fzf)'  # Neovim with fzf for file searching
alias py='python3'  # Python 3 shortcut
alias ..='cd ..'  # Go up one directory
alias ....='cd ../..'  # Go up two directories

# Network tools alias (commented out)
# alias nmapA="echo 'sudo nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn -oG allPorts'"
# alias nmapB="echo 'sudo nmap -sCV -p(ports) (ip) -oN targeted'"

# Enhanced Git log
alias gitshow='git log --oneline --graph --all --decorate'  # Quick git history view

# Simpler file listing alias
alias sl='ls'
alias sls='ls'
