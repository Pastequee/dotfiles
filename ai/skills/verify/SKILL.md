---
name: verify
description: Check a piece of work by climbing cost-ordered tiers, cheapest deterministic checks first, with the checking kept independent of the writing. Use before declaring work done, at a checkpoint inside a longer run, or when asked to verify, check, or validate a change.
---

# Verify

A ladder, climbed in order. Each tier is more expensive than the one below it, so the cheap tiers exist to reject work before the expensive ones spend anything on it.

Climb from tier 1 every time. A failure at any tier ends the climb: fix the work, then start again at tier 1, because the fix can break what tier 1 already passed.

## Tier 1: deterministic

Run the real commands and read their real output: build, typecheck, lint, and the tests that cover this change. Confirm the artifact exists and contains what it should.

Use the project's own scripts rather than raw tooling. This tier costs nothing and is never skipped, including when time is short.

## Tier 2: read

Read the diff against what was asked for. Report three things:

- what the ask required and the diff misses or half-does
- what the diff adds that nobody asked for
- what looks implemented but is wrong

Quote the line of the ask for each finding.

## Tier 3: judgement

Only for work that passed tiers 1 and 2. Quality, design, and fit questions a command cannot answer. Skip this tier when the work is small and mechanical.

## Independence

The producer never grades its own homework. When an agent wrote the work, tiers 2 and 3 run in a fresh subagent that gets the diff and the ask, and not the writing agent's account of what it did. Judge the artifact, never the summary.

## Retry bound

Two failed climbs on the same work is the limit. On the third, stop and escalate to the human with the failing output. Repeated failure at the same tier usually means the plan is wrong, not the code.

## Reporting

State which tiers ran and paste the output that proves it. When a tier was skipped, say which and why, in the report rather than in silence.
