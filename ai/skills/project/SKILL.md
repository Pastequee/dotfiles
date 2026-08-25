---
name: project
description: Load a Modjo project's knowledge from the vault (or scaffold / deep-clean one)
disable-model-invocation: true
argument-hint: <slug> | new <slug> | sync <slug>
---

# Project knowledge (Modjo vault)

Vault root: `~/modjo/modjo-vault`. A project lives at `<repo>/projects/<slug>/`.

Route on the argument:

- `new <slug>`: read [NEW.md](NEW.md) and follow it.
- `sync <slug>`: read [SYNC.md](SYNC.md) and follow it.
- `<slug>` alone: load the project, below.

## Load

1. Locate the project folder: glob `~/modjo/modjo-vault/*/projects/<slug>`. If nothing matches, read the vault's `INDEX.md` and fuzzy-match the slug; if still ambiguous, ask the user.
2. Read the project's `CONTEXT.md` and `SPEC.md` in full.
3. If the task at hand references a plan or research doc, read it from `plans/` or `research/`; leave the rest on disk.
4. Confirm to the user in one line which project is loaded and its status.

Loaded means: both files read, and the rules below active for the rest of the session.

## While a project is loaded

- Save every spec, plan, or research markdown you produce into the project folder (`plans/YYYY-MM-DD-<topic>.md`, `research/`), never into the repo. Plans are immutable once their MR merges; corrections go through the decision log.
- Linear IDs in `SPEC.md` are bare references: pull live ticket state via the Linear MCP when it matters.
- When you wrap up a body of implementation work (about to create an MR, or ending this session's work on the project), invoke the `project-log` skill.
