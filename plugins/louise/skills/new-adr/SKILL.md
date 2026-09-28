---
name: new-adr
description: Writes a new architecture decision record for a Louise / Astroid repository, or an amendment to an existing one, with the next number, the related decisions, and the repository's template, in Google developer style. Use when a decision needs recording, or when asked to write, draft, or amend an ADR.
argument-hint: "[what the decision is about]"
---

# New ADR

Record the decision in `$ARGUMENTS` in the repository you're in.

## 1. Amend or write new

Call `adr_context(<the decision>, <repository>)` on the Louise knowledge
server. It returns the next number, related decisions, and the template.

Read each related decision with `get_decision`. If one of them already decides
this question, **amend it rather than writing a new ADR**: add a dated
`> **Amended (YYYY-MM-DD).**` block under its status line that says what
changed and why, and leave the original text. A new ADR is for a new
question, or one that supersedes an old decision outright; then set the old
one's status to "Superseded by ADR NNNN".

## 2. Write it

Use the repository's template (from `adr_context`, or the newest ADR in
`docs/adr/`) and its file naming, such as `docs/adr/0023-short-title.md`.
A house ADR has:

- **Status** and **date**: "Proposed" until Baylee accepts it.
- **Context**: what forces the decision, with the facts and numbers found.
  Cite related decisions by number.
- **Decision**: what's decided, stated plainly, in the present tense.
- **Consequences**: what gets easier, what gets harder, and what has to
  happen next, including in other repositories.
- **Alternatives considered**, when there were real ones, with why each lost.

Follow the Google developer documentation style, and call `style_rules("doc")`
for the house vocabulary. In a public repository, name no client site; keep
the reason and describe the site generically ("a site with a customer
portal").

## 3. Check it

Run the repository's Vale check (`corepack pnpm run lint:docs`) and fix every
error. Then report the file, its number, and the decisions it relates to or
amends.
