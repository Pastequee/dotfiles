# arthurpigeon dotfiles

Your dotfiles are how you personalize your system. These are mine.

## Install

Run this:

```sh
git clone git@github.com:pastequee/dotfiles.git ~/dotfiles
cd ~/dotfiles
script/bootstrap
```

This will symlink the appropriate files in `~/dotfiles` to your home directory.
Everything is configured and tweaked within `~/dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane macOS
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## Layout

- **`script/bootstrap`** — one-time setup: generates `~/.gitconfig.local`,
  symlinks every `*.symlink` file into `$HOME` (with a leading dot), then
  installs dependencies.
- **`bin/dot`** — periodic maintenance: applies macOS defaults, updates
  Homebrew, and re-runs every topic's `install.sh`.
- **`<topic>/install.sh`** — installer for one topic (Homebrew packages,
  oh-my-zsh, AI CLIs, ...). Run all of them with `script/install`.
- **`<topic>/*.zsh`** — sourced automatically by `~/.zshrc`.

Machine-specific or secret shell config goes in `~/.zshrc.local`, which is
sourced last and never committed.
