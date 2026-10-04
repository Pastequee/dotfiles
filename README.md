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
| `home/zshrc` | entrypoint: mise, starship, fzf, history, zinit plugins |
| `home/zsh/plugins.zsh` | completions, fzf-tab, Deja, history search, syntax highlighting |
| `home/zsh/export.zsh` | env vars |
| `home/zsh/alias.zsh` | aliases |
| `home/zsh/functions.zsh` | shell functions |
| `home/git/` | shared git config (identity is local) |
| `home/starship.toml` | prompt |
| `home/helix/config.toml` | editor |
| `home/ghostty/config.ghostty` | terminal stub |
| `home/ssh/config` | 1Password agent + hls1 hosts (included, not the main ssh_config) |
| `scripts/install-extras.sh` | zinit, Deja, zsh plugins, Tinycast DMG, Cursor CLI, Codex |

Bootstrap installs [zinit](https://github.com/zdharma-continuum/zinit) under `${XDG_DATA_HOME:-~/.local/share}/zinit/zinit.git` and [Deja](https://github.com/Giammarco-Ferranti/deja) via its official binary installer (without changing `.zshrc`), importing existing history on first install. zinit manages zsh-completions, fzf-tab, zsh-history-substring-search, Deja's integration, and zsh-syntax-highlighting. Plugin checkouts and Deja's local database stay outside git.

Tab opens fuzzy completion with case-insensitive matching; `<` / `>` switch completion groups. Type part of a command and press ↑ / ↓ to search matching history. Deja suggests commands inline: → accepts a suggestion, Ctrl+→ accepts a word, and Ctrl+] cycles alternatives. fzf also provides Ctrl+R history search, Ctrl+T file selection, and Alt+C directory selection, with the configured reverse layout and Rosé Pine colors.

History lives at `${ZDOTDIR:-$HOME}/.zsh_history`, with one million entries and deduplication. `SHARE_HISTORY` writes commands immediately and shares them across shells; `INC_APPEND_HISTORY` is disabled because zsh recommends keeping those options mutually exclusive. Commands prefixed with a space remain excluded from history.

mise also installs zoxide and bat. `z dotfiles` jumps to a frequently visited directory; `zi` opens an interactive directory picker. Entering a directory path alone changes directory (`AUTO_CD`), and visits populate a directory stack without duplicates (`AUTO_PUSHD`, `PUSHD_IGNORE_DUPS`); inspect it with `dirs -v` and jump with `cd ~1`, `cd ~2`, etc. Interactive `#` comments are enabled.

Ctrl+T previews files with bat; Alt+C previews directory trees with eza. Ctrl+/ toggles the preview. Press Ctrl+X followed by Ctrl+E to edit the current command in Helix; saving and quitting returns it to the prompt for review. Deja's suggestion toggle is Ctrl+X followed by Ctrl+X, leaving the editor shortcut available.

Bootstrap generates completions for mise, gh, starship, zoxide, ripgrep, and bat under `${XDG_CACHE_HOME:-~/.cache}/zsh/generated-completions`, which is added to `fpath` before `compinit`. Rerun `mise bootstrap --only tools,task` after upgrading tools to refresh them.

Tinycast, Cursor CLI (`agent`), and Codex are installed by the `bootstrap` task. Already-present binaries are skipped. Tinycast is copied from the GitHub release DMG (mise does not install a `brew` CLI). Restore Tinycast settings from the app’s Backup & import, not from git.

This installs the Cursor **CLI**, not the Cursor desktop app.

CodexBar is the official Homebrew cask (`codexbar`), same app as `steipete/tap/codexbar`. Tailscale is `tailscale-app` (the GUI), not the CLI formula.

Elmedia Video Player is `mas:1044549675`. That needs the `mas` CLI (`brew:mas`) and an App Store sign-in on the machine.

SSH: `~/.ssh/config` stays yours (OrbStack include, extra hosts). Bootstrap appends `Include ~/.ssh/config.d/dotfiles` and links the shared 1Password + hls1 file. Keys and `known_hosts` are not in the repo.

macOS defaults (key repeat off, hidden files, Finder windows open to Home, Dock auto-hide/smaller/no recents, Spotlight on Option+Space, AirDrop on all interfaces, WebKit extras) are applied by `mise bootstrap`. `~/Library` is unhidden and Finder/Dock are restarted in the `post-defaults` hook. Set Tinycast itself to Command+Space.
