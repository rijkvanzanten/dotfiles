# Load Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Simplify prompt
PROMPT="%F{blue}%~%f %% "

# Add some often used aliases
alias gst="git status"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gbD="git branch --delete --force"
alias grhh="git reset --hard HEAD"

# Search through history with what's already in the prompt
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Load the syntax highlighting pluging
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Setup more powerful auto-completion
autoload -Uz compinit;
compinit;

# Make auto-complete case insensitive
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 

# Allow partial completion suggestions (eg /u/lo/b -> /usr/local/bin)
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix
