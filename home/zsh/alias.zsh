alias c='cursor'

# Git
alias gcmsg="git commit -m"
alias gcaa="git commit --amend"
alias gl="git pull"
alias gp="git push"
alias gss="git status --short"
alias glog="git log --oneline"
alias gd="git diff"
alias gaa="git add ."

if command -v eza &> /dev/null; then
  alias ls="eza"
  alias ll="eza -l"
  alias la="eza -la"
fi

if command -v nvim &> /dev/null; then
  alias vim="nvim"
fi

if [ "$(uname)" != 'Darwin' ]; then
  alias ipall="ip -br -c a"
fi
