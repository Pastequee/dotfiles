# Survey: overgrowth

Report only. Everything here is too big to prune in a gardening pass, and the user needs to see it anyway.

Your output is a map of where the codebase is straining, not a list of edits. Resist proposing fixes: a restructuring proposal belongs to the `improve-codebase-architecture` skill, and offering one here just competes with it.

## Hunt

- Files and functions far past this repo's own norms. Compute the norm, don't import one: get the line-count distribution and report what sits beyond the top decile, with the median alongside so the number means something.
- Circular dependencies between modules. `madge --circular`, `dependency-cruiser`, or the language's equivalent.
- Deeply nested conditionals, and the maximum nesting depth per hotspot file.
- Functions with long parameter lists, and the same few parameters travelling together across many signatures.
- `TODO`, `FIXME`, `HACK`, `XXX`, with the age of each from `git blame`. Report the age distribution. A three-year-old TODO is a decision, not a task, and the useful move is usually deleting the comment.
- **Hotspots**: files with high churn crossed with the above signals. This is where refactoring returns the most, so it's the section the user will read first.

## Method

Churn from the survey card, crossed with size and complexity:

```
git log --since=12.months --format= --name-only | sort | uniq -c | sort -rn | head -40
```

Then for each of those files: line count, function count, max nesting, whether the `suppressions` and `tests` surveys would have anything to say about it. A file that is big, churning, and thinly tested is the single most useful thing you can put in this report.

Plain averages hide this. A repo can average fine while three files carry all the risk, so report the outliers and the shape, never a single score.

## Output shape

Lead with a table of the top hotspots: path, commits in 12 months, lines, tests covering it (yes/no/unknown). Then the individual signals.

Every entry gets `Prune: leave` with a note on what would have to be true to make it worth doing. That's honest: none of this is gardening work, and the value here is the map.
