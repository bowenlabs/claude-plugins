# claude-plugins

A [Claude Code plugin](https://code.claude.com/docs/en/plugins) marketplace for
the Louise / Astroid stack.

## Plugins

| Plugin | What it does | Status |
| --- | --- | --- |
| `louise` | Specialist subagents and skills for architecture, design, UX, docs, support, and review, backed by the `louise` MCP server | 0.1.1 |

## Install

Add the marketplace and install from it:

```text
/plugin marketplace add bowenlabs/claude-plugins
/plugin install louise@bowenlabs
```

The `louise` plugin connects to a private MCP server and needs a read token in
`LOUISE_KNOWLEDGE_TOKEN`. The variable's name doesn't look like a credential on
purpose: Claude Code reads credential-shaped variable names as empty. Without
the token, the skills still load but can't look anything up. The louise-ops
RUNBOOK says how to make a token.

In a repository, commit `.claude/settings.json` so everyone who opens it is
offered the plugin and the audit plugins its skills call:

```json
{
  "extraKnownMarketplaces": {
    "bowenlabs": {
      "source": { "source": "github", "repo": "bowenlabs/claude-plugins" }
    },
    "knowledge-work-plugins": {
      "source": { "source": "github", "repo": "anthropics/knowledge-work-plugins" }
    },
    "accesslint": {
      "source": { "source": "github", "repo": "AccessLint/skills" }
    },
    "ui-ux-pro-max-skill": {
      "source": { "source": "github", "repo": "nextlevelbuilder/ui-ux-pro-max-skill" }
    },
    "cloudflare": {
      "source": { "source": "github", "repo": "cloudflare/skills" }
    }
  },
  "enabledPlugins": {
    "louise@bowenlabs": true,
    "design@knowledge-work-plugins": true,
    "frontend-design@claude-plugins-official": true,
    "accesslint@accesslint": true,
    "ui-ux-pro-max@ui-ux-pro-max-skill": true,
    "cloudflare@cloudflare": true
  }
}
```

## What's in `louise`

**Subagents**, each scoped to the tools its job needs:

| Agent | Job |
| --- | --- |
| `architect` | System and API design, framework-first placement, ADRs, and the effect of a change on other repositories. Read-only |
| `developer` | Implements to house conventions and runs the repository's full check suite |
| `designer` | Tokens, themes, sections, typography, accessibility, and rendered-page audits. Doesn't edit |
| `product` | Owner flows and owner feedback. Read-only |
| `writer` | Docs, ADRs, changesets, comments, and UI copy in Google developer style |
| `support` | Diagnoses failures and matches them to known fixes |
| `reviewer` | Reviews a PR against rules, ADRs, the design system, and style |

**Skills**, each also a slash command, such as `/louise:arch-review`:

| Skill | What it does |
| --- | --- |
| `arch-review` | Checks a proposal against the house decisions, rules, and principles |
| `design-review` | Runs the design audit in a fixed order and merges it into one verdict |
| `ux-review` | Runs the UX audit on a flow |
| `style-check` | Runs Vale and a Google-style rewrite pass, and fixes what it finds |
| `new-adr` | Writes or amends an ADR with the next number and related decisions |
| `pull-up` | Moves reusable site code into louise-toolkit or astroidjs |
| `upgrade-site` | Upgrades a site's framework packages from what changed since its pins |
| `verify` | Runs the repository's full check suite, in CI's order |
| `diagnose` | Works a failure through the support tiers |
| `lesson` | Turns a correction into a reviewed lesson through a PR |
| `web-design-guidelines` | Vercel's Web Interface Guidelines check, vendored under its MIT license |

The skills ask the Louise knowledge server for the house position rather than
restating it, so they stay current as the decisions change. Its tools appear
as `mcp__plugin_louise_louise__*`.

## Review in CI

`.github/workflows/louise-review.yml` is a reusable workflow that runs the
`louise:reviewer` agent on a pull request and posts one comment. It edits
that comment on each later push, and never edits files, pushes, or approves.
It skips drafts, pull requests from bots, and pull requests from forks, which
GitHub runs without secrets. It lives in this repository because this one is
public, and a public repository can't call a reusable workflow stored in a
private one.

A repository calls it from its own workflow:

```yaml
name: Louise review

on:
  pull_request:
    types: [opened, synchronize, ready_for_review, reopened]

permissions:
  contents: read
  pull-requests: write

jobs:
  review:
    uses: bowenlabs/claude-plugins/.github/workflows/louise-review.yml@main
    secrets:
      claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      louise_token: ${{ secrets.LOUISE_REVIEW_TOKEN }}
```

It needs two secrets:

- **A Claude credential:** a Claude Code OAuth token from `claude setup-token`,
  passed as `claude_code_oauth_token`, or an Anthropic API key, passed as
  `anthropic_api_key`.
- **A Louise read token,** passed as `louise_token`. In a public repository,
  give it `public` visibility only, so a review there can't quote a private
  source. The louise-ops RUNBOOK says how to make and rotate one.

## Evals

`plugins/louise/evals/` holds one case for each of the plugin's acceptance
checks: `arch-review` flags a framework-first conflict, `design-review` runs
every step and names the token for a literal color, and `style-check` fixes a
seeded doc. The Louise tools are mocked, so the evals need no token. They call
the model with your credentials, so run them yourself rather than in CI:

```sh
cd plugins/louise
claude plugin eval . --trust-plugin --scaffold --allow-tools Edit
```

`--scaffold` runs each case's `scaffold.sh`, which copies its fixtures into the
run's workspace.

## Checks

Every skill, agent, and doc follows the Google developer documentation style
guide and the Louise house style (louise-toolkit ADR 0013), checked by Vale in
CI, along with the plugin and marketplace manifests. To run them locally with
Node 26:

```sh
corepack pnpm --package=@vvago/vale@3.17.1 dlx vale sync
corepack pnpm run lint:docs
claude plugin validate plugins/louise --strict
```

This repository holds prompts, agents, and skills only. It contains no data and
no secrets.
