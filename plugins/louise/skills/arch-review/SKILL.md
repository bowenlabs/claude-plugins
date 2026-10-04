---
name: arch-review
description: Checks an architecture proposal, design doc, or planned change against the Louise / Astroid house decisions, rules, and book principles, and reports every conflict with its source. Use when someone asks whether an approach fits the stack, where code should live, or to review a plan before it's built.
argument-hint: "[proposal, file, or PR]"
---

# Architecture review

Review the proposal against what the house has already decided. The house
position lives in the Louise knowledge server; this skill tells you how to ask
it and how to report. Don't restate opinions from memory.

## 1. Pin down the proposal

Read what the user gave you: `$ARGUMENTS`, a file, a PR (`gh pr diff`), or the
conversation. Write it as a short list of claims, one decision per line, such
as "add a Square catalog cache to one site" or "export a new
`withRetry` helper from `louise-toolkit/ai`".

## 2. Ask Louise about each claim

For each claim:

1. `explain_opinion(<the claim, as a question>)`. It returns decisions,
   rules, lessons, and principles ranked by authority, and it shows conflicts
   between them.
2. One `list_rules(paths, repo)` call with every path the claim touches.
3. For a new or changed export, `find_usages` on it and on its module.
4. `get_principles(<topic>, "architect")` when a book principle bears on it.

Always check framework-first placement, even when nobody asked:
`explain_opinion("where does reusable code go: site, astroidjs, or louise-toolkit")`.
Code that a second site would want doesn't belong in a site. A claim that
puts reusable code in a site is a conflict, and the finding says whether it
belongs in louise-toolkit or astroidjs and why.

When Louise answers "No house source covers this", record the claim as
**not covered**, not as a pass or a conflict. When `search` or
`explain_opinion` returns `missingTerms`, the hits don't cover those terms.

## 3. Report

```markdown
## Architecture review: <proposal>

**Verdict:** fits | fits with changes | conflicts

### Conflicts
1. **<claim>** conflicts with **<source title>** (`<citation>`, authority <n>).
   <one sentence on the conflict>. **Change:** <what to do instead>.

### Fits
- <claim>: <source that supports it> (`<citation>`)

### Not covered
- <claim>: no house source. <what you'd need to decide>

### Impact on other repositories
- <repo> at <pinned version>: <what breaks or changes>

### ADR
Needed | Not needed: <why>. <If needed: the next number from `adr_context`, and
the decisions it relates to or amends.>
```

Rank conflicts by the source's authority (an ADR outranks a lesson, which
outranks a doc, which outranks a book). Cite every source by the `citation`
Louise returned, so a reader can open it at the ingested commit.
