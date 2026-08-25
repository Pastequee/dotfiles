---
name: technical-writing
description: Write technical prose that works on the first read. Use when writing or revising a report, plan, summary, pr description, design doc, spec, README, or commit message, or when another skill needs prose style rules.
---

# Technical writing

Root virtue: the text works on the **first read**. The reader acts correctly without rereading, without asking a follow-up, and without cross-referencing something you invented earlier. Every rule below serves that.

Sources distilled here: Simplified Technical English (ASD-STE100), the Google developer documentation style guide, and the git commit conventions of Tim Pope and cbeams.

## Words and sentences (Simplified Technical English)

- One idea per sentence. An instruction sentence gives one action.
- Active voice with a named actor: "The lambda retries the message", not "the message is retried".
- Imperative mood for instructions: "Remove the flag", not "the flag should be removed".
- Keep instruction sentences under 20 words and descriptive sentences under 25. Split long sentences at the "and".
- One word, one meaning — pick a term and repeat it everywhere. A synonym makes the reader hunt for a distinction that isn't there.
- Prefer the short common word: "use" over "utilize", "so" over "consequently", "about" over "approximately".
- Break noun clusters longer than three words: "the configuration of the queue retry policy", not "the queue retry policy configuration values".
- Present tense for facts and behaviour; reserve future tense for genuinely future events.
- Spell out every reference: "this" and "it" take a noun ("this migration", "the consumer").

## Paragraphs and documents (Google style)

- **Front-load.** The key finding, decision, or outcome is the first sentence of the document, and the topic of each paragraph is its first sentence. A reader who stops after any prefix still leaves with the most important part.
- One topic per paragraph, six sentences maximum.
- Headings state content in sentence case: "Retry behaviour under partial failure", not "Overview".
- Condition before instruction: "To enable retries, set `maxAttempts`" — the reader decides whether the step applies before reading how to do it.
- Numbered steps for procedures, one action per step. Vertical lists for more than three parallel items.
- Say why, not just what: a decision without its reason forces the next maintainer to re-derive or distrust it.
- Address the reader as "you" in instructions; reserve "we" for genuinely shared decisions.
- Write for the reader who wasn't there: define codenames and shorthand at first use, or drop them.

## Commit messages (Pope, cbeams)

- Subject line: 50 characters or fewer, capitalized, imperative mood, no trailing period. Test: "If applied, this commit will *\<subject\>*."
- Blank line between subject and body.
- Body wrapped at 72 characters.
- Body explains what changed and why; the diff already shows how.
- Repo conventions (type/scope prefixes, issue tags) compose with these rules — they constrain the subject's format, and the imperative-mood test still applies to what follows the prefix.

## Before delivering

Reread the text once as the reader: every sentence carries one idea, the first sentence of the document and of each paragraph carries its point, and every reference resolves without looking elsewhere. Fix what fails; then it is done.
