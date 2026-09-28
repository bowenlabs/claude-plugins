---
name: ux-review
description: Runs the UX audit on a flow in a Louise site or the Louise editor, such as signing in, editing a page, or placing an order, against the editor vision, owner feedback, and Designing Interfaces, and returns one verdict with ranked fixes. Use when asked to review a flow, a journey, onboarding, or how easy something is for an owner or a customer.
argument-hint: "[flow, URL, or files]"
---

# UX review

Audit the flow in `$ARGUMENTS`. A flow is a goal and the steps to reach it,
such as "an owner changes the opening hours" or "a customer orders ahead".
Run every step below in order. When a step's skill isn't installed, do its
check yourself from its brief and mark it "run without `<skill>`".

## 1. Context (Louise)

- `search_feedback(<the flow's topic>)`: what owners have said about it.
- `explain_opinion(<the flow's main decision>)`: product decisions already
  made, and the ADRs behind them.
- `search("editor vision <topic>", kinds: ["architecture_doc", "doc_page"])`:
  where the editor is heading, and the guide pages that describe the flow
  today.
- `get_principles(<topic>, "product")`: *Designing Interfaces* and the other
  books, and whether each agrees with the house.
- `get_design_system(<site>)`, for the design system the flow uses.

## 2. Walk the flow

Write the person's goal in one sentence, in their words. Then walk the flow
step by step, in the browser when there's a URL, and for each step record
what the person sees, what they have to know, and what they do. Mark every
point where they have to know something only a developer knows, or where
they can lose work.

## 3. Critique

Run `design:design-critique` on the key screens. Its brief: hierarchy,
usability, and consistency.

## 4. Accessibility

Run `design:accessibility-review`, and with a URL, AccessLint
(`accesslint:accessibility-audit`). Their brief: WCAG 2.1 AA across the whole
flow, including focus order between steps, error recovery, and keyboard-only
completion.

## 5. Copy

Run `design:ux-copy` on each step's labels, confirmations, errors, and empty
states. Pass along `style_rules("ui")`.

## 6. Research (optional)

When the user has transcripts, notes, or survey data, run
`design:research-synthesis` on them. Otherwise record "no research given".

## Report

```markdown
## UX review: <flow>

**Goal:** <the person's goal, in their words>
**Verdict:** works | works with fixes | gets in the way. <one sentence>

### Where it gets in the way, ranked
1. **<step>**: <what goes wrong for the person>. **Fix:** <change>.
   (<feedback, decision, principle, or WCAG criterion it rests on>)

### Steps
| Step | Skill | Result |
| --- | --- | --- |
| 1. Context | Louise | <feedback items, decisions found> |
| … | … | … |
```

Rank by how often the person meets the problem and how much it costs them:
lost work first, then a dead end, then confusion, then polish.
