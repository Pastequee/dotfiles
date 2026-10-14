#!/usr/bin/env python3
"""Validate the checkout without sourcing configs or applying bootstrap."""

from pathlib import Path
import ast
import shutil
import subprocess
import sys
import tomllib


ROOT = Path(__file__).resolve().parent.parent


def main():
    failures = []

    def check(label, command):
        if shutil.which(command[0]) is None:
            failures.append(f"{label}: missing {command[0]}; run mise install")
            return
        result = subprocess.run(command, cwd=ROOT, check=False)
        if result.returncode:
            failures.append(label)
        else:
            print(f"OK: {label}", flush=True)

    result = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=ROOT, check=True, capture_output=True, text=True,
    )
    files = sorted({Path(p) for p in result.stdout.split("\0") if p})
    configs = {}
    for path in files:
        try:
            if path.suffix == ".toml":
                configs[path] = tomllib.loads((ROOT / path).read_text())
            elif path.suffix == ".py":
                ast.parse((ROOT / path).read_text(), filename=str(path))
        except (OSError, ValueError, SyntaxError) as error:
            failures.append(f"{path}: {error}")

    bash_files = [str(p) for p in files if p.suffix == ".sh"]
    zsh_files = [str(p) for p in files if p.suffix == ".zsh" or p == Path("home/zshrc")]
    for path in bash_files:
        check(f"Bash syntax: {path}", ["bash", "-n", path])
    for path in zsh_files:
        check(f"Zsh syntax: {path}", ["zsh", "-n", path])
    check("ShellCheck", ["shellcheck", *bash_files])
    check("Bash formatting", ["shfmt", "-d", "-i", "2", "-ci", *bash_files])

    covered = set()
    for destination, entry in configs.get(Path("mise.toml"), {}).get("dotfiles", {}).items():
        if "source" not in entry:
            continue
        source = ROOT / entry["source"]
        if not source.exists():
            failures.append(f"Missing source for {destination}: {entry['source']}")
        elif source.is_dir():
            covered.update(p.relative_to(ROOT) for p in source.rglob("*") if p.is_file())
        else:
            covered.add(source.relative_to(ROOT))
    for path in files:
        if path.parts[0] == "home" and not path.name.endswith(".example") and path not in covered:
            failures.append(f"No dotfiles declaration covers {path}")

    check("Installer regression tests", [sys.executable, "-B", "-m", "unittest", "discover", "-s", "tests"])
    if failures:
        print("\nChecks failed:", file=sys.stderr)
        for failure in failures:
            print(f"  - {failure}", file=sys.stderr)
        return 1
    print(f"\nAll checks passed ({len(configs)} TOML files; dotfile sources match declarations).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
