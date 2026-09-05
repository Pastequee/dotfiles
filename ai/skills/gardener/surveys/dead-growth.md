# Survey: dead growth

The highest-payoff, lowest-risk weeds. Code and packages that ship, compile, pass tests, and do nothing.

Expect to find a lot. Research across 35 open-source Java projects put ~16% of methods as effectively dead, and a median 70% of JavaScript functions unused across 40k web pages. If you find nothing, suspect your tooling before you conclude the repo is clean.

## Hunt

- Exported symbols nothing imports.
- Files nothing reaches from an entry point.
- Declared dependencies nothing imports, and **ghost dependencies**: packages the code imports without declaring, surviving on a transitive install.
- Commented-out code blocks. Up to 20% of early-development commits carry them and they lose their context within weeks.
- Branches behind a flag or env var that is permanently on or off. Check the flag's actual value in every environment config before calling it.
- Unreachable code after returns, throws, and always-true or always-false conditions.
- Unused types, interfaces, enum members, constants.
- Abandoned one-off scripts, completed migration files, stray files at the repo root.
- Build output, coverage reports, `.DS_Store` and other generated artifacts committed by accident. Cross-check `.gitignore`.
- Empty directories and placeholder files.

## Tools

Check the survey card for what's installed. `knip` covers exports, files, dependencies and types in one pass for JS/TS. Otherwise: `ts-prune`, `depcheck`, `deptry`, `vulture`, `cargo-udeps`, `mvn dependency:analyze`, or the language's own dead-code lint.

Without a tool, fall back to `rg` for each exported symbol across the repo, and treat a single-hit result (the declaration itself) as a candidate.

## Confirm before you call it

Every candidate needs a second check, because the analysers are blind to dynamic reference:

```
rg -F '<symbol>'                 # anywhere, including strings and configs
git log -S'<symbol>' --oneline   # when it arrived and whether it ever had callers
```

Then look specifically for: dynamic `import()` and `require()` with computed paths, string-keyed registries and dispatch maps, reflection and decorators, framework file-convention routing (pages, routes, handlers discovered by path), CI and deploy scripts, and public API surface a consumer outside this repo imports.

Public API entry points in a published package are not weeds. Say so in Dismissed.
