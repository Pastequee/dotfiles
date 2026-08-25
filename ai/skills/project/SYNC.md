# Deep clean (sync)

Given `sync <slug>`: distill the decision log into current truth.

1. Locate the project folder (same lookup as load).
2. Read `SPEC.md`, `CONTEXT.md`, and `DECISIONS.md` in full.
3. Rebuild `CONTEXT.md` so it states only current truth: fold in decisions still in force, drop what is superseded or has become obvious from the code, and land under the 150-line cap. `DECISIONS.md` stays untouched - it is the history.
4. If the project's state changed, update `status` in `SPEC.md` frontmatter and mirror it on the project's `INDEX.md` line.
5. Report what was folded in and what was dropped.

Done means: every entry in `DECISIONS.md` is either reflected in `CONTEXT.md` or deliberately dropped, and `CONTEXT.md` is under 150 lines.
