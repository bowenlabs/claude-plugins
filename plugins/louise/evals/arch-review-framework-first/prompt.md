---
description: A plan that puts reusable code in one site. The review has to flag it as a framework-first conflict.
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

We're about to add a retry-with-backoff wrapper for Square API calls to one of our client sites, in `src/lib/square-retry.ts`. The other two sites call Square the same way, and each has its own ad hoc retry loop. Before I build it, does this plan fit how we build things on the Louise stack?
