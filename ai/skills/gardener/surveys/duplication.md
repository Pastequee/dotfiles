# Survey: duplication

Say everything once. This survey finds the places where the codebase says it two or three times.

The dominant source now is AI-assisted work: an agent needs a helper, doesn't find the existing one, and writes a second. The two copies then drift apart, which is the actual damage.

## Hunt

- The same helper implemented more than once under different names or directories. Search by behaviour, not by name: date formatting, retry wrappers, deep clone, slug generation, currency handling, validation of the same domain shape.
- Copy-pasted blocks, weighted toward files that change often. Two copies in a hotspot cost more than five copies in frozen code.
- Parallel implementations of one concept where a migration stalled: `oldClient` beside `client`, a v1 route beside v2, two ORM access patterns for the same table.
- The same magic value or string literal repeated instead of shared.
- Repeated `switch` or `if` cascades on the same type in several places, which is one concept spread across sites.
- Duplicated type definitions describing the same shape.
- Config duplicated between the app, the tests, and CI.

## Tools

`jscpd` for token-level clones in most languages. `rg` with a distinctive line from a suspected copy is often faster and finds the near-duplicates a clone detector misses.

For behavioural duplicates, list the exported functions in the shared/util/lib directories and read for overlap. That is where the second copy usually lands.

## Judgement

Duplication that has been stable for years and never needs to change together is not urgent. The test is: **would a change to one of these copies be wrong if the other didn't change too?** If yes, it's a weed regardless of age.

Two copies that look alike but encode genuinely different rules are not duplication, they are two rules that happen to agree today. Dismiss those explicitly, and say what would make them diverge.

Report the copies as a set, with one line per location and a note on which copy looks canonical.
