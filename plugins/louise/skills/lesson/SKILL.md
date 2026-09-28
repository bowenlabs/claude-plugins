---
name: lesson
description: Turns a correction, a surprise, or a diagnosis into a reviewed lesson in the right Louise / Astroid repository, through a pull request, so Louise knows it next time. Use when someone says to remember something, records what went wrong, or corrects how the stack should be used.
argument-hint: "[what was learned]"
---

# Record a lesson

Turn `$ARGUMENTS`, or the correction in this conversation, into a lesson.
Louise ingests lessons with the same authority as a `CLAUDE.md` rule, so a
lesson has to be true, specific, and reviewed.

## 1. Check it's new

Call `search(<the lesson in a sentence>, kinds: ["lesson", "claude_md",
"adr"])` on the Louise knowledge server. If a source already says it, don't
add a second one: amend that source instead, or tell the user where it's
already written. If an ADR contradicts it, it isn't a lesson; it's a new
decision, so suggest the `new-adr` skill.

## 2. Pick the repository

Put the lesson where the code it's about lives:

- **A framework lesson** (louise-toolkit or astroidjs): that repository's
  `docs/LESSONS.md`, as a new section.
- **A site lesson**: the site's `docs/INCIDENTS.md` when it's about something
  that went wrong, or its `CLAUDE.md` "Gotchas" when it's a trap to avoid.
- **A lesson about how the team or Louise works**: `lessons/<slug>.md` in
  louise-ops.

## 3. Write it

A lesson has a heading that states the rule, then:

- **What happened**: the symptom and its circumstances, with dates.
- **Why**: the cause, with evidence.
- **What to do**: the rule, stated so someone can follow it without the
  story. Name the files, commands, or settings.

Keep it short. Use the Google developer documentation style, and in a public
repository, name no client site.

## 4. Open a PR

On a new branch, commit the lesson with a `docs:` commit, run the repository's
Vale check (`corepack pnpm run lint:docs`), and open a PR that says where the
lesson came from. Louise ingests it after it merges. Don't merge it yourself.
