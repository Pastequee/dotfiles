# Survey: dependency and toolchain hygiene

What the repo depends on, and how far it has slipped from what it should depend on.

Unused packages are the `dead-growth` survey's job. This one is about the packages that *are* used.

## Hunt

- Outdated dependencies, ranked by distance behind current and whether the jump is major. `npm outdated`, `pnpm outdated`, `pip list --outdated`, `cargo outdated`, `bundle outdated`, `go list -m -u all`.
- Deprecated packages. The install output usually says so; `npm view <pkg> deprecated` confirms per package.
- Duplicate transitive versions of the same package. `npm ls <pkg>`, `pnpm why <pkg>`, `cargo tree -d`.
- Lockfile drift against the manifest: run the install in frozen mode (`npm ci`, `pnpm install --frozen-lockfile`, `poetry check --lock`) and report a failure as a weed.
- Deprecated APIs still called inside current dependencies. Build warnings are the cheapest source: check whether the build emits deprecation warnings and count them by symbol.
- Deprecated language or runtime features in use, and the runtime version pinned in CI versus the one in the manifest engines field versus the one the `Dockerfile` uses. Three sources, they drift apart.
- Version pins with a comment explaining a workaround. Check whether the upstream issue is closed, because a pin outliving its reason is a clean win.
- A package doing one thing that the standard library now does natively.
- Two packages solving the same problem, which usually means a migration that never finished.

## Judgement

Do not propose a bulk upgrade. Group findings into: patch and minor with no known breakage (a single safe commit), majors with a migration cost (one line each, effort noted), and pins to investigate.

Security is not this survey's job and a CVE list is not a weed. If a scanner result falls in your lap, put it under out-of-scope so it reaches the user, and keep going.

Where the repo has a renovate or dependabot config, check whether it's actually opening PRs. A drift problem with automation already installed is a configuration weed, not a dependency weed, and that's a more useful thing to tell the user.
