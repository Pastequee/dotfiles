#!/usr/bin/env bash
set -euo pipefail

# Preserve custom PAM rules and uncomment at most one template entry.
render_touch_id_config() {
  awk '
    /^[[:space:]]*auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so([[:space:]]|$)/ { enabled = 1 }
    { lines[NR] = $0 }
    END {
      for (i = 1; i <= NR; i++) {
        if (!enabled && lines[i] ~ /^[[:space:]]*#[[:space:]]*auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so([[:space:]]|$)/) {
          sub(/^[[:space:]]*#[[:space:]]*/, "", lines[i])
          enabled = 1
        }
        print lines[i]
      }
      if (!enabled) print "auth       sufficient     pam_tid.so"
    }
  '
}

main() (
  if [[ "$(uname -s)" != Darwin ]]; then
    echo "Touch ID setup is only supported on macOS" >&2
    exit 1
  fi
  if ! grep -Eq '^[[:space:]]*auth[[:space:]]+include[[:space:]]+sudo_local([[:space:]]|$)' /etc/pam.d/sudo; then
    echo "This macOS version does not include sudo_local; leaving PAM unchanged" >&2
    exit 1
  fi

  source_config=/etc/pam.d/sudo_local
  [[ -e "$source_config" ]] || source_config=/etc/pam.d/sudo_local.template
  staging="$(mktemp)"
  trap 'rm -f "$staging"' EXIT
  render_touch_id_config <"$source_config" >"$staging"
  if [[ -f /etc/pam.d/sudo_local ]] && cmp -s "$staging" /etc/pam.d/sudo_local; then
    echo "Touch ID for sudo already enabled"
    exit 0
  fi

  # Stage beside the destination so the final rename is atomic.
  sudo /bin/sh -eu -c '
    staging=$(mktemp /etc/pam.d/.sudo_local.XXXXXX)
    trap '\''rm -f "$staging"'\'' EXIT
    install -o root -g wheel -m 0644 "$1" "$staging"
    mv -f "$staging" /etc/pam.d/sudo_local
  ' sh "$staging"
  echo "Touch ID for sudo enabled in /etc/pam.d/sudo_local"
)

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
