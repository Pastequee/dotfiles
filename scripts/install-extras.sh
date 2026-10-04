#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$HOME/.local/bin:$PATH"

have() {
  command -v "$1" >/dev/null 2>&1
}

install_zsh() {
  local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ -f "$zinit_home/zinit.zsh" ]]; then
    echo "zinit already installed"
  else
    mkdir -p "$(dirname "$zinit_home")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$zinit_home"
  fi

  if have deja; then
    echo "Deja already installed"
  else
    # Install the binary only: the vendor's zsh mode appends to ~/.zshrc.
    curl -fsSL https://raw.githubusercontent.com/Giammarco-Ferranti/deja/main/install.sh \
      | env -u ZSH_VERSION SHELL=/bin/sh sh
    deja import --file "${ZDOTDIR:-$HOME}/.zsh_history"
  fi

  # Generate completions once per bootstrap, never on each shell startup.
  local completion_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/generated-completions"
  mkdir -p "$completion_dir"
  mise completion zsh > "$completion_dir/_mise"
  gh completion --shell zsh > "$completion_dir/_gh"
  starship completions zsh > "$completion_dir/_starship"
  # zoxide ships its completion in the release archive rather than generating it.
  cp "$(mise where zoxide)/completions/_zoxide" "$completion_dir/_zoxide"
  rg --generate complete-zsh > "$completion_dir/_rg"
  bat --completion zsh > "$completion_dir/_bat"

  # Populate plugins without loading prompt/terminal hooks in a non-TTY task.
  TERM=xterm-256color zsh -dfi -c '
    source "$HOME/.config/zsh/export.zsh"
    source "$HOME/.config/zsh/plugins.zsh"
    exit
  '
}

install_zsh

# mise pours brew packages without a brew CLI, and this tap has no cask API JSON.
install_tinycast() {
  if [[ -d /Applications/Tinycast.app ]]; then
    echo "Tinycast already installed"
    return
  fi

  local tmp tag ver
  tmp="$(mktemp -d)"
  cleanup_tinycast() {
    diskutil unmount "$tmp/mnt" >/dev/null 2>&1 || true
    rm -rf "$tmp"
  }
  trap cleanup_tinycast EXIT

  tag="$(
    curl -fsSL -H 'Accept: application/vnd.github+json' -H 'User-Agent: dotfiles-bootstrap' \
      https://api.github.com/repos/abue-ammar/tinycast/releases/latest \
      | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])'
  )"
  ver="${tag#v}"
  curl -fL --retry 3 -o "$tmp/Tinycast.dmg" \
    "https://github.com/abue-ammar/tinycast/releases/download/${tag}/Tinycast-${ver}.dmg"
  mkdir -p "$tmp/mnt"
  diskutil image attach --readOnly --nobrowse --mountPoint "$tmp/mnt" "$tmp/Tinycast.dmg" >/dev/null
  ditto "$tmp/mnt/Tinycast.app" /Applications/Tinycast.app
  xattr -dr com.apple.quarantine /Applications/Tinycast.app
  echo "Tinycast ${ver} installed"

  trap - EXIT
  cleanup_tinycast
}

install_tinycast

if have agent || have cursor-agent; then
  echo "Cursor CLI already installed"
else
  curl https://cursor.com/install -fsS | bash
fi

if have codex; then
  echo "codex already installed"
else
  curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
fi
