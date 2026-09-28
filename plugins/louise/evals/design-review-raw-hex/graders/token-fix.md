---
type: llm
---

PASS if the response flags the literal `#1F2A44` on the `h1` in `Hero.astro` as a value the `--color-ink` token already holds, and says to use `var(--color-ink)` instead.
FAIL if it doesn't mention that literal, or doesn't connect it to the `--color-ink` token.
