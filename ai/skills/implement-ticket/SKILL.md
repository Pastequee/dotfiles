---
name: implement-ticket
description: Implement a ticket through adaptive delegation, human review gates, and verified commits.
disable-model-invocation: true
---

# Implement ticket

Act as the orchestrator. Keep scope, workflow selection, agent assignments, review
decisions, and acceptance in your context. Delegate substantial investigation,
drafting, implementation, and verification to appropriately capable agents.
Optimize total cost to a verified result, including coordination and rework.

The user chooses the ticket source at invocation. Accept the supplied reference,
file, or description through the access available in the session. Keep this
workflow independent of any ticket platform or integration.

## 1. Establish scope and choose the workflow

Read the ticket and relevant context. Establish the target repository, intended
behavior, constraints, and acceptance criteria. Inspect repository instructions
and the working tree before assigning edits. Preserve unrelated work.

Resolve factual gaps through investigation. Ask the user about missing intent or
conflicting requirements that would change the result. Discovery and disposable
experiments may precede approval; production implementation waits for its gate.

Assess uncertainty and complexity separately from blast radius and reversibility.
Consider affected boundaries, shared contracts, data, permissions, failure recovery,
and confidence in verification. File count alone does not determine the workflow.

Choose the lightest workflow that addresses the actual risks. These examples are
starting points, not fixed tiers or exhaustive criteria:

| Evidence | Starting workflow |
| --- | --- |
| Clear behavior, established solution, isolated and reversible change | Brief approach in chat, approval, bounded implementation, focused verification and review |
| Several decisions or affected boundaries | Investigation, combined HTML spec and plan, independent preparation review, approval, delegated implementation and integration checks |
| Unclear behavior, difficult architecture, or consequential failure | Investigation, independently reviewed HTML spec and approval, independently reviewed HTML plan and approval, staged implementation with targeted adversarial reviews |

State the chosen workflow, why it fits, and where the user will decide. Add or
remove steps as evidence changes. Resolve a narrow uncertainty with a targeted
investigation rather than expanding every part of the process.

This step is complete when scope is understood well enough to prepare the next
decision, and remaining questions have an owner and a way to resolve them.

## 2. Prepare the decisions

Before delegating, read [delegation.md](references/delegation.md). Use it for agent
selection, bounded assignments, context handoffs, and concurrent work.

Specify what behavior must change before planning how to change it. Reuse a sound
existing spec or plan and resolve its gaps rather than recreating it. Separate
spec and plan approvals when behavior needs agreement before technical planning.
Combine them when the decisions can reasonably be reviewed together.

When producing a spec or plan report, use HTML and read
[reports.md](references/reports.md). Let the decision determine the composition
and supporting assets. The small-work chat approach needs no formal report.

For review assignments, read [reviews.md](references/reviews.md). Increase the
independence, depth, and variety of spec, plan, and code reviews as uncertainty or
consequences grow. Review preparation before presenting it to the user. Resolve
findings or expose the remaining decision explicitly.

For work with multiple dependent assignments, make the plan a directed acyclic
graph (DAG). Nodes are bounded work or human decisions; an edge means the successor
requires the predecessor's accepted result. Read [dag.md](references/dag.md) to
define, validate, visualize, and execute the graph. Small linear work can use a
sequence in chat with the same dependency and approval rules.

Make material decisions and verification obligations concrete while leaving
routine implementation choices to the worker.

Preparation is complete when the user can judge the proposed behavior and approach,
and an implementer can start without inventing a material requirement.

## 3. Stop for human approval

At each chosen gate, link the report or present the brief approach. State the
decision, your recommendation, and unresolved tradeoffs. Ask one focused approval
question and stop dependent work until the user answers. Silence is not approval.

Record what the user approved and which revision it covers. Resume within that
scope without repeated permission requests. A material change to behavior, scope,
architecture, risk, or verification promises requires an updated proposal and
renewed approval before affected implementation continues. Routine choices and
dependency scheduling changes remain yours to make.

## 4. Implement, verify, and commit

After approval, dispatch ready DAG nodes using the execution rules in
[dag.md](references/dag.md). Readiness requires accepted dependencies and cleared
human gates. Coordinate concurrent edits using the delegation guidance. Verify
combined behavior at integration joins before releasing their successors.

Use the repository's checks and testing conventions. Match tests to acceptance
criteria and credible failure modes. For bug fixes, reproduce the defect and
demonstrate the correction when feasible. Report unavailable checks as unverified.

Review the integrated change against the ticket and approved decisions. Resolve
findings using the review guidance. A worker's completion claim is evidence to
inspect, not acceptance by itself.

Make commits at coherent, verified milestones using repository conventions. The
orchestrator owns staging and commits in a shared checkout. Commit only the
ticket's changes and keep unrelated edits out. Publishing commits requires session
authorization; making commits alone does not authorize a push.

Maintain a compact local execution record for work that spans assignments or
gates. Track the ticket source, current report revision, DAG state, approvals, assignments,
commits, verification evidence, unresolved findings, and next step. Use an existing
artifact location when available. Keep reports and state outside tracked product
files unless the repository or user calls for them there.

On resume, reconcile that record with the working tree and commits before
dispatching more work. Repeat checks only when changes or uncertainty justify it.

Implementation is complete when each acceptance criterion has evidence, the
integrated result passes applicable checks, and material findings are resolved.
If a blocker prevents completion, report the precise gap rather than claiming done.

## 5. Return the result for review

Summarize behavior changes, verification and its limits, commits, deviations from
approved decisions, and anything still open. Ask whether the result meets the
user's intent, then wait for their review.

The workflow ends with verified commits and the user's review. Do not prepare or
create a merge request or pull request. That is a separate task only if the user
explicitly requests it at the end. Final acceptance does not imply that request,
ticket updates, or deployment.
