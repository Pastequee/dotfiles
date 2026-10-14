#!/usr/bin/env bash
set -euo pipefail

# Resolve global installs at launch, independent of the project's mise config.
typescript_root="$(mise -C "$HOME" where npm:typescript)"
server_root="$(mise -C "$HOME" where npm:typescript-language-server)"
export NODE_PATH="$typescript_root/node_modules${NODE_PATH:+:$NODE_PATH}"

# mise's npm shim resets NODE_PATH; run the package entrypoint directly.
# The server still prefers a project's own TypeScript over this fallback.
exec node "$server_root/node_modules/typescript-language-server/lib/cli.mjs" "$@"
