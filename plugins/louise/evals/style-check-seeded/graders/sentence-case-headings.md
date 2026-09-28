---
type: regex
pattern: '^#+ (Setting Up The|Running The)'
flags: m
match: not_contains
target: { source: file, path: docs/setup.md }
---
