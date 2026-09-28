---
type: regex
pattern: '\[here\]'
flags: i
match: not_contains
target: { source: file, path: docs/setup.md }
---
