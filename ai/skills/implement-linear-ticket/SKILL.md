---
name: implement-linear-ticket
description: Safe, adaptive process for implementing a Linear ticket end to end. Use when the user asks to implement, work on, or pick up a Linear ticket/issue (e.g. "implement BE-123", "take the next ticket", a Linear URL). The main agent orchestrates and delegates; effort scales with ticket complexity.
disable-model-invocation: true
---

# Implement a Linear ticket

You are the **orchestrator**. Your job is to sequence the work, keep context
lean, and make the calls a tech lead would make. Delegate every heavy task —
codebase exploration, external research, plan drafting, implementation,
review — to subagents of your choosing (agent, model and reasonning level). Do not
read large swaths of code or write feature code yourself; read only what you
need to direct and verify the work.

## Calibrate before you start

After fetching the ticket, explicitly size it. This decides how much of the
process below you run — the goal is proportional rigor, not maximal process.

Signals the ticket is HIGH-STAKES (add safeguards):
- data model or migration changes, queue/infra changes, cutover steps
- touches more than one repo or service, or a shared library
- external provider APIs, auth flows, or anything customer-visible
- vague or contradictory acceptance criteria
- irreversible or hard-to-roll-back actions

Signals the ticket is SIMPLE (compress the process):
- single file or module, clear acceptance criteria, established pattern to
  copy (the ticket often names it)
- no schema, infra, or public-interface changes

For a simple ticket: fetch, one quick research pass, a 5-line plan for the
user, implement, recap. Do not spawn a plan-review agent, do not write a
design doc, do not add tests beyond what the repo's standards require.

For a high-stakes ticket: run every step below, and invent the extra
safeguards the risk calls for — e.g. TDD, a staging verification step, a
feature flag, splitting into stacked MRs, an adversarial review of the plan,
a rollback note in the recap. Think about what could go wrong and add the
step that catches it.

## Process

### 1. Fetch the ticket

Get the full ticket from Linear (description, comments, parent project,
blocked-by relations). Read linked docs/MRs. If the ticket is blocked by
unfinished work or the description contradicts the project doc, stop and
surface that to the user before doing anything else.

The ticket description is the source of truth for WHAT to build. A ticket is
expected to be almost self-contained: scope, the big lines of the approach,
and its constraints all live in the description — only implementation
details are yours to work out. If the description doesn't carry that (you
can't tell what "done" means, or you'd have to guess the intended approach),
do not reverse-engineer intent from the codebase or fill the gaps silently:
list the missing pieces to the user and propose a description update before
any research or planning. Research (step 2) exists to fill in the HOW, never
the WHAT.

### 2. Research

Delegate in parallel, scoped to what the ticket actually needs:
- **In-repo**: an Explore agent to map the files, patterns, and conventions
  the change must fit into (find the "pattern-match target" — the existing
  code this change should look like).
- **Cross-repo**: if the ticket touches or mirrors another codebase, a second
  Explore agent there.
- **External**: a research agent for third-party API/docs facts when the
  ticket depends on provider behavior. Require citations; never trust memory
  for API details.

Skip any lane that has nothing to find. Collect only conclusions, not file
dumps.

### 3. Plan

Have a Plan agent draft the implementation plan from the ticket + research:
ordered steps, files to touch, test strategy, and how to verify. The plan's
size must match the calibration — a paragraph for simple tickets, a full
document for high-stakes ones.

**The bar for the plan is: if the user approves it, the implementation that
follows can be trusted, because every decision that could go wrong was
already made and reviewed here.** A high-level overview does not clear that
bar. So for anything above a simple ticket, the plan must state, for each
important part of the change:

- the decision taken, and the alternatives rejected with the reason
- the concrete shapes involved: schema/migration details, type and interface
  signatures, event/message payloads, API contracts, config and flags
- where the code goes and which existing pattern it mirrors (name the file)
- edge cases, failure modes, and what happens on retry/partial failure
- test strategy: what is tested at which layer, and what is deliberately not
- migration/rollout/rollback specifics when they apply

It is not a step-by-step transcript of the edits — leave mechanical coding
to the implementer. The rule of thumb: anything the implementer would
otherwise have to *decide* belongs in the plan; anything they merely have to
*type* does not. If the plan comes back as a list of vague steps ("update
the repository", "add tests"), send it back for another pass rather than
presenting it.

### 4. User review of the plan (gate)

Present the plan to the user and wait for approval. This gate is never
skipped — only its weight varies. For high-stakes tickets, additionally
spawn an independent agent to review the plan **against the ticket** before
the user sees it: does the plan satisfy every acceptance criterion, does it
miss an edge case, does it overbuild, and — critically — is any important
decision still left implicit? Fold its findings into the plan you present.

Present the plan in full. Do not summarize it down to bullet headlines: the
user is reviewing the reasoning and the decisions, not a table of contents.

### 5. Implement

Delegate implementation to a coding subagent (or several, one per
independent piece — use worktree isolation if they edit in parallel). Give
each agent the approved plan section, the conventions found in research, and
the definition of done. Follow the repo's own workflow (branch naming, TDD
preference, lint/typecheck/test commands). You verify: run the tests and
checks yourself or via an agent, and read the diff at the level a reviewer
would. If implementation reveals the plan was wrong, stop, update the plan,
and re-gate with the user if the change is material.

### 6. Recap and user review (gate)

Report back with: what changed (files, behavior), how it was verified (test
output, staging checks), what deviated from the plan and why, and anything
left open. Ask the user to review. Only after their sign-off: update the
Linear ticket status/comment if asked, and open the MR following the repo's
title conventions.

## Rules

- Never start implementing before the plan gate; never close the ticket
  before the recap gate.
- Escalate, don't improvise: if research contradicts the ticket, if scope
  grows, or if a step needs credentials/permissions you lack, ask the user.
- Report honestly: failing tests, skipped steps, and shortcuts go in the
  recap, not under the rug.
- Keep your own context clean: subagents return conclusions; you hold the
  ticket, the plan, and the decisions.
