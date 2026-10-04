# Language
export LANG=en_US.UTF-8
export LC_LANG=en_US.UTF-8

export EDITOR="hx"
export VISUAL="hx"

export MANPATH="/usr/local/man:$MANPATH"
export XDG_CONFIG_HOME="$HOME/.config"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'ctrl-/:toggle-preview'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}' --bind 'ctrl-/:toggle-preview'"
export FZF_DEFAULT_OPTS='
  --layout=reverse
  --color=fg:#908caa,hl:#ebbcba
  --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
  --color=border:#403d52,header:#31748f,gutter:#191724
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
'

# Keep Tab for fzf-tab completions; Ctrl+] cycles Deja alternatives.
export DEJA_CYCLE_KEY='^]'
# Keep Ctrl+X as a prefix for edit-command-line (Ctrl+X, Ctrl+E).
export DEJA_TOGGLE_KEY='^X^X'

if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

export PATH="$HOME/.local/bin:$PATH"
