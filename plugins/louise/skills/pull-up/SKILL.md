---
name: pull-up
description: Moves reusable code from a Louise site into louise-toolkit or astroidjs, decides which one it belongs in, and plans the change in both repositories. Use when a site has code another site would want, or when asked to extract, upstream, or pull code up into the framework.
argument-hint: "[site file, function, or feature]"
---

# Pull up

Move `$ARGUMENTS` out of the site and into the framework, framework first.

## 1. Decide where it goes

Read the code and everything it depends on. Then decide:

- **louise-toolkit**, when it's a primitive any Astro-on-Cloudflare site would
  want and it can have zero runtime dependencies in `packages/louise`. Astro-
  specific pieces go in `@louise-toolkit/astro`.
- **astroidjs**, when it's opinionated wiring: something `astroid.config.ts`
  should generate or configure.
- **Stay in the site**, when it's specific to that one business. Say why.

Check the choice with `explain_opinion("framework-first placement for <what
it does>")` and cite the source. Check for an existing primitive that already
does most of it with `get_api(<likely subpath or name>)` and `search`; extend
that rather than adding a second one.

## 2. Check who else has it

Run `find_usages` and `search` for the same pattern in the other sites. If two
or three sites carry near-copies, the pull-up replaces all of them; list each
copy with its path.

## 3. Plan the change

Write a plan with one section per repository, in the order they land:

1. **The framework** (louise-toolkit or astroidjs): the new export's name,
   subpath, and signature; its tests; its docs page; and a changeset
   (`minor` for a new export). Follow that repository's `CLAUDE.md`.
2. **Each site**: the version bump, the code it deletes, and the import that
   replaces it. Remember to bump astroidjs and louise-toolkit together.

## 4. Do it, when asked

Implement one repository at a time, starting with the framework, and run each
repository's full check suite before the next (the `verify` skill). The site
PRs wait for the framework release.
