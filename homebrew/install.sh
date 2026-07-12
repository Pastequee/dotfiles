#!/usr/bin/env bash
#
# Homebrew
#
# Installs Homebrew if missing, then everything declared in the Brewfile.

set -e

if ! command -v brew >/dev/null; then
  echo "  Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew bundle --file="$(dirname "$0")/Brewfile"

# Cleanup
brew cleanup
rm -rf "$(brew --cache)"
