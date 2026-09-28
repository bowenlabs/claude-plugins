---
name: verify
description: Runs the current Louise / Astroid repository's full check suite, the same steps as its CI in the same order, and reports each command's result. Use before calling a change done, before opening a PR, or when asked to verify, check, or test a change.
---

# Verify

Run the repository's full check suite, the way its CI does.

## 1. Find the steps

Read the repository's `CLAUDE.md` and find its "Verify a change" section (or
"Checks"). It lists the commands in CI's order. If it doesn't have one, read
`.github/workflows/ci.yml` and run its `run:` steps in order. Don't invent
steps and don't skip any.

Before you start, apply the toolchain notes in `CLAUDE.md`, such as running
`corepack pnpm`, never a global `pnpm`, and putting corepack's shim first on
`PATH` when a root script calls `pnpm` itself.

## 2. Run each step

Run each command on its own and read **its exit code**, not a summary line.
Keep going after a failure so the report shows every failing step, unless a
later step depends on the one that failed, such as a test run after a failed
install.

Some steps need reading, not just an exit code. Follow what `CLAUDE.md` says
about each one. For example, `astroid doctor` exits non-zero for informational
findings, so it fails only on a line marked `✗`. And a coverage floor that
ratchets rewrites its config file, which you commit after running the
repository's fixer.

## 3. Report

```markdown
## Verify

| Step | Command | Result |
| --- | --- | --- |
| 1 | `corepack pnpm install --frozen-lockfile` | pass |
| 2 | `corepack pnpm exec biome ci .` | **fail**: 2 errors |
| … | … | … |

<For each failure: the relevant lines of its output, and the fix if it's
clear.>
```

Report a failure as a failure. Don't call the change done while any step
fails.
