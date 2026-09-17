# Language
export LANG=en_US.UTF-8
export LC_LANG=en_US.UTF-8

export EDITOR="hx"
export VISUAL="hx"

export MANPATH="/usr/local/man:$MANPATH"
export XDG_CONFIG_HOME="$HOME/.config"

# 42
export LOGIN_42='apigeon'
export MAIL_42="$LOGIN_42@student.42.fr"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

export PATH="$HOME/.local/bin:$PATH"
