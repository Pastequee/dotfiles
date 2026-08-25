---
name: writing-prs
description: Write PR/MR titles and descriptions. Use when creating a pull request or merge request, drafting or improving a PR title or description, or preparing a change for review.
---

# Writing PRs

One insight drives everything here: **the diff already says what changed. The title exists for scanability; the description exists to say why, and to make review cheap.** When a rule and this insight conflict, follow the insight. Repo-specific conventions (templates, title formats in CLAUDE.md) take precedence over the defaults below.

## Title

A title is read in a list of 30 others, in a changelog, and in `git log` — optimize for scanability.

Format: `<type>(<scope>): <imperative summary>` (Conventional Commits).

- **Imperative mood**, present tense — it completes "This PR will _add refresh token rotation_."
- **Under ~70 chars**, no trailing period.
- **Outcome, not mechanic.** `fix(profile): avoid crash when user has no avatar` beats `fix: null check in UserCard` — say what changed for users, not what you typed.
- Ticket reference goes in the body or as a suffix (`... (PROJ-1234)`), and the summary carries the meaning on its own.
- Breaking changes get `!`: `feat(api)!: drop v1 endpoints`. Work-in-progress uses draft status.

Types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `chore`, `build`, `ci`.

**Changelog test** (completion criterion): read the title alone, out of context. If it tells a reader what changed and roughly why they'd care, it's done.

## Description

Answer these, in order — each section carries information the diff cannot:

1. **Why** — the problem, bug, user pain, or business need, with the ticket link. This is what's unrecoverable from code six months later.
2. **What** — the approach in 2-5 bullets. A file-by-file narration restates the diff; summarize the idea instead.
3. **How to verify** — concrete steps a reviewer can follow, plus which tests cover it.
4. **Risks & rollout** — migrations, feature flags, rollback plan, anything that can break prod. State "none" explicitly when true.
5. **Notes for reviewer** — where to look first ("start with `TokenService.ts`, the rest is mechanical renaming"), plus alternatives you rejected and why. This preempts "why didn't you just..." and cuts review time more than anything else.

Two force multipliers:

- **Screenshots / GIFs / before-after** for anything visual — mandatory for UI changes, or the reviewer must check out the branch just to see it.
- **Small PRs.** Under ~400 lines is where review quality holds up; a 2000-line PR with a beautiful description is still a bad PR. Split refactor, feature, and dep bumps into separate PRs.

Sections are optional per PR: fill the ones that apply, drop the rest. A typo fix needs one line of Why; forcing empty sections trains readers to ignore the template.

**Completion criterion**: a reviewer who reads only the title and the Why can decide whether to review now and where to start; every section present is filled, and every absent section was dropped deliberately.

For a full worked example (title + all five sections on a risky change), read [EXAMPLE.md](EXAMPLE.md) — reach for it when the change involves migrations, flags, or rollout.

## Template

```markdown
## Why
## What
## How to test
## Screenshots
## Risks & rollout
## Notes for reviewer
```
