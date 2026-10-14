#!/usr/bin/env bash
set -uo pipefail

# Diagnosis must not trigger mise's automatic updates or tool installation.
export MISE_SELF_UPDATE_AUTO=false MISE_TOOL_UPDATE_GLOBAL_AUTO=false
export MISE_AUTO_INSTALL=false MISE_EXEC_AUTO_INSTALL=false
failures=0

check() {
  local label="$1"
  shift
  echo "Checking: $label"
  if "$@"; then
    echo "OK: $label"
  else
    echo "FAIL: $label" >&2
    failures=$((failures + 1))
  fi
}

agent_socket_exists() {
  local socket="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  if [[ -S "$socket" ]]; then
    return
  fi
  echo "Open 1Password > Settings > Developer and enable Use the SSH Agent."
  echo "Expected socket: $socket"
  return 1
}

update_agent() {
  local label="$1" state last_exit
  state="$(launchctl print "gui/$(id -u)/$label" 2>&1)" || {
    echo "$label is not loaded; apply bootstrap to install its LaunchAgent."
    return 1
  }
  last_exit="$(printf '%s\n' "$state" | sed -nE 's/^[[:space:]]*last exit code = ([0-9]+).*$/\1/p')"
  if [[ -n "$last_exit" && "$last_exit" != 0 ]]; then
    echo "$label last exited with status $last_exit."
    return 1
  fi
  echo "$label is loaded; last exit code: ${last_exit:-not recorded yet}"
}

main() {
  check "mise diagnostics" mise doctor
  check "declared machine state" mise bootstrap status --missing

  for tool in hx tsc typescript-language-server dotfiles-typescript-language-server taplo bash-language-server shellcheck shfmt; do
    check "$tool on PATH" command -v "$tool"
  done
  if command -v hx >/dev/null 2>&1; then
    for language in typescript toml bash; do
      check "Helix $language support" hx --health "$language"
    done
  fi

  if [[ "$(uname -s)" == Darwin ]]; then
    check "1Password SSH agent socket" agent_socket_exists
    check "tool update LaunchAgent" update_agent dev.mise.mise-tool-update
    check "package update LaunchAgent" update_agent dev.mise.mise-package-update
    echo "Package update logs: ~/Library/Logs/mise-package-update{,.err}.log"
  fi

  if [[ "$failures" -gt 0 ]]; then
    echo "$failures checks need attention." >&2
    return 1
  fi
  echo "All machine checks passed."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
