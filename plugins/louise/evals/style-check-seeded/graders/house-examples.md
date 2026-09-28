---
type: regex
pattern: 'acme|555-123-4567'
flags: i
match: not_contains
target: { source: file, path: docs/setup.md }
weight: 2
---
