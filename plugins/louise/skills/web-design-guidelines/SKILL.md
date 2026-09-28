---
name: web-design-guidelines
description: Reviews UI code against the Vercel Web Interface Guidelines and reports findings as file:line. Use when asked to check a page or component against web interface guidelines, or as step 3 of the design-review skill.
argument-hint: "<file-or-pattern>"
---

# Web interface guidelines

Adapted from Vercel's `web-design-guidelines` skill, which is MIT-licensed
(see `LICENSE` beside this file):
[`vercel-labs/agent-skills@ba46938`](https://github.com/vercel-labs/agent-skills/tree/ba46938889d4e58635362fb8f618e1178ac3ec46/skills/web-design-guidelines).
This copy fetches the guidelines at a pinned commit, so a review gives the
same result until the pin moves.

## How it works

1. Fetch the guidelines from the pinned URL below with WebFetch. The fetched
   file holds every rule and the output format.
2. Read the files in `$ARGUMENTS`. If there are none, ask which files to
   review.
3. Check each file against every rule in the guidelines.
4. Report findings in the terse `file:line` format the guidelines specify.

## Guidelines source

```text
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/e3d624baaf29dc1fc645aff3e38f03e564d2d6b1/command.md
```

The guidelines are MIT-licensed by Vercel Labs. To move the pin, replace the
commit in the URL with a newer one from
[`vercel-labs/web-interface-guidelines`](https://github.com/vercel-labs/web-interface-guidelines/commits/main).

## In a Louise site

When a guideline conflicts with the site's design system (from
`get_design_system` on the Louise knowledge server), report the conflict but
don't recommend overriding a token. The design system wins.
