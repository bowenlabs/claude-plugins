---
name: diagnose
description: Diagnoses a failure on a Louise / Astroid site through the support tiers, from a known fix to a diagnosis to a hand-off, and reports the cause, the evidence, and the fix. Use for an error message, a crash, a failing deploy, an incident, or an owner's report that something is broken.
argument-hint: "[symptom, error, issue, or incident]"
---

# Diagnose

Find the cause of `$ARGUMENTS` before you suggest a fix. Work down the tiers
and stop at the first one that answers it.

## Tier 1: known fix

Call `find_similar_fix(<the symptom>)` on the Louise knowledge server, with
the exact error message when there is one. It walks symptom → cause → fix
across lessons, incidents, and issues. Then read the repository's
`docs/INCIDENTS.md` and the "Gotchas" sections of its `CLAUDE.md`.

A match is only a match when the symptom and the circumstances agree, not
just the words. Say why it matches. If it does, report the fix with its
source and stop.

## Tier 2: diagnosis

No known fix, so find the cause. Check, in this order, and record what each
showed:

1. **What changed:** the last deploys and merges (`git log`, the Workers
   Builds history), and dependency bumps.
2. **Where it fails:** logs, the failing request, and the code path. Read the
   code; don't guess from the message.
3. **Whether it's the environment:** a binding, secret, or variable that's
   missing on one environment only (a Preview inherits nothing from the top
   level of `wrangler.jsonc`), a stale local cache, or a service worker
   serving an old page.
4. **The incident record:** `search_incidents` and `get_incident`, when the
   server lists them.

State the cause with its evidence, and how sure you are.

## Tier 3: hand-off

When the fix needs a code change, write it up so the `developer` agent, or
Baylee, can act on it: the cause, the evidence, the proposed change with its
files, and how to verify it. Open a GitHub issue only when asked.

## Limits

Diagnose by reading. Never change a deployed Worker, a database, a secret, or
a production setting. When the fix needs one, give the command and let Baylee
run it.

## Report

```markdown
## Diagnosis: <symptom>

**Tier:** 1, known fix | 2, diagnosed | 3, handed off
**Cause:** <one sentence>
**Evidence:** <what you checked and what it showed>
**Fix:** <the change, or the command for Baylee to run>
**Source:** <the lesson, incident, or issue, when there is one>
```

If the diagnosis taught something the house didn't know, suggest recording it
with the `lesson` skill.
