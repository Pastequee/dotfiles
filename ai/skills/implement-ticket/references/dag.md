# Plan and execute a DAG

A directed acyclic graph (DAG) is the executable plan for work with multiple
dependent assignments. Nodes describe bounded work or human decisions. A directed
edge from A to B means B requires A's accepted result before starting. Acyclic means
no node can depend on itself, directly or through other nodes.

## Define nodes and dependencies

Give every node a stable ID and a short goal. Record enough information to dispatch
and accept it without inventing requirements:

- Its kind: work or human gate.
- Its deliverable or decision, scope, and completion criterion.
- Its predecessor IDs and the input or decision each dependency supplies.
- Its assigned owner or intended agent capability and relative effort.
- Its current state and evidence once accepted.

Use concise prose, a table, or structured data as appropriate. These meanings are
required; the storage format is free. Keep detailed briefs beside their node or
behind a reference rather than crowding the diagram.

A work node may investigate, implement, review, integrate, or verify. Size it as
one coherent assignment whose result can be accepted independently. A node need
not correspond to one agent, file, or commit. Split work when different dependencies,
ownership, or acceptance criteria justify separate assignments.

Add an edge only for a real prerequisite. Independent branches can proceed in
parallel; a join requires every incoming dependency. Create an integration or
verification node where branches must be checked together. Connect the final
review gate to the evidence needed to judge the complete result.

Represent each chosen human approval as a gate node. Its completion criterion is
the user's explicit approval of the identified proposal revision. Ensure every
implementation node is downstream of the approval that authorizes it. The main
skill's gate rules determine when approval is required and when it must be renewed.

## Validate and show the plan

Before presenting or dispatching the graph, check that all predecessor IDs exist,
the graph is acyclic, and every required outcome leads to completion evidence.
Check that gates cover the work they authorize and joins cover combined behavior.
An isolated node is valid only if its result has an explained purpose.

If a cycle appears, resolve the circular requirement before dispatch. Separate a
contract decision from its consumers, split discovery from implementation, or
combine inseparable work into one assignment. Do not remove a real dependency
merely to make the graph acyclic.

Render the DAG in the HTML plan with recognizable node IDs, directed edges,
parallel branches, joins, and visually distinct human gates. Choose the visual
form freely. Keep labels short and expose node details nearby or on demand.
Provide a readable dependency list or equivalent explanation alongside the visual.

For example, an approved shared contract may release two independent implementers.
Their accepted results feed an integration check, whose accepted evidence releases
the final human review. Neither implementation's success alone clears the join.

## Dispatch and accept

Track work as pending, running, accepted, or blocked. A pending node is ready only
when every predecessor is accepted and its authorizing gates remain valid. Dispatch
ready work in topological order. Choose among ready nodes using available agents,
edit ownership, cost, and concurrency limits.

Accept a work node only after inspecting the evidence for its completion criterion.
If review is a separate successor node, the work node's acceptance releases that
review; it does not imply that the review passed. Downstream work that needs the
reviewed result must depend on the review node.

A failed check or unavailable prerequisite blocks that node and its descendants.
Independent authorized branches may continue unless the failure undermines their
assumptions. At a human gate, follow the main skill's stop rule. Resume affected
work only after the blocking condition is resolved.

## Amend and resume

Keep one authoritative graph with the execution record and render the report from
that state. Preserve stable IDs for unchanged nodes. Record meaningful additions,
removals, changed dependencies, and reasons without accumulating a transcript.

When evidence changes the plan, identify affected descendants before dispatching
more work. Reopen nodes whose inputs or acceptance evidence are no longer valid,
including previously accepted nodes. Keep unaffected evidence. Validate the revised
graph and apply the main skill's renewed-approval rule to material changes.

Model a fix and recheck as work within the node or as new forward nodes. A review
loop is a change to execution state or a new graph revision, never a backward edge
that creates a cycle. On resume, reconcile node evidence with the actual files,
commits, and approval revision before deciding which nodes are ready.
