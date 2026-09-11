# Review decisions and implementation

## Choose the question before the reviewer

Give each review a specific risk or decision to challenge. Use independent agents
for substantial work. For small work, a focused review may suffice. Consequential
decisions deserve reviewers capable of challenging the author, including peers of
the orchestrator when needed.

Select perspectives that can change the outcome. Possible assignments include:

- Challenge the spec against the original request. Identify missing behavior,
  contradictions, or acceptance criteria that cannot be verified.
- Argue for the smallest sufficient implementation. Name proposed mechanisms,
  abstractions, or compatibility layers that can be removed, with a viable alternative.
- Try to break the design through concrete inputs, ordering, concurrency, partial
  failure, or recovery. Show the sequence that causes the failure.
- Examine whether a boundary hides complexity or spreads it across callers.
  Identify likely future changes that the proposed design makes harder.
- Challenge the tests. Identify promised behavior that can remain broken while
  the checks pass, or assertions that merely repeat the implementation.

Add domain-specific perspectives when the change warrants them. The list is
non-exhaustive; avoid assigning every perspective to every ticket.

## Preserve independence and adjudicate

Give reviewers the ticket, constraints, relevant artifacts, and their review
question. Let them form initial conclusions before showing other reviewers'
opinions. Ask them to challenge assumptions forcefully and return concrete evidence.
Allow a reviewer to find no issue.

Each actionable finding identifies its location or decision, a plausible failure
or maintenance cost, and the smallest reasonable correction. Separate material
defects from optional improvements. Reject cosmetic churn presented as correctness.

The orchestrator checks each finding against the evidence and approved scope.
Accept, reject with a reason, or investigate it. Resolve disagreements through
targeted evidence rather than majority vote. Bring unresolved product tradeoffs to
the user at the appropriate gate.

## Close the loop

After a fix, rerun relevant checks and review the affected finding. Broaden the
review when the fix changes another boundary or reveals a new risk. Increase
review depth and independent perspectives as complexity or blast radius demands,
without requiring a fixed number of rounds.

Stop when material findings are resolved and acceptance evidence is adequate.
If reviews repeat without new evidence, narrow the disputed question, obtain a
stronger reviewer or decisive check, or surface the blocker. Additional rounds
must answer an unresolved question.
