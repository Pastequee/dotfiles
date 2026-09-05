# Survey: drift

Everything in the repo that describes the code, checked against the code. Drift is silent: nothing fails, the reader just gets misled.

Agent instruction files matter most here. A stale `CLAUDE.md` misleads every agent run on this repo, so weight it heavily.

## Hunt

- `README` setup steps, commands and examples that no longer run. Check every command against the manifest scripts and every code sample against the current API.
- `CLAUDE.md` / `AGENTS.md` naming files, directories, commands or frameworks that moved or vanished. Resolve every path they mention.
- `CONTEXT.md` terms the code no longer uses, and code concepts `CONTEXT.md` never picked up.
- ADRs in `docs/adr/` describing decisions the code has since reversed, with no superseding ADR. This is the highest-value drift you can find: it's the record of *why*, and when it's wrong it's actively harmful.
- Comments contradicting the code beneath them. Weight toward comments in hotspot files, since those had the most chances to drift.
- Docstring parameters, return types and raised errors that don't match the signature.
- Documented env vars versus what the code actually reads, in both directions. Cross-check `.env.example` against `rg` for the config accessor.
- API docs, OpenAPI specs and generated schemas older than the handlers they describe.
- Broken internal links between docs, and links to deleted files.
- Docs describing a service, endpoint or feature that's been retired.
- `CHANGELOG` stopping some versions ago while releases continued.

## Method

Path resolution first, since it's mechanical and finds a lot: extract every file path, command and URL mentioned in the docs, and check each one exists.

Then age comparison: for each doc, `git log -1 --format=%ci <doc>` against the last commit to the code it describes. A doc untouched through three refactors of its subject is a candidate, not a verdict. Read it before calling it.

## Judgement

The fix is usually deletion, not rewriting. A short accurate file beats a long file full of stale context, and unless you can verify the correct current statement, deleting the wrong one is the honest move. Say which you're proposing.

A comment that only restates the code is a naming or extract-method problem, not drift. Send it to the `naming` survey's territory and skip it here.

Do not propose adding documentation that doesn't exist. Absence is not drift, and the gardener doesn't grow new things.
