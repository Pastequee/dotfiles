# Design a report for the decision

Produce a visual HTML document whose composition fits the ticket. Choose the
layout, narrative, and supporting assets freely. There is no template, mandatory
component set, fixed section order, or exhaustive content checklist.

Start with what is hardest for the user to understand or judge. Choose a
presentation that makes that question easier to answer. Delegate report creation
when useful, and inspect the result before asking for approval.

## Choose useful content

A spec may benefit from behavior before and after, user journeys, acceptance
examples, exclusions, assumptions, or alternative interpretations. Its job is to
make the intended outcome reviewable.

A plan may benefit from affected components, technical decisions, implementation
dependencies, agent assignments, verification, rollout, or recovery. Its job is to
make the proposed approach and its consequences reviewable.

These are suggestions. Include other material when it helps the decision and omit
what adds no value. Diagrams, interactive mockups, timelines, annotated examples,
and comparison tables are possible assets. When the plan uses a DAG, include its
visualization according to [dag.md](dag.md). Choose its layout and rendering freely;
the graph defines dependencies, not the report's visual structure.

## Apply the design standard

Make the decision awaiting approval easy to find. Establish a clear reading order
with a concise overview and progressive detail. Keep essential decisions and risks
visible without requiring interaction.

Use readable typography, comfortable line lengths, deliberate spacing, and
accessible contrast. Adapt the layout to narrow and wide screens. Let color encode
meaning consistently, and pair it with labels rather than relying on color alone.

Use semantic HTML and keyboard-accessible controls. Keep essential information
available without hovering. Label diagrams and provide a readable explanation when
the visual alone would be inaccessible. Interactions should help comparison,
exploration, or navigation; static content is sufficient when it explains the issue.

Distinguish evidence, assumptions, open questions, and recommendations. Keep the
source and report revision discoverable so approval refers to an identifiable
proposal. After revisions, make material changes easy to review.

Prefer self-contained files that open locally. Keep required supporting assets
alongside the report when a separate asset is useful. Render ticket text and code
examples as content, not executable markup. Avoid remote dependencies that can
break offline reading or expose private ticket content.

Open the report and inspect legibility, overflow, links, and any interactions at
wide and narrow sizes when viewing tools are available. If visual inspection is
unavailable, check the file and asset references and disclose that limitation.
Present the report's local link with the approval question in conversation.
