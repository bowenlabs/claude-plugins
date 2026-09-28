---
name: upgrade-site
description: Upgrades a Louise site's astroidjs, louise-toolkit, and @louise-toolkit/astro to the latest releases, using what changed between its pinned versions and the latest and where the site uses each changed export. Use when asked to upgrade, bump, or update the framework in a site.
argument-hint: "[target version; default: latest]"
---

# Upgrade a site

Upgrade the site you're in to `$ARGUMENTS`, or to the latest releases.

## 1. Read the pins

Read the pinned versions of `astroidjs`, `louise-toolkit`, and
`@louise-toolkit/astro` from the site's `package.json`, where the site's
`CLAUDE.md` says they live. Bump astroidjs and louise-toolkit together: pre-1.0,
a caret range doesn't cross a minor, so a toolkit minor that astroidjs doesn't
accept yet installs a second, nested toolkit.

## 2. Find what changed

For each package, call `whats_changed(since: <pinned version>, package:
<name>)` on the Louise knowledge server. It returns every release since, with
its changelog entries, breaking changes, and the issues and PRs behind them.

Then call `find_usages` for each changed or removed export. Keep only the
changes that touch this site. For each one, note the file and line and what
has to change there.

## 3. Upgrade

1. Update the versions in `package.json`, then run
   `corepack pnpm install`.
2. Confirm a single toolkit version:
   `grep '^  louise-toolkit@' pnpm-lock.yaml` must show one version.
3. Make the code changes from step 2, and follow each release's "What you
   have to do" notes.
4. Regenerate: `corepack pnpm build` rewrites the files `astroid generate`
   owns. Don't hand-edit them.
5. Run the site's full check suite (the `verify` skill), including
   `corepack pnpm run doctor`.

## 4. Report

List each version change, each code change with its reason, and each check's
result. Anything a release asks the owner to do after the deploy goes last,
under "After you deploy".
