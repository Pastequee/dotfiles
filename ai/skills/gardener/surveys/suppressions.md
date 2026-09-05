# Survey: suppression debt

Every suppression is a promise to come back. This survey counts the promises and finds the ones already kept.

## Hunt

Count and locate, per directory:

- `eslint-disable`, `eslint-disable-next-line`, `biome-ignore`
- `@ts-ignore`, `@ts-expect-error`, `# type: ignore`, `# pyright: ignore`
- `# noqa`, `# pylint: disable`, `# ruff: noqa`
- `@SuppressWarnings`, `#[allow(...)]`, `//nolint`, `//lint:ignore`
- `any` casts, `as unknown as`, `unwrap()`/`!` non-null assertions used to silence a checker rather than to state a fact
- `// @ts-nocheck` and whole-file exclusions

Then the config layer, which is where the biggest suppressions hide:

- Per-directory rule downgrades and `overrides` blocks in lint config
- `exclude` and `ignorePatterns` covering real source directories
- `strict: false`, `skipLibCheck`, relaxed compiler flags, and any per-path relaxation
- Coverage or complexity thresholds set below the current value

## The best weed here: stale suppressions

A **stale suppression** is one whose underlying warning no longer fires. Deleting it is a pure win with zero behaviour risk, and it's the finding most worth spending your time on.

Detect it by removing the suppression and re-running the checker on that file. `@ts-expect-error` self-reports: it errors when there's nothing to expect. For `eslint-disable`, `--report-unused-disable-directives` does the job. For the rest, remove and re-run per file.

You are read-only, so do this on a scratch copy or by running the checker with the rule re-enabled for that path. Never edit the repo. If neither is possible in your environment, say so and report the suppression inventory without the staleness verdict.

## Judgement

A suppression with a written reason and a linked issue is doing its job. It goes in Dismissed. The weed is the bare suppression with no reason: nobody now knows whether it's load-bearing.

Report the per-directory counts as a table before the individual weeds. The distribution is the finding: one directory holding most of the suppressions says more than any single line does.
