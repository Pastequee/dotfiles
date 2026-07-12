#!/usr/bin/env bash
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew (the official installer supports both macOS and Linux)
if ! command -v brew >/dev/null
then
  echo "  Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

function install() {
  app=$1
  cask=${2:-}

cat << EOF

-> Installing ${app}...
EOF

  if [[ x"$OS" == x"Windows" ]]; then
    scoop install ${app}
  else
    if [[ ! "$cask" ]]; then
      brew list ${app} >/dev/null || brew install ${app}
    else
      brew list ${app} --cask >/dev/null || brew install ${app} --cask
    fi
  fi

cat << EOF

-> ${app} installed
EOF
}

# Casks
install 1password yes
install codexbar yes
install keepingyouawake yes
install orbstack yes
install zed yes
install ghostty yes
install t3-code@nightly yes

# Tools & CLIs
install zsh
install fnm
install gh
install helix
install ripgrep
install libpq
install git-delta

# Cleanup
brew cleanup
rm -rf "$(brew --cache)"

exit 0
