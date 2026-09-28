{
  "topic": "{{input.topic}}",
  "positions": [
    {
      "key": "example-site:CLAUDE.md",
      "title": "Working in this repo › Stack",
      "kind": "claude_md",
      "authority": 3,
      "citation": "example-site:CLAUDE.md@2098c21",
      "snippet": "Every reusable change belongs in louise-toolkit or astroidjs, not here. If another site would want it, open it upstream."
    },
    {
      "key": "louise-toolkit:docs/adr/0001-opinionated-astro-cloudflare.md",
      "title": "ADR 0001: Opinionated Astro on Cloudflare",
      "kind": "adr",
      "authority": 4,
      "citation": "louise-toolkit:docs/adr/0001-opinionated-astro-cloudflare.md@d76677c",
      "snippet": "Primitives that any Astro-on-Cloudflare site would want live in louise-toolkit; opinionated wiring lives in astroidjs; a site keeps only what is specific to its business."
    },
    {
      "key": "louise-toolkit:packages/louise/CHANGELOG.md@0.31.0",
      "title": "louise-toolkit 0.31.0: runAi retries",
      "kind": "changelog_entry",
      "authority": 2,
      "citation": "louise-toolkit:packages/louise/CHANGELOG.md@0.31.0",
      "snippet": "A batch of small helpers the client sites each hand-rolled, including a retry with exponential backoff for fetch calls, now exported from louise-toolkit."
    }
  ],
  "conflicts": []
}
