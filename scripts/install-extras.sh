#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$HOME/.local/bin:$PATH"

have() {
  command -v "$1" >/dev/null 2>&1
}

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
