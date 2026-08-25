# Scaffold a new project

Given `new <slug>` (kebab-case):

1. Determine the repo folder: default `modjo-services` unless the user says otherwise (backend-migration work also lives under `modjo-services`).
2. Create `~/modjo/modjo-vault/<repo>/projects/<slug>/` with `plans/` and `research/` subfolders.
3. Write `SPEC.md`, `CONTEXT.md`, and `DECISIONS.md` from the templates below. If the user provided spec material, draft the SPEC body from it; otherwise leave the section stubs.
4. Append to `~/modjo/modjo-vault/INDEX.md`: `- [<slug>](<repo>/projects/<slug>/SPEC.md) - draft - <one-line hook>`.
5. Confirm to the user with the folder path and what still needs filling in.

## SPEC.md template

```markdown
---
status: draft
repo: <repo>
linear: []
created: <today, YYYY-MM-DD>
---

# <Project title>

## Goal

## Scope

## Architecture

## Tickets

## Out of scope
```

`status` is one of `draft | active | done` and is the single source of truth for project status; `INDEX.md` mirrors it. `linear` holds bare ticket/project IDs.

## CONTEXT.md template

```markdown
# Context - <slug>

Current truth for implementing agents. Hard cap: 150 lines - compress or remove before exceeding.

## As-built architecture

## Drift from SPEC

## Gotchas

## Cross-PR contracts

## Pointers
```

## DECISIONS.md template

```markdown
# Decisions - <slug>

Append-only log. Entry format:

## YYYY-MM-DD - [ref] <Title>
**Type**: decision | drift | gotcha | contract
**What**: one-two sentences.
**Why**: the reason; for type=decision, include the rejected alternative.
**Affects**: paths/queues/PRs a future agent should connect this to.
```
