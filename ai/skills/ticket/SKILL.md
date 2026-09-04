---
name: ticket
description: Implement a Linear ticket end to end as a reviewed DAG of verified units
disable-model-invocation: true
argument-hint: <ticket-id | linear-url>
---

# Ticket

You are the **orchestrator**. Sequence the work, hold the decisions, keep your own
context lean. Delegate every heavy task to subagents you pick the agent, model and
reasoning level for: codebase exploration, external research, plan drafting,
implementation, review. Read only what you need to direct and verify. Subagents
hand back conclusions, never file dumps.

Phases are separated by **gates**. A gate is a stop: you present, the user decides,
nothing past it starts until they answer. One question per gate.

## 1. Fetch the ticket

Linear reaches through the executor MCP. Search for the tool paths
(`tools.search({ namespace: "linear_app", query: "issue" })`) rather than guessing
them, then pull the description, comments, parent project, and blocked-by
relations. Read the linked docs and MRs.

The description is the source of truth for WHAT to build: scope, the shape of the
approach, the constraints. Only the HOW is yours to work out. Two stop conditions,
both of which fire before any research:

- **Blocked or contradicted.** The ticket depends on unfinished work, or the
  description disagrees with the project doc. Surface it and wait.
- **Underspecified.** You cannot tell what done means, or you would have to guess
  the intended approach. List the gaps and run `grilling` on them, then propose a
  description update. Research fills in the HOW and never the WHAT, so do not
  reverse-engineer intent from the codebase.

If the repo has vault knowledge for this project, load it with `project`.

## 2. Calibrate

Size the ticket into a **tier** and state which one you picked and why. The tier
decides how much of the rest you run. Proportional rigor is the goal.

| Tier | Signals | What runs |
| --- | --- | --- |
| **small** | one file or module, clear acceptance criteria, an established pattern the ticket usually names, no schema or infra or public-interface change | Phase 3 as a single pass, a five-line plan in chat instead of a DAG, phase 6, phase 8. Skip the plan file. |
| **standard** | several files or one module boundary, some decisions left open, no irreversible step | every phase, one node per coherent unit of work |
| **high-stakes** | data model or migration, queue or infra change, cutover, more than one repo or service, a shared library, external provider APIs, auth, anything customer-visible, vague or contradictory criteria, hard to roll back | every phase, plus an adversarial plan review before gate 2, plus the safeguards the specific risk calls for |

At the high-stakes tier, invent the extra safeguard the risk deserves rather than
working the list above: a feature flag, a staging verification node, stacked MRs, a
rollback note in the recap. Ask what could go wrong here and add the step that
catches it.

## 3. Recon

Delegate in parallel, and skip any lane with nothing to find:

- **In-repo**: an Explore agent maps the files, patterns, and conventions the change
  must fit. Its main job is naming the **pattern target**, the existing file this
  change should end up looking like.
- **Cross-repo**: a second Explore agent when the ticket touches or mirrors another
  codebase.
- **External**: a research agent for third-party API and provider behaviour, with
  citations required. Memory is not a source for API details.

## 4. Shape the DAG

Break the work into nodes and edges, and write the plan file. Read
[`DAG.md`](DAG.md) for the node fields, the file format, the mermaid render, and the
amendment protocol.

## Gate 1: topology

Present the mermaid render and the one-line goal of each node. Ask one question: is
this the right decomposition? A wrong shape caught here costs one message, and
caught after the plan is written costs the whole plan.

## 5. Deepen each node

For every node above trivial, fill in its decisions. The bar is: **if the user
approves this, the implementation can be trusted, because every decision that could
go wrong was already made and reviewed here.** A high-level overview does not clear
that bar. So each node states:

- the decision taken, and the alternatives rejected with the reason
- the concrete shapes: schema and migration details, type and interface signatures,
  event and message payloads, API contracts, config and flags
- which existing pattern it mirrors, named by file path
- edge cases, failure modes, and the behaviour on retry or partial failure
- what is tested at which layer, and what is deliberately left untested
- migration, rollout, and rollback specifics where they apply

Anything the implementer would otherwise have to *decide* belongs here. Anything
they merely have to *type* does not, so leave the mechanical coding out. When a
node comes back as vague steps ("update the repository", "add tests"), send it back
for another pass instead of presenting it.

At the high-stakes tier, spawn an independent agent to review the plan against the
ticket before the user sees it: does it satisfy every acceptance criterion, does it
miss an edge case, does it overbuild, and is any important decision still left
implicit? Fold the findings in.

## Gate 2: plan

Present the plan in full. The user is reviewing reasoning and decisions, so do not
compress it to bullet headlines.

## 6. Execute

Walk the DAG in topological order, running independent nodes in parallel with
worktree isolation when agents edit at the same time. Each implementing agent gets
its node's section of the plan, the conventions from recon, and its `check` command.

Every node is one `tdd` cycle and ends on a commit at a green state, following the
repo's branch naming and commit conventions.

## 7. Feedback loops

Three loops, each with its own owner and its own exit:

- **Inner**, inside a node: red to green to refactor. Owned by `tdd`.
- **Middle**, around a node: `verify` fails, the node is fixed, the ladder is
  climbed again. Bounded at two failed climbs, then escalate rather than thrash.
- **Outer**, around the DAG: implementation proves a node's plan wrong. Amend the
  plan file per [`DAG.md`](DAG.md). Re-gate with the user only when the topology
  changed or a reviewed decision was reversed. Everything smaller is an amendment
  logged in the file, not a new gate.

Run `verify` on each node as it lands, and mark the node done in the plan file only
once it passes. At merge points and once at the end, run `code-review` against the
merge-base. Suggest the user run `/blast-radius` on any node marked risky.

## Gate 3: recap

Report: what changed by file and behaviour, how it was verified with the real
output pasted in, what deviated from the plan and why, and what is still open. State
failing tests and shortcuts here rather than leaving them out.

After sign-off, and only after it: open the MR with `writing-prs`, update the Linear
ticket, and write durable learnings back with `project-log`.

## Rules

- Never implement before gate 2, never close the ticket before gate 3.
- Escalate rather than improvise. Research contradicting the ticket, growing scope,
  or a missing credential is a question for the user.
- The plan file is the durable state. Keep it current so a fresh session can resume
  from it alone.
