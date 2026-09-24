# claude-plugins

A [Claude Code plugin](https://code.claude.com/docs/en/plugins) marketplace for
the Louise / Astroid stack.

## Plugins

| Plugin | What it does | Status |
| --- | --- | --- |
| `louise` | Specialist subagents (architect, developer, designer, product, writer, support, reviewer) and skills such as `/arch-review`, `/design-review`, and `/new-adr`, backed by the `louise` MCP server | Planned |

## Install

After the first plugin ships, add the marketplace and install from it:

```text
/plugin marketplace add bowenlabs/claude-plugins
/plugin install louise@bowenlabs
```

The `louise` plugin connects to a private MCP server and needs a token in
`LOUISE_KNOWLEDGE_TOKEN`. Without the token, the skills still load but can't
look anything up.

This repository holds prompts, agents, and skills only. It contains no data and
no secrets.
