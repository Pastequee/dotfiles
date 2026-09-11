# Delegate work

## Select capability per assignment

Use the least expensive available agent likely to complete the assignment
correctly. Choose model and reasoning effort explicitly when the runtime permits.
Use the runtime's available choices and known capabilities, without inventing
model names, prices, or controls. If selection is unavailable, delegate with the
available agents and state the limitation when it affects the proposed workflow.

Bounded searches, evidence collection, check execution, report rendering, and
mechanical edits often suit cheaper agents. Ambiguous diagnosis, architecture,
cross-boundary implementation, and consequential review may require an agent as
capable as the orchestrator. These are examples, not permanent role assignments.

Delegate substantial work by default. Keep a tiny task local when briefing and
verification would cost more than doing it. Keep the orchestrator focused on
decisions, integration, and acceptance instead of redoing each worker's task.

## Brief each agent

Give the agent enough context to act independently:

- The objective and a checkable completion condition.
- Relevant ticket requirements, approved decisions, and evidence locations.
- Read or edit scope, dependencies, and repository conventions that affect the task.
- The verification required and the form of the returned evidence.
- The boundary at which the agent must return a question or proposed scope change.

Send relevant excerpts and paths instead of the entire conversation by default.
Ask for conclusions, changed files or commits, executed checks and results, and
remaining uncertainty. Fetch detailed output only where it affects a decision.

Workers can propose extra work. The orchestrator controls reassignment, further
delegation, and scope so the agent tree stays within the intended cost and
concurrency limits.

## Coordinate execution

Parallelize independent questions and work with settled interfaces. For concurrent
edits, assign exclusive file ownership or isolated worktrees. Serialize edits that
share files, contracts, or repository state. In isolated worktrees, workers may
commit their slices; the orchestrator integrates and verifies the combined result.

Before increasing parallelism, account for integration and review cost. A graph
edge describes an actual dependency, not just a preferred ordering.

When an agent stalls or fails, identify whether the brief, missing evidence,
environment, or capability caused the problem. Improve the assignment or escalate
capability accordingly. Repeated attempts with no new evidence call for a changed
approach. Escalate unresolved decisions to the user when they affect approved scope
or prevent a trustworthy result.

Inspect evidence at acceptance boundaries and sample underlying artifacts where
claims matter. Reuse reliable findings rather than paying several agents to repeat
the same exploration.
