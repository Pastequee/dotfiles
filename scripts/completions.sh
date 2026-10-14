#!/usr/bin/env bash
set -euo pipefail

completion_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/generated-completions"
mkdir -p "$completion_dir"
staging="$(mktemp -d "$completion_dir/.refresh.XXXXXX")"
trap 'rm -rf "$staging"' EXIT

# Finish every generator before replacing any working completion files.
mise completion zsh >"$staging/_mise"
gh completion --shell zsh >"$staging/_gh"
starship completions zsh >"$staging/_starship"
cp "$(mise where zoxide)/completions/_zoxide" "$staging/_zoxide"
rg --generate complete-zsh >"$staging/_rg"
bat --completion zsh >"$staging/_bat"

for completion in "$staging"/_*; do
  if [[ ! -s "$completion" ]]; then
    echo "Empty completion: ${completion##*/}; existing files kept" >&2
    exit 1
  fi
  zsh -n "$completion"
done
for completion in "$staging"/_*; do
  mv -f "$completion" "$completion_dir/${completion##*/}"
done
echo "Completions refreshed in $completion_dir"
