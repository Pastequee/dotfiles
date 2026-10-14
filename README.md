# dotfiles

macOS machine setup with [mise](https://mise.jdx.dev/).

## New machine

Clone over HTTPS. There is no SSH key yet; 1Password (and its SSH agent) is installed by bootstrap.

```sh
xcode-select --install
curl -fsSL https://mise.run | sh
mkdir -p ~/src
git clone https://github.com/Pastequee/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
~/.local/bin/mise trust
~/.local/bin/mise install mas
~/.local/bin/mise bootstrap --dry-run
~/.local/bin/mise bootstrap --yes
cp home/git/local_config.example ~/.config/git/local_config
# edit name, email, optional 1Password signing
```

Then open a new terminal. Machine-only shell bits go in `~/.config/zsh/local.zsh`. Complete the 1Password steps below before switching this repository's remote to SSH (`git remote set-url origin git@github.com:Pastequee/dotfiles.git`).

## This machine (already cloned)

```sh
cd ~/src/dotfiles
curl -fsSL https://mise.run | sh
mise trust
mise install mas
mise bootstrap --dry-run
mise bootstrap
```

## Layout

| Path | Role |
| --- | --- |
| `mise.toml` | tools, apps, automatic updates, dotfile links |
| `home/zshrc` | entrypoint: mise, starship, fzf, history, zinit plugins |
| `home/zsh/plugins.zsh` | completions, fzf-tab, Deja, history search, syntax highlighting |
| `home/zsh/export.zsh` | env vars |
| `home/zsh/alias.zsh` | aliases |
| `home/zsh/functions.zsh` | shell functions |
| `home/git/` | shared git config (identity is local) |
| `home/starship.toml` | prompt |
| `home/helix/` | editor and language-server preferences |
| `home/ghostty/config.ghostty` | terminal |
| `home/ssh/config` | 1Password agent + hls1 hosts (included, not the main ssh_config) |
| `scripts/install-extras.sh` | zinit, Deja, zsh plugins, Tinycast DMG |
| `scripts/completions.sh` | atomic replacement of generated zsh completions |
| `scripts/setup-touch-id.sh` | persistent, idempotent Touch ID setup for sudo |
| `scripts/check.py`, `tests/` | repository validation and installer regression tests |
| `scripts/doctor.sh` | machine diagnostics |
| `.github/workflows/check.yml` | validation on macOS and Linux |

Bootstrap installs [zinit](https://github.com/zdharma-continuum/zinit) under `${XDG_DATA_HOME:-~/.local/share}/zinit/zinit.git` and [Deja](https://github.com/Giammarco-Ferranti/deja) via its official binary installer (without changing `.zshrc`). On first install, readable existing history is imported; a new machine without a history file skips import. Updates do not re-import history, which would inflate command frequencies. zinit manages zsh-completions, fzf-tab, zsh-history-substring-search, Deja's integration, and zsh-syntax-highlighting. Plugin checkouts and Deja's local database stay outside git.

Tab opens fuzzy completion with case-insensitive matching; `<` / `>` switch completion groups. Type part of a command and press ↑ / ↓ to search matching history. Deja suggests commands inline: → accepts a suggestion, Ctrl+→ accepts a word, and Ctrl+] cycles alternatives. fzf also provides Ctrl+R history search, Ctrl+T file selection, and Alt+C directory selection, with the configured reverse layout and Rosé Pine colors.

History lives at `${ZDOTDIR:-$HOME}/.zsh_history`, with one million entries and deduplication. `SHARE_HISTORY` writes commands immediately and shares them across shells; `INC_APPEND_HISTORY` is disabled because zsh recommends keeping those options mutually exclusive. Commands prefixed with a space remain excluded from history.

mise also installs zoxide and bat. `z dotfiles` jumps to a frequently visited directory; `zi` opens an interactive directory picker. Entering a directory path alone changes directory (`AUTO_CD`), and visits populate a directory stack without duplicates (`AUTO_PUSHD`, `PUSHD_IGNORE_DUPS`); inspect it with `dirs -v` and jump with `cd ~1`, `cd ~2`, etc. Interactive `#` comments are enabled.

Ctrl+T previews files with bat; Alt+C previews directory trees with eza. Ctrl+/ toggles the preview. Press Ctrl+X followed by Ctrl+E to edit the current command in Helix; saving and quitting returns it to the prompt for review. Deja's suggestion toggle is Ctrl+X followed by Ctrl+X, leaving the editor shortcut available.

Bootstrap generates completions for mise, gh, starship, zoxide, ripgrep, and bat under `${XDG_CACHE_HOME:-~/.cache}/zsh/generated-completions`, which is added to `fpath` before `compinit`. Run `mise run completions` after upgrading tools to refresh them. All generators must finish and produce valid, nonempty files before any existing completion is replaced; each replacement uses an atomic rename. This never runs during shell startup.

Cursor CLI (`agent`), Codex, 1Password CLI (`op`), and `mas` are managed as mise tools. Tinycast is installed by the `bootstrap` task, copied from the GitHub release DMG, and skipped if already present. Restore Tinycast settings from the app’s Backup & import, not from git.

This installs the Cursor **CLI**, not the Cursor desktop app. The `c` alias runs `agent`. Optional OpenCode and Bun global-package directories use `$HOME` and follow the existing PATH entries; mise manages Bun itself. Zsh keeps PATH entries unique, including additions made by `local.zsh`.

GUI apps use mise's native `brew-cask:` installer: it reads the cask metadata and installs vendor downloads directly, without installing or running Homebrew. CodexBar uses `codexbar`, the same app as `steipete/tap/codexbar`; Tailscale uses `tailscale-app` (the GUI). The `macos-app:` alternative requires manually maintained versions, URLs, and checksums and cannot discover updates, so casks remain for these apps.

Elmedia Video Player is `mas:1044549675`, and WireGuard is `mas:1451685025`. These need the mise-managed `mas` CLI and an App Store sign-in on the machine. Install `mas` before bootstrap, as shown above, because bootstrap applies packages before tools.

## Editor support

mise installs TypeScript 6 and its language server, Bash Language Server, Taplo, ShellCheck, and shfmt. TypeScript follows 6.x to match the language server's tsserver API. `home/helix/languages.toml` enables format-on-save for JavaScript/TypeScript (including JSX/TSX), TOML, and Bash. TypeScript and TOML use their servers' formatters; Bash uses shfmt with two-space indentation. ShellCheck supplies Bash diagnostics. Project `.helix/languages.toml` files can override these preferences and are not globally ignored.

The TypeScript language server prefers the project's TypeScript installation, then falls back to the mise-managed TypeScript. A small launcher in `home/helix/`, linked as `~/.local/bin/dotfiles-typescript-language-server`, connects the two isolated npm installs and resolves their current paths on each launch. Check discovery with `hx --health typescript`, `hx --health toml`, or `hx --health bash`. Python is also managed by mise; the repository checker requires Python 3.11 or newer for TOML parsing.

## SSH and Git signing

`~/.ssh/config` stays yours (OrbStack include, extra hosts). Bootstrap appends `Include ~/.ssh/config.d/dotfiles` and links the shared 1Password + hls1 file. It uses 1Password's native macOS socket under `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`; no `~/.1password` symlink is required.

After installing 1Password:

1. Sign in, then enable **Settings → Developer → Use the SSH Agent**. Enable starting at login and keeping the app in the menu bar if you want the agent available after restarts.
2. Import or create an SSH key in 1Password and register its public key with your Git host for authentication.
3. To sign commits, edit `~/.config/git/local_config`: set `user.signingkey` to that public key and uncomment the signing sections from the example. Register the public key with your Git host as a **signing key** too.
4. Run `ssh -T git@github.com` to verify GitHub authentication. GitHub's success greeting normally comes with exit status 1 because it provides no shell access.

See [1Password SSH setup](https://www.1password.dev/ssh/get-started) and [commit signing](https://www.1password.dev/ssh/git-commit-signing). Keys, `known_hosts`, Git identity, and local shell overrides stay outside git. Repository ignore rules protect their expected locations. Global Git ignores cover editor user state and Xcode build/user data while allowing project files, shared schemes, and `.helix` configuration.

## Checks and maintenance

Run these after bootstrap has installed the tools:

```sh
mise run check
mise run --skip-tools doctor
mise run completions
mise run --skip-tools update-extras --dry-run
mise run update-extras
```

`check` validates every tracked or unignored new TOML file, Python syntax, Bash/Zsh syntax, Bash formatting, ShellCheck results, and the correspondence between `home/` and `[dotfiles]`. Its regression tests use temporary fixtures and stub downloads; they never write to system PAM files or `/Applications`. CI runs the same checker on macOS and Linux, installing only Python, ShellCheck, shfmt, and jq (plus zsh on Linux), without applying bootstrap.

`doctor` reports mise diagnostics and bootstrap drift, missing editor commands, Helix health, the 1Password socket, and the update LaunchAgents' last exit codes. It exits nonzero when checks need attention. Use `--skip-tools` to keep mise itself from installing missing tools before diagnosis; the script disables automatic updates and installation for its own mise commands. It does not authenticate to external services or apply repairs.

`update-extras` refreshes the Deja binary, zinit, all zinit plugins, completions, and Tinycast. Its `--dry-run` describes the operations without fetching release metadata. Normal bootstrap still skips existing installs. Tinycast updates check the installed version and the release asset's SHA-256 digest; quit Tinycast before updating it. A replacement is staged beside the app, and a failed final rename restores the previous bundle. App settings stay in their existing location. Open a new terminal after updating shell integrations.

The tasks use `~/src/dotfiles` because the same mise config is linked globally. For a checkout elsewhere (as in CI), run `python3 /path/to/dotfiles/scripts/check.py` with the check tools on PATH.

## Touch ID and macOS preferences

Bootstrap's `post-defaults` hook enables Touch ID for sudo through `/etc/pam.d/sudo_local`. It preserves custom local PAM rules, skips writes when already enabled, and uses an atomic replacement owned by root. macOS retains this file across system updates. This requires a macOS version whose sudo configuration includes `sudo_local`, plus configured Touch ID hardware to use fingerprint authentication. It may prompt for your password during setup.

To run just this step, use `mise run touch-id` or the existing `fingerprint_setup` shell function. The script leaves `/etc/pam.d/sudo` unchanged; it does not remove entries left by an older manual setup.

Other macOS defaults (key repeat off, hidden files, Finder windows open to Home, Dock auto-hide/smaller/no recents, Spotlight on Option+Space, AirDrop on all interfaces, WebKit extras) are applied by `mise bootstrap`. `~/Library` is unhidden and Finder/Dock are restarted in the `post-defaults` hook. Set Tinycast itself to Command+Space.

## Automatic updates

Requires mise 2026.10.8 or newer, installed at `~/.local/bin/mise` by the official installer. [Global tool updates](https://mise.jdx.dev/dev-tools/#automatic-tool-updates) are enabled for all `[tools]` entries with `tool_update.global_auto = "1d"`; future tools inherit this setting. Node follows the requested `lts` release. Mise also checks for its own updates daily.

Bootstrap installs the built-in `mise-tool-update` user service, which checks hourly and upgrades installed tools when their daily interval is due. Per-project version requests remain separate. The `mise-package-update` LaunchAgent upgrades configured installed casks and App Store apps every 24 hours, with logs in `~/Library/Logs/mise-package-update{,.err}.log`. App Store updates may require authentication. These services start only when bootstrap is applied.

Deja, Tinycast, and zinit/plugin checkouts remain outside mise's automatic tool updates; use `mise run update-extras` for them. Generated completions remain a manual refresh with `mise run completions`. To preview managed updates, run `mise upgrade --dry-run` for tools or `mise bootstrap packages upgrade --dry-run` for apps.
