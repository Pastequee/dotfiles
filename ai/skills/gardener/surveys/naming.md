# Survey: naming and vocabulary

Most weeds here are a rename refactoring wearing a disguise. They cost nothing to fix and they compound: a name that lies misleads every reader and every agent run that follows.

`CONTEXT.md` is the authority on domain vocabulary. Read it first. Where it exists, it wins every disagreement.

## Hunt

- **Names that lie**: a function whose name says less or other than what it does. `getUser` that also writes a cache. `validate` that mutates. `handleX` that does three unrelated things.
- **Vocabulary drift**: three words for one concept (`account` / `customer` / `client` for the same row), or one word for three concepts. List the sites, name the winner from `CONTEXT.md`, and count how far the loser has spread.
- Terms in the code that `CONTEXT.md` never defines, and defined terms the code never uses.
- Leftover lifecycle markers: `v2`, `New`, `Old`, `Legacy`, `Temp`, `Deprecated`, `Final`, `Real`, `_new`, `2` suffixes. Each one says a migration finished without cleaning up, or never finished.
- Grab-bag modules: `utils`, `helpers`, `common`, `misc`, `shared`. Report what's inside and which of those things actually belong together.
- File and directory naming conventions inconsistent within one area (`kebab-case` beside `camelCase` in the same folder).
- Boolean parameters and fields named for the implementation rather than the meaning (`flag`, `check`, `mode`, `type` with no qualifier).
- Abbreviations used in some places and expanded in others for the same concept.
- Comments that only restate the code beneath them. These are the visual-noise kind: the fix is a rename or an extract-method, and the comment disappears on its own.
- Formatter and lint config that isn't applied to the whole tree, leaving pockets with different style.

## Method

For vocabulary drift, `rg -c` each candidate term across the repo and put the counts in the report. The distribution decides which name wins and how big the rename is.

Check the git history of a suspicious name: `git log -S'<name>'` often shows the rename that half-happened.

## Judgement

A rename inside one module is cheap. A rename crossing a public API, a database column, a queue message shape or a serialized payload is not a rename, it's a migration. Say which one you're proposing, with the boundary it would cross.

Names that are merely terse or unfashionable, in code where the local convention is terse, are not weeds. Dismiss them and say the convention.
