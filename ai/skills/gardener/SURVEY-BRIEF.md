# Survey brief

Shared contract for every gardener survey. Read this, then your own survey file.

## Your job

Find **weeds** in your assigned area: decay that makes the codebase heavier without making it do more. You report. You change nothing.

Read the survey card first. It has the test command, the hotspot list, and which analysis tools are available, so you never have to guess.

## Evidence

Every weed carries evidence a human can re-run in one command. A `path:line` and the command or reference count that found it. A weed you can't back that way is a hunch: put it in Dismissed with the reason, or drop it.

Prefer a tool to your own reading when a tool exists. Grep and read to confirm what the tool claims, because static analysis is blind to reflection, dynamic imports, string-keyed lookups, annotation processors and config-driven wiring. A tool hit you haven't confirmed is not a weed yet.

## Judgement

- Code that works, is tested, and nobody has touched in two years is not a weed. Weight your attention toward the hotspots on the survey card.
- Behaviour-preserving or it isn't yours. Anything that changes what the program does goes to "out of scope" with one line.
- Bugs, redesign opportunities and performance problems all go to "out of scope" with one line each. Somebody else's job.
- The repo's own documented standards beat your defaults. When `CONTEXT.md`, `CLAUDE.md` or a coding standards file endorses something you'd flag, it isn't a weed.

## Output

Under 500 words. Three sections, always all three:

```
## Weeds
### <path:line> <one line naming it>
Evidence: <re-runnable command, or the reference count>
Prune: now | next time you're in there | leave
Effort: <files touched, lines removed> · Blast radius: <what depends on it>

## Dismissed
<2 to 5 things that looked like weeds and aren't, one line each with the reason>

## Out of scope
<bugs, redesigns, perf. One line each. Empty is fine>
```

The Dismissed section is mandatory and it is what makes the survey trustworthy. A survey that flags everything it sees has told the user nothing about what's healthy. If you genuinely dismissed nothing, say so and explain what you looked at.

Rank weeds within your section: hotspot overlap first, then size of the win.
