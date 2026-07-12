#!/bin/sh
#
# Shell tooling: oh-my-zsh and atuin.

# Oh my zsh install (unattended so it doesn't drop into a new shell mid-install)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Atuin shell history
if [ ! -d "$HOME/.atuin" ]; then
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi
