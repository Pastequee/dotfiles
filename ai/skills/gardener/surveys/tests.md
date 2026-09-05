# Survey: test suite health

A suite nobody trusts is worse than a small suite. This survey finds the parts that have stopped protecting anything.

Names below come from the Open Catalog of Test Smells, so use them: they're precise and searchable.

## Hunt

- **Disabled and ignored tests**: `.skip`, `xit`, `xdescribe`, `@Ignore`, `@pytest.mark.skip`, `t.Skip()`, `#[ignore]`. For each, get its age with `git log -S` or `git blame` and whether anything records an owner or an expiry. A skip older than a few months is a decision nobody made out loud.
- **`xfail` with `strict=False` and equivalents**: permanent quarantine wearing a temporary label.
- **Missing Verdict**: tests with no assertion. They pass by not throwing.
- **Rotten green tests**: tests that pass without ever reaching their assertions, usually because the assertion sits after an early return, inside a callback that never fires, or in a branch the fixture never takes.
- **Empty tests**: a body with only setup, or only a comment.
- Tests for code that no longer exists, or that assert on behaviour the code stopped having.
- **Flaky tests**: search CI history or the test log for retry configuration, `retries:`, `flaky` annotations, and rerun plugins. Retry config is the fingerprint of flakiness somebody decided to live with. Google measured 16% of their tests as flaky, so a repo claiming zero is usually not measuring.
- Fixed `sleep`/`setTimeout` waits instead of polling or framework waits.
- Test-order dependence: shared module-level mutable state, tests that write to a shared database or filesystem path without cleanup, teardown that doesn't run when an assertion fails.
- Fixtures, factories, mocks and helper files no test references.
- Duplicated setup blocks that should be one shared fixture.
- **Assertion Roulette**: many undocumented assertions in one test, so a failure doesn't say what broke.
- Coverage thresholds that were lowered rather than met. Check the config's git history.

## Tools

`rg` for the skip markers is the fastest first pass. The test runner's own reporting gives skip counts. Check the survey card for whether the suite currently passes: a red suite changes the whole report.

## Judgement

Do not propose deleting a skipped test just because it's skipped. A hidden failing test is a signal, and deleting it destroys the signal. The verdict for a stale skip is usually: fix it, or delete it *and* say what coverage is being given up. Put that choice in the weed's line.

Distinguish flaky from brittle. Flaky fails nondeterministically and needs timing or isolation work. Brittle fails deterministically when the app changes and needs a better abstraction. Label which one you're looking at.
