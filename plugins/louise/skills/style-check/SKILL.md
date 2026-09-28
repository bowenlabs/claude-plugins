---
name: style-check
description: Checks and fixes changed docs, code comments, and UI strings against the Google developer documentation style guide and the Louise house style, running Vale where the repository has it and a rewrite pass either way. Use when asked to check, lint, proofread, or fix the style of prose, a doc, a comment, or UI copy.
argument-hint: "[files or glob; default: changed files]"
---

# Style check

Fix the prose in `$ARGUMENTS`, or with no arguments, in the files changed
against the base branch (`git diff --name-only origin/main...`). Prose means
Markdown and MDX, comments and JSDoc, and user-facing strings in code: button
labels, errors, empty states, and email templates.

## 1. Get the rules

Call `style_rules` on the Louise knowledge server, with `kind` set to `doc`,
`comment`, or `ui` for each kind of file you're checking. It returns the house
Vale vocabulary and the Google guide topics that apply.

## 2. Run Vale, when the repository has it

If the repository has a `.vale.ini`:

```sh
corepack pnpm --package=@vvago/vale@3.17.1 dlx vale sync
corepack pnpm run lint:docs
```

If `vale sync` or `lint:docs` can't run (no network, no `lint:docs` script),
say so in the report and continue with step 3. Don't stop.

## 3. Rewrite

Go through each file yourself; Vale doesn't catch everything. Fix these in
place with the Edit tool:

- **Voice:** second person ("you"), present tense, active voice. "The token
  is stored by the script" becomes "The script stores the token".
- **Banned words:** remove "please", "simply", "just", "easy", "easily",
  "obviously", and "of course". Rewrite the sentence so it doesn't need them.
- **Headings:** sentence case. "Setting Up The Database" becomes "Set up the
  database".
- **Lists:** parallel structure, and a colon before a list, not an ellipsis.
- **Code font:** commands, file names, paths, environment variables, and
  identifiers.
- **Dashes:** a dash is for sentences only. Page titles use a pipe, and items
  side by side use a middle dot.
- **Links:** descriptive link text, never "click here" or "this link".
- **The house rules** from step 1: apply every rule `style_rules` returns, not
  only the ones listed here, such as its example conventions (placeholder
  domains, company names, and phone numbers in place of real ones) and its
  preferred terms.
- **Client names:** in a public repository, name no client site. Keep the
  reason and describe the site generically.

Don't change meaning, code, or anything inside a code block. Don't touch
`CHANGELOG.md`, which records what already shipped.

## 4. Check again and report

Run Vale again if it ran in step 2. Then report:

```markdown
## Style check

- Vale: <N errors before, M after> | not run: <why>
- Fixed: <N changes in M files>
  - `<file>:<line>`: <before> → <after>
- Left for you: <anything you didn't change, and why>
```
