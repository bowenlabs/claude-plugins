---
type: regex
pattern: '\b(please|simply|easy|obviously)\b'
flags: i
match: not_contains
target: { source: file, path: docs/setup.md }
weight: 2
---
