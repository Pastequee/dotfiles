# dotfiles

macOS machine setup with [mise](https://mise.jdx.dev/).

## New machine

Clone over HTTPS. There is no SSH key yet; 1Password (and its SSH agent) is installed by bootstrap.

```sh
xcode-select --install
curl https://mise.run | sh
mkdir -p ~/src
git clone https://github.com/Pastequee/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
~/.local/bin/mise trust
~/.local/bin/mise bootstrap --dry-run
~/.local/bin/mise bootstrap --yes
cp home/git/local_config.example ~/.config/git/local_config
# edit name, email, optional 1Password signing
```

Then open a new terminal. Machine-only shell bits go in `~/.config/zsh/local.zsh`. After 1Password is signed in, you can switch the remote to SSH if you want (`git remote set-url origin git@github.com:Pastequee/dotfiles.git`).

## This machine (already cloned)

```sh
cd ~/src/dotfiles
mise trust
mise bootstrap --dry-run
mise bootstrap
```

## Layout

| Path | Role |
| --- | --- |
| `mise.toml` | tools, casks, dotfile links |
| `home/zshrc` | entrypoint: mise, starship, fzf |
| `home/zsh/export.zsh` | env vars |
| `home/zsh/alias.zsh` | aliases |
| `home/zsh/functions.zsh` | shell functions |
| `home/git/` | shared git config (identity is local) |
| `home/starship.toml` | prompt |
| `home/helix/config.toml` | editor |
| `home/ghostty/config.ghostty` | terminal stub |
| `home/ssh/config` | 1Password agent + hls1 hosts (included, not the main ssh_config) |
| `scripts/install-extras.sh` | Tinycast DMG, Cursor CLI, Codex |

Tinycast, Cursor CLI (`agent`), and Codex are installed by the `bootstrap` task. Already-present binaries are skipped. Tinycast is copied from the GitHub release DMG (mise does not install a `brew` CLI). Restore Tinycast settings from the app’s Backup & import, not from git.

This installs the Cursor **CLI**, not the Cursor desktop app.

CodexBar is the official Homebrew cask (`codexbar`), same app as `steipete/tap/codexbar`. Tailscale is `tailscale-app` (the GUI), not the CLI formula.

Elmedia Video Player is `mas:1044549675`. That needs the `mas` CLI (`brew:mas`) and an App Store sign-in on the machine.

SSH: `~/.ssh/config` stays yours (OrbStack include, extra hosts). Bootstrap appends `Include ~/.ssh/config.d/dotfiles` and links the shared 1Password + hls1 file. Keys and `known_hosts` are not in the repo.

macOS defaults (key repeat off, shortest delay until repeat, hidden files, Finder windows open to Home, Dock auto-hide/smaller/no recents, Spotlight on Option+Space, AirDrop on all interfaces, WebKit extras) are applied by `mise bootstrap`. `~/Library` is unhidden and Finder/Dock are restarted in the `post-defaults` hook. Set Tinycast itself to Command+Space.
