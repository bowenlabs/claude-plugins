{
  "site": "{{input.site}}",
  "themes": ["light", "dark"],
  "tokens": [
    { "token": "--color-ink", "theme": "light", "value": "#1f2a44", "overrides": "--louise-color-text" },
    { "token": "--color-ink", "theme": "dark", "value": "#f3ede4", "overrides": "--louise-color-text" },
    { "token": "--color-paper", "theme": "light", "value": "#fbf7f1", "overrides": "--louise-color-surface" },
    { "token": "--color-paper", "theme": "dark", "value": "#15181f", "overrides": "--louise-color-surface" },
    { "token": "--color-accent", "theme": "light", "value": "#b5542d", "overrides": "--louise-color-accent" },
    { "token": "--color-muted", "theme": "light", "value": "#6b7280", "overrides": "--louise-color-muted" },
    { "token": "--font-heading", "theme": "light", "value": "\"Jost\", system-ui, sans-serif" },
    { "token": "--space-section", "theme": "light", "value": "4rem" }
  ],
  "darkModeCoverage": "every color token has a dark value except --color-accent and --color-muted"
}
