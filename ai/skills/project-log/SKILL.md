---
name: project-log
description: Write durable knowledge back to the Modjo vault's project memory. Invoke when finishing a body of implementation work on a loaded vault project - about to create an MR, or wrapping up the session's work on it.
---

# Project log (vault write-back)

Only the main agent writes to the vault: subagent reports are candidate learnings to filter, never direct writes.

1. Identify the loaded project's folder in `~/modjo/modjo-vault` (from the `/project` load earlier in the session). If none is loaded, ask the user which project this belongs to.
2. Collect candidate learnings from the whole session: your own work and anything subagents reported.
3. Filter with the rubric. An entry earns its place only when a future agent working another PR of this project would pay tokens to know it and cannot get it from git, Linear, or the code. Exactly four types qualify:
   - **decision**: a technical choice where a plausible alternative was rejected - record the why and the rejected alternative.
   - **drift**: a divergence from `SPEC.md` - what changed and why.
   - **gotcha**: a landmine future PRs will hit - a weird constraint, footgun, or non-obvious coupling.
   - **contract**: an interface, queue, event, or schema another PR in this project depends on.
   Git already records what the PR did; Linear already records progress - so diffs summaries, test results, and progress narration stay out.
4. Append each surviving entry to `DECISIONS.md` in its entry format (defined at the top of that file).
5. Update `CONTEXT.md` only where an entry changes current truth (new as-built reality, new drift, new gotcha or contract in force). Hard cap: 150 lines - when an update would exceed it, compress or remove something in the same pass.
6. Knowledge that is repo-wide rather than project-bound (infra quirks, how a subsystem actually works) goes to `<repo>/notes/<topic>.md` instead.
7. If the project's status changed, update `status` in `SPEC.md` frontmatter and mirror it on the project's `INDEX.md` line.
8. Tell the user what was written (entry titles) - or that nothing met the bar, which is a valid outcome.
