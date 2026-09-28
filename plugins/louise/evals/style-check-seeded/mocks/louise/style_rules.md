{
  "kind": "{{input.kind}}",
  "house": {
    "citation": "louise-toolkit:CLAUDE.md#documentation-style",
    "text": "Every doc and all prose in code follow the Google developer documentation style guide (ADR 0013). The details that trip people up:\n- Dashes: word—word, with no space on either side of the dash, in comments too.\n- Separators: a dash is only for sentences. Page titles use a pipe (Overview | Example Organization admin); items side by side use a middle dot (Jane Doe · Founder, an image's alt text, a button label with a price).\n- Contractions: use them (\"isn't,\" \"doesn't\").\n- Voice: second person and present tense, with no \"we,\" \"will,\" or \"simply.\"\n- Examples: use Google's example conventions as written: example.com domains, \"Example Organization\" for a company, names from Google's list (Alex, Kai, Quinn), 800-555-0100 through 0199 for phone numbers, and 192.0.2.0/24 for IP addresses. No real brands, characters, or pop-culture references; they don't translate, and a trademark in a sample can read as an endorsement."
  },
  "decision": {
    "title": "ADR 0013: Google developer style everywhere",
    "citation": "louise-toolkit:docs/adr/0013-google-style-everywhere.md@d76677c"
  },
  "google": ["Voice and tone", "Second person", "Present tense", "Active voice", "Headings", "Link text", "Code in text", "Example domains and names"],
  "check": "Run `corepack pnpm run lint:docs`: Vale with the Google package and the house package."
}
