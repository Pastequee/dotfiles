# atuin - shell history
if [ -f "$HOME/.atuin/bin/env" ]; then
  . "$HOME/.atuin/bin/env"
  eval "$(atuin init zsh)"
fi

# pnpm - Package Manager
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# bun - Package Manager & JS Runtime
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Claude CLI
if [ -f "$HOME/.claude/local/claude" ]; then
  alias claude="$HOME/.claude/local/claude"
fi

# fnm - node version manager
if command -v fnm >/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# psql client
if [ -d "/opt/homebrew/opt/libpq/bin" ]; then
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

# Local bin directory
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
