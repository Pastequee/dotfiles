# AGENTS.md

Personal macOS machine setup. **mise** is the provisioner. Shared files live in `home/`; declarations live in `mise.toml`. Look those up instead of copying lists here.

## Modify

1. Config: add or edit the file under `home/`, then point `[dotfiles]` at the live path (`symlink` or `symlink-each`). Extra SSH goes in `home/ssh/config`; `~/.ssh/config` stays the user's file (Include only).
2. Installs: `[tools]` for versioned CLIs, `[bootstrap.packages]` for `brew-cask:` / `mas:` / `brew:`. Anything that needs a vendor script, a GitHub DMG, or a tap without Homebrew API metadata goes in `scripts/install-extras.sh` and must skip if already installed. The bootstrap task must `run` with `dir = "~/src/dotfiles"` (this toml is also the global mise config, so relative `file =` paths resolve from `$HOME`).
3. macOS prefs: `[bootstrap.macos.*]` and `[bootstrap.hooks.post-defaults]`.
4. Done when the source file and `mise.toml` match, `README.md` clone/bootstrap still describes the real flow, and nothing secret was committed.

Keep off git: git identity (`local_config`), `~/.config/zsh/local.zsh`, SSH keys, `known_hosts`. Edit this repo; run `mise bootstrap` only when the user asks to apply it to the machine.
