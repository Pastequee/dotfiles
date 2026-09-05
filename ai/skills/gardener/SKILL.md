---
name: gardener
description: Sweep the codebase for accumulated decay, report the weeds, prune the ones you pick.
disable-model-invocation: true
---

# The gardener

The gardener tends the codebase. It hunts **weeds**: the decay that accumulates because no single PR owns it. Dead code, duplication, rotting tests, stale suppressions, docs that stopped describing the code. It surveys first and **prunes** only on request.

Bug hunting belongs to `diagnosing-bugs`, redesigns to `improve-codebase-architecture`, branch-diff cleanup to `deslop`. When a survey trips over one of those, it records a single line under "Spotted while weeding" and carries on weeding.

Every prune is behaviour-preserving. If a change alters behaviour, it stops being gardening and becomes work the user has to choose.

## Scope

Whole repo by default.

`--changed-since <ref>` restricts every survey to the files in `git diff --name-only <ref>...HEAD`. Confirm the ref resolves with `git rev-parse` and the file list is non-empty, then write the list beside the survey card as `scope.txt` so the subagents read it rather than re-deriving it.

**Hotspots** decide presentation order, never coverage. Code that never changes still gets surveyed, it just sinks down the report.

## Process

### 1. Ground the survey

Do this once, in the main context, so eight subagents don't each rediscover it. Gather:

- Language(s), package manager, build/test/lint commands (read the manifest scripts, `Makefile`, CI config).
- Which analysis tools are already installed or runnable via the package manager (`knip`, `ts-prune`, `depcheck`, `deptry`, `vulture`, `cargo-udeps`, `jscpd`, `madge`, `dependency-cruiser`).
- Repo docs that carry authority: `CONTEXT.md`, `CLAUDE.md` / `AGENTS.md`, `docs/adr/`, `CONTRIBUTING.md`, coding standards.
- Hotspots: `git log --since=6.months --name-only --format= | sort | uniq -c | sort -rn | head -30`.
- Repo size markers: file count, test count, whether the test suite currently passes.

Write it to `<tmp>/gardener-<timestamp>/context.md`, resolving `<tmp>` from `$TMPDIR` (fall back to `/tmp`). This is the **survey card**. Every subagent reads it.

Completion criterion: the card names the test command, the hotspot list, and the tool availability verdict for each tool above. A subagent should never have to guess how to run the tests.

### 2. Dispatch the swarm

Send every applicable survey in one message so they run in parallel. Each one: `subagent_type: "Explore"` (read-only by construction), `model: "opus"`.

Prompt template, with `<skill-dir>` expanded to the absolute base directory given to you when this skill loaded:

> You are running the **<name>** survey for the gardener. Read `<skill-dir>/SURVEY-BRIEF.md`, then `<skill-dir>/surveys/<name>.md`, and follow both. Repo root: `<cwd>`. Survey card: `<card-path>`. Scope: <whole repo | the files listed in `<tmp>/gardener-<timestamp>/scope.txt`>.

| Survey | Hunts |
|---|---|
| `dead-growth` | unused exports, orphan files, unused and ghost dependencies, commented-out code, dead flag branches |
| `duplication` | copy-paste, near-duplicate helpers, half-finished parallel implementations |
| `tests` | skipped and assertion-free tests, flakiness, orphaned fixtures, tests for code that's gone |
| `suppressions` | lint and type suppressions, especially stale ones whose warning no longer fires |
| `drift` | docs, comments, ADRs and agent instruction files that no longer match the code |
| `dependencies` | outdated, duplicated, deprecated deps, lockfile drift |
| `naming` | names that lie, vocabulary drift against `CONTEXT.md`, leftover `v2`/`Legacy`/`Temp` |
| `overgrowth` | oversized files, circular deps, TODO age, churn-vs-health hotspots (report only) |

Run a survey even when you expect it to come back empty. An empty survey with the command output behind it is a finding: it tells the user that area is clean.

### 3. Aggregate

Write the merged report to `<tmp>/gardener-<timestamp>/report.md` and print it. Structure:

```
## Summary
<n> weeds across <n> themes. Recommended first: <three themes, why>.

## <Theme>
### <path:line> <one line naming the weed>
Evidence: <the command or the reference count>
Prune: now | next time you're in there | leave
Effort: <files touched, lines removed> · Blast radius: <what depends on this>

## Dismissed
<merged from all surveys, one line each>

## Spotted while weeding
<bugs, redesign friction, anything out of scope. One line each, no follow-up>
```

Themes are ordered by how much they overlap the hotspot list. Each weed appears once, under the survey that found it. When two surveys land on the same file, keep the weed where it fits best and mark it `corroborated by <other survey>`, which is a confidence signal worth surfacing.

An empty report is not the goal. The goal is a decision the user can make in one pass, which is why every weed carries a `Prune:` verdict including the option to leave it.

### 4. Prune on request

Only when the user names themes. Then:

1. Run the test suite. A red suite before pruning means you report that and stop.
2. Work one theme at a time, one branch and one commit per theme.
3. Before deleting any symbol, prove it's dead: `git log -S'<symbol>'` for its history, and `rg` for dynamic references (string-keyed lookup, dynamic import, reflection, template interpolation, config files, CI). Without proof, downgrade the weed to `leave` and say why in the report.
4. Re-run the test suite after each theme. Report the output.

Themes that turn out to be bigger than a commit get raised with the user rather than half-pruned.
