#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

have() {
  command -v "$1" >/dev/null 2>&1
}

if [[ -d /Applications/Tinycast.app ]]; then
  echo "Tinycast already installed"
elif have brew; then
  brew trust --tap abue-ammar/tinycast
  brew install --cask abue-ammar/tinycast/tinycast
else
  echo "Tinycast needs Homebrew (third-party tap has no mise API metadata)."
  echo "  brew trust --tap abue-ammar/tinycast"
  echo "  brew install --cask abue-ammar/tinycast/tinycast"
fi

if have t3; then
  echo "t3 already installed"
else
  curl -fsSL https://t3.codes/install.sh | T3CODE_CHANNEL=nightly sh
fi

if have agent || have cursor-agent; then
  echo "Cursor CLI already installed"
else
  curl https://cursor.com/install -fsS | bash
fi

if have codex; then
  echo "codex already installed"
else
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi
