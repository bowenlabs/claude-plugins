---
type: regex
pattern: '^(?=[\s\S]*Context)(?=[\s\S]*Critique)(?=[\s\S]*Guidelines)(?=[\s\S]*Accessibility)(?=[\s\S]*Copy)(?=[\s\S]*System)(?=[\s\S]*Performance)(?=[\s\S]*Handoff)'
flags: i
target: last_message
arm: with-only
---
