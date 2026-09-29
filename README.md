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
`louise:reviewer` agent on a pull request and posts one comment, which it
edits on each later push. It never edits files, pushes, or approves. It skips
drafts, pull requests from forks, which GitHub runs without secrets, and
pull requests from bots other than the Louise agent app. It lives in this
repository because this one is public, and a public repository can't call a
reusable workflow stored in a private one.

Like the diagnose tier, the agent gets no shell: a workflow step collects the
pull request and its diff into files, the agent writes its review to a file,
and a second job refuses a review that contains a credential, then posts it
as `bowenlabs-louise-agent[bot]`. The step also runs Vale on the changed files,
with the repository's `.vale.ini` and the house `lint-docs` runner, and the
review reports each finding on a line the pull request changed. For a UI
change, the reviewer runs the `design-review` skill on the changed files, with
the steps that need a URL left out.

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
    with:
      agent_app_id: ${{ vars.LOUISE_AGENT_APP_ID }}
    secrets:
      claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      louise_token: ${{ secrets.LOUISE_REVIEW_TOKEN }}
      agent_app_private_key: ${{ secrets.LOUISE_AGENT_APP_PRIVATE_KEY }}
```

It needs two secrets, and the Louise agent app to post as it:

- **A Claude credential:** a Claude Code OAuth token from `claude setup-token`,
  passed as `claude_code_oauth_token`, or an Anthropic API key, passed as
  `anthropic_api_key`.
- **A Louise read token,** passed as `louise_token`. In a public repository,
  give it `public` visibility only, so a review there can't quote a private
  source. The louise-ops RUNBOOK says how to make and rotate one.
- **The app:** `agent_app_id` and `agent_app_private_key`, described in the
  next section. Without them, the review posts as `github-actions[bot]`.

## Mentions in CI

`.github/workflows/louise-mention.yml` answers a comment that mentions
`@louise` on an issue or pull request, for design and architecture
discussions. The agent picks the Louise agent the question belongs to
(architect, designer, product, reviewer, or support) and posts one reply as
`bowenlabs-louise-agent[bot]`: in the thread, for a comment on a line of code.
Only someone with write access can mention it. It has the same limits as the
diagnose tier below: the comment, the thread, and a pull request's diff are
collected into files first, the agent has no shell and writes one file, and a
second job refuses a reply that contains a credential.

```yaml
name: Louise mention

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

permissions:
  contents: read
  issues: write
  pull-requests: write

jobs:
  mention:
    if: contains(github.event.comment.body, '@louise')
    uses: bowenlabs/claude-plugins/.github/workflows/louise-mention.yml@main
    with:
      agent_app_id: ${{ vars.LOUISE_AGENT_APP_ID }}
    secrets:
      claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      louise_token: ${{ secrets.LOUISE_REVIEW_TOKEN }}
      agent_app_private_key: ${{ secrets.LOUISE_AGENT_APP_PRIVATE_KEY }}
```

## Diagnose and fix in CI

Two more reusable workflows run an agent on an issue when someone adds a
label. Each removes its label when it finishes, so adding the label again
runs it again.

- **`louise-diagnose.yml`, the `agent:diagnose` label:** the `louise:support`
  agent runs the `diagnose` skill, and the workflow posts the diagnosis as
  one comment. The agent gets no shell: a workflow step collects the issue,
  the recent history, and the latest failing run's log into files first, and
  the agent reads those and writes its diagnosis to a file. It runs only
  when the person who added the label, and whoever re-runs it, has write
  access.
- **`louise-fix.yml`, the `agent:fix` label:** the `louise:developer` agent
  fixes the issue in a checkout and runs the repository's checks. It hands
  its change on as a patch. A second job, on a fresh runner, applies it,
  refuses what it must, and pushes a `louise/fix-<issue>-<run>-<attempt>`
  branch with a pull request, as the Louise agent GitHub App. Nothing merges
  it. It runs only when a repository admin added the label, and skips a site
  whose `workers/site/wrangler.jsonc` has no `previews` block, since that
  site's branches still deploy production.

A repository calls them from one workflow. Leave out the `fix` job on a
repository whose branches don't deploy to staging:

```yaml
name: Louise agents

on:
  issues:
    types: [labeled]

permissions:
  contents: read
  issues: write
  actions: read

jobs:
  diagnose:
    if: github.event.label.name == 'agent:diagnose'
    uses: bowenlabs/claude-plugins/.github/workflows/louise-diagnose.yml@main
    with:
      agent_app_id: ${{ vars.LOUISE_AGENT_APP_ID }}
    secrets:
      claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      louise_token: ${{ secrets.LOUISE_REVIEW_TOKEN }}
      agent_app_private_key: ${{ secrets.LOUISE_AGENT_APP_PRIVATE_KEY }}

  fix:
    if: github.event.label.name == 'agent:fix'
    uses: bowenlabs/claude-plugins/.github/workflows/louise-fix.yml@main
    with:
      agent_app_id: ${{ vars.LOUISE_AGENT_APP_ID }}
    secrets:
      claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      agent_app_private_key: ${{ secrets.LOUISE_AGENT_APP_PRIVATE_KEY }}
```

Diagnose needs the same two secrets as the review. Both use the Louise agent
GitHub App, `bowenlabs-louise-agent`: its ID in the `LOUISE_AGENT_APP_ID`
variable and its private key in the `LOUISE_AGENT_APP_PRIVATE_KEY` secret. Its
comments come from the app, and fix needs it to push. The app has `Contents`,
`Issues`, and `Pull requests` write, and each workflow narrows every token it
mints to the one repository and the one permission the job needs. Without the
app, diagnose posts as `github-actions[bot]`, and fix doesn't run. It pushes
because a push made with the workflow's own token doesn't start other
workflows, and `CI` is a required check. Give `main` a ruleset that lets only
repository admins update it, so the app can push a branch but never merge.
Until a repository has what a workflow needs, that workflow skips with a
notice.

### What the agents can reach

The issue is untrusted input, so both workflows limit what text reaches the
agent and what the agent can do with it:

- **What the agent reads:** the issue's title and body as they were when the
  label went on, taken from the event, and comments written before then by
  the repository's owners and collaborators or by Louise itself. A run stops
  if the issue was edited after the label went on.
- **The runner:** the agent's job takes away sudo and Docker, and has a
  GitHub token that can only read.
- **Earlier diagnoses:** only comments from `bowenlabs-louise-agent[bot]` count,
  since any workflow in the repository can post as `github-actions[bot]`.
- **Diagnose:** no shell, no network tools, and no reads outside the
  workspace. It writes one file. A second job refuses a diagnosis that
  contains a credential, then posts it.
- **Fix:** it can edit files in the workspace and run the repository's pnpm
  scripts, which is enough to run code. Those commands run as a separate
  `agent` user with no network, no sudo, and access to the workspace only, so
  they can't reach the Claude credential or send anything out. The job has no
  Louise token, dependencies are installed before the agent starts, and a check
  that needs the network fails there. The admin who adds the label still
  vouches for the issue as it stands. The `publish` job refuses a change to `.github/`, `.claude/`,
  `.vscode/`, `.devcontainer/`, `.mcp.json`, or `.envrc`, and a patch or pull
  request text that contains a credential. It warns at the top of the pull
  request about a change to `package.json`, `.npmrc`, `pnpm-workspace.yaml`,
  `wrangler.jsonc`, or a config file. The app's key is read only there.

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
