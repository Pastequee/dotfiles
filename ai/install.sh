#!/usr/bin/env bash
#
# Install AI configuration files

set -e

cd "$(dirname "$0")"
AI_DIR=$(pwd -P)

link_md () {
  local src=$1 target=$2

  # Remove existing symlink, but don't clobber a real file
  if [ -L "$target" ]; then
    rm "$target"
    echo "Removed existing symlink: $target"
  elif [ -f "$target" ]; then
    echo "Warning: $target exists and is not a symlink. Skipping."
    return
  fi

  ln -s "$src" "$target"
  echo "Linked $(basename "$src") to $target"
}

# CLAUDE.md is Claude Code's global memory: it must live in ~/.claude/
mkdir -p "$HOME/.claude"
link_md "$AI_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Other .md files are linked into the home directory
for md_file in *.md; do
  if [ -f "$md_file" ] && [ "$md_file" != "CLAUDE.md" ]; then
    link_md "$AI_DIR/$md_file" "$HOME/$md_file"
  fi
done

CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$CLAUDE_SKILLS_DIR"

for skill_dir in "$AI_DIR"/skills/*; do
  if [ -d "$skill_dir" ] && [ -f "$skill_dir/SKILL.md" ]; then
    skill_name=$(basename "$skill_dir")
    target="$CLAUDE_SKILLS_DIR/$skill_name"

    if [ -L "$target" ] || [ -e "$target" ]; then
      rm -rf "$target"
      echo "Removed existing skill link: $target"
    fi

    ln -s "$skill_dir" "$target"
    echo "Linked skill $skill_name to $target"
  fi
done

CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$CLAUDE_COMMANDS_DIR"

for cmd_file in "$AI_DIR"/commands/*.md; do
  if [ -f "$cmd_file" ]; then
    cmd_name=$(basename "$cmd_file")
    target="$CLAUDE_COMMANDS_DIR/$cmd_name"

    if [ -L "$target" ] || [ -e "$target" ]; then
      rm -rf "$target"
      echo "Removed existing command link: $target"
    fi

    ln -s "$cmd_file" "$target"
    echo "Linked command $cmd_name to $target"
  fi
done
