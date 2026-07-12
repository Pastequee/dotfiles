#!/usr/bin/env bash
#
# Install AI command line tools

set -e

case "$(uname -s)" in
  Darwin|Linux)
    echo "Installing Claude Code CLI..."
    curl -fsSL https://claude.ai/install.sh | bash

    echo "Installing Codex CLI..."
    curl -fsSL https://chatgpt.com/codex/install.sh | sh
    ;;
  *)
    echo "Skipping AI CLI installation on unsupported OS: $(uname -s)"
    ;;
esac
