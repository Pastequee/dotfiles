#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
update_extras=0

have() {
  command -v "$1" >/dev/null 2>&1
}

install_zinit() {
  local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ -f "$zinit_home/zinit.zsh" ]]; then
    echo "zinit already installed"
  else
    mkdir -p "$(dirname "$zinit_home")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$zinit_home"
  fi
}

install_deja_binary() {
  # Install only the binary; zsh mode would append to the linked ~/.zshrc.
  curl -fsSL https://raw.githubusercontent.com/Giammarco-Ferranti/deja/main/install.sh |
    env -u ZSH_VERSION SHELL=/bin/sh INSTALL_DIR="$HOME/.local/bin" sh
}

install_deja() {
  if have deja; then
    if [[ "$update_extras" == 1 ]]; then
      install_deja_binary
    else
      echo "Deja already installed"
    fi
    # Re-importing would increase command frequencies on every update.
    return
  fi

  install_deja_binary
  local history_file="${ZDOTDIR:-$HOME}/.zsh_history"
  if [[ -r "$history_file" ]]; then
    deja import --file "$history_file"
  else
    echo "No readable zsh history yet; skipping Deja import"
  fi
}

manage_zsh_plugins() {
  # Populate plugins without loading prompt/terminal hooks in a non-TTY task.
  TERM=xterm-256color DOTFILES_ZSH_DIR="$script_dir/../home/zsh" zsh -dfi -c '
    if [[ "$1" == 1 ]]; then
      source "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git/zinit.zsh" || exit
      zinit self-update --no-pager || exit
    fi
    source "$DOTFILES_ZSH_DIR/export.zsh" || exit
    source "$DOTFILES_ZSH_DIR/plugins.zsh" || exit
    if [[ "$1" == 1 ]]; then
      zinit update --all || exit
    fi
    exit 0
  ' -- "$update_extras"
}

tinycast_version() {
  python3 -c 'import plistlib, sys; print(plistlib.load(open(sys.argv[1], "rb"))["CFBundleShortVersionString"])' \
    "$1/Contents/Info.plist"
}

# mise pours brew packages without a brew CLI, and this tap has no cask API JSON.
install_tinycast() (
  # These variables belong to the subshell, so EXIT cleanup can still read them
  # after Bash unwinds the function on an error.
  app="${1:-/Applications/Tinycast.app}"
  if [[ -d "$app" && "$update_extras" == 0 ]]; then
    echo "Tinycast already installed"
    return
  fi

  stage=""
  tmp="$(mktemp -d)"
  # Called indirectly by the EXIT trap.
  # shellcheck disable=SC2329
  cleanup_tinycast() {
    if [[ -d "$tmp/mnt" ]]; then
      hdiutil detach "$tmp/mnt" >/dev/null 2>&1 || true
    fi
    if [[ -n "$stage" ]]; then
      if [[ -d "$stage/previous.app" && ! -e "$app" ]]; then
        # If replacement failed, restore the previous app before cleanup.
        mv "$stage/previous.app" "$app" || return
      fi
      rm -rf "$stage"
    fi
    rm -rf "$tmp"
  }
  trap cleanup_tinycast EXIT

  curl -fsSL --retry 3 -H 'Accept: application/vnd.github+json' -H 'User-Agent: dotfiles-bootstrap' \
    https://api.github.com/repos/abue-ammar/tinycast/releases/latest >"$tmp/release.json"
  ver="$(jq -er '.tag_name | ltrimstr("v")' "$tmp/release.json")"
  if [[ -d "$app" ]]; then
    installed="$(tinycast_version "$app")"
    if [[ "$installed" == "$ver" ]]; then
      echo "Tinycast $ver already up to date"
      return
    fi
  fi
  if pgrep -x Tinycast >/dev/null; then
    echo "Quit Tinycast, then rerun mise run update-extras" >&2
    return 1
  fi

  # Universal releases also support Intel Macs; fall back to the standard DMG.
  jq -e --arg ver "$ver" '
    ([.assets[] | select(.name == ("Tinycast-Universal-" + $ver + ".dmg"))][0]
      // [.assets[] | select(.name == ("Tinycast-" + $ver + ".dmg"))][0])
  ' "$tmp/release.json" >"$tmp/asset.json"
  url="$(jq -er '.browser_download_url' "$tmp/asset.json")"
  digest="$(jq -er '.digest | select(startswith("sha256:")) | ltrimstr("sha256:")' "$tmp/asset.json")"
  curl -fL --retry 3 -o "$tmp/Tinycast.dmg" "$url"
  printf '%s  %s\n' "$digest" "$tmp/Tinycast.dmg" | shasum -a 256 -c -

  mkdir -p "$tmp/mnt"
  hdiutil attach -readonly -nobrowse -mountpoint "$tmp/mnt" "$tmp/Tinycast.dmg" >/dev/null
  stage="$(mktemp -d "$(dirname "$app")/.Tinycast.XXXXXX")"
  ditto "$tmp/mnt/Tinycast.app" "$stage/Tinycast.app"
  xattr -dr com.apple.quarantine "$stage/Tinycast.app"
  if [[ -d "$app" ]]; then
    mv "$app" "$stage/previous.app"
  fi
  mv "$stage/Tinycast.app" "$app"
  echo "Tinycast ${ver} installed"
)

main() {
  local dry_run=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --update) update_extras=1 ;;
      --dry-run) dry_run=1 ;;
      --help)
        echo "Usage: $0 [--update] [--dry-run]"
        echo "Bootstrap skips existing installs. --update refreshes extras and all zinit plugins."
        return
        ;;
      *)
        echo "Unknown argument: $1" >&2
        return 2
        ;;
    esac
    shift
  done
  if [[ "$dry_run" == 1 ]]; then
    if [[ "$update_extras" == 1 ]]; then
      echo "Would refresh Deja, update zinit and its plugins, and update Tinycast if its release changed."
    else
      echo "Would install missing zinit, Deja, zsh plugins, and Tinycast."
    fi
    echo "Would regenerate zsh completions. No downloads or changes made."
    return
  fi

  install_zinit
  install_deja
  "$script_dir/completions.sh"
  manage_zsh_plugins
  install_tinycast
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
