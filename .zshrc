# Load Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Simplify prompt
setopt PROMPT_SUBST

function git_prompt() {
    ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

    local UNTRACKED="%F{red}•%f"
    local MODIFIED="%F{yellow}•%f"
    local STAGED="%F{green}•%f"

    local -a FLAGS

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        FLAGS+=( "$UNTRACKED" )
    fi

    if ! git diff --quiet 2> /dev/null; then
        FLAGS+=( "$MODIFIED" )
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        FLAGS+=( "$STAGED" )
    fi

    if [[ -z "${FLAGS}" ]]; then
        FLAGS+=( "%F{white}•%f" )
    fi

    echo " ${FLAGS} %F{yellow}$(git_current_branch)%f";
}

PROMPT='%F{blue}%~%f$(git_prompt) %% '

TMOUT=1

TRAPALRM() {
    zle reset-prompt
}

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

# Git Aliases/Functions
function git_current_branch() {
  local ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function ggl() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git pull origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git pull origin "${b:=$1}"
  fi
}
compdef _git ggl=git-checkout

function ggp() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git push origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git push origin "${b:=$1}"
  fi
}
compdef _git ggp=git-checkout

alias gst="git status"
alias ga="git add"
alias gc="git commit -v"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gbD="git branch --delete --force"
alias grhh="git reset --hard HEAD"
alias groh='git reset origin/$(git_current_branch) --hard'
alias gp="git push"
alias gl="git pull"
alias gb="git branch"
