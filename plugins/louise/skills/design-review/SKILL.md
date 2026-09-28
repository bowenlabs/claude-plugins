---
name: design-review
description: Runs the full design audit on a page, component, screenshot, or UI diff for a Louise / Astroid site, in a fixed order of audit skills, and merges them into one verdict with ranked fixes. Use when asked to review, critique, or audit the design, visual quality, accessibility, or UI of a page or change.
argument-hint: "[URL, file, screenshot, or diff]"
---

# Design review

Audit `$ARGUMENTS` (a URL, files, a screenshot, or a diff) by running the steps
below **in order**. Each step adds what the one before it lacks. Run every
step. When a step's skill isn't installed, do that step's check yourself from
its brief below, and mark it in the report as "run without `<skill>`". Never
skip a step silently.

Work out the site first: the repository you're in, or the one the URL belongs
to. Everything else uses it.

## 1. Context (Louise)

Call these on the Louise knowledge server and keep the results; later steps
use them:

- `get_design_system(<site repository>)`: the site's tokens, its overrides of
  the kit's theme, their values, and dark-mode coverage.
- `list_sections()`: the section catalog, so you can tell a catalog section
  from a hand-built one.
- `get_principles("<what the page is for>", "designer")`: the book guidance
  that applies, and whether it agrees with the house.

Then run the **token check**. It's the step the general-purpose skills can't
do, because only Louise knows the site's tokens:

1. Find every literal color (`#rgb`, `#rrggbb`, `#rrggbbaa`, `rgb()`, `rgba()`,
   `hsl()`, `oklch()`), font stack, and literal spacing in the files under
   review. For a URL, read the page's stylesheets and inline styles.
2. For each literal, look for a token whose resolved value matches it. Compare
   colors case-insensitively and expand three-digit hex.
3. A literal with a matching token is a finding: "`#1f2a44` in
   `src/components/Hero.astro:12` is `--color-ink`; use `var(--color-ink)`."
   A literal with no matching token is a smaller finding: it's either a new
   token or a mistake.
4. Tokens defined in theme CSS are the source of truth, not findings.

## 2. Critique

Run `design:design-critique` on the page. Its brief: hierarchy, usability, and
consistency. Give it the design system from step 1, so it judges against the
site's system rather than generic taste.

## 3. Guidelines

Run `louise:web-design-guidelines` against the files. Its brief: the Vercel
Web Interface Guidelines checklist, reported as `file:line` findings.

## 4. Accessibility

Run `design:accessibility-review`, and with a URL, AccessLint
(`accesslint:accessibility-scan` for one page, `accesslint:accessibility-audit`
for a site). Their brief: WCAG 2.1 AA; contrast, keyboard access, focus,
target size, and screen reader behavior. Check contrast against the token
values from step 1, in light and dark themes.

## 5. Copy

Run `design:ux-copy` on every visible string: buttons, labels, errors, and
empty states. Its brief: clear microcopy in the Google developer style. Call
`style_rules("ui")` for the house UI vocabulary and pass it along.

## 6. System

Run `ui-ux-pro-max:ui-ux-pro-max` for palette, type pairing, and layout rules.
When it suggests a change that conflicts with the site's design system, the
design system wins; record the suggestion only if it's a reason to change a
token.

## 7. Performance (only with a URL)

Run `cloudflare:web-perf` on the URL. Its brief: Core Web Vitals (LCP, INP,
CLS), render-blocking resources, and layout shifts. With no URL, record this
step as "not run: no URL".

## 8. Handoff (optional)

When the user asked for something to be built, run `design:design-handoff` for
a spec. Otherwise record "not requested".

## Report

Merge every step into one report. Don't paste each skill's output; combine
duplicates, and keep the strongest wording of each.

```markdown
## Design review: <page or change>

**Verdict:** ship | ship with fixes | needs rework. <one sentence on why>

### Fixes, ranked
1. **<what's wrong>**, at `<file:line or selector>`. <why it matters to the
   person using the page>. **Fix:** <the token, pattern, or change>.
   (<step>, <source or WCAG criterion>)

### Steps
| Step | Skill | Result |
| --- | --- | --- |
| 1. Context | Louise | <tokens read, N literals found, M with a matching token> |
| 2. Critique | design:design-critique | <N findings, or "run without design:design-critique"> |
| … | … | … |
```

Rank fixes by their effect on the person using the page: broken or
inaccessible first, then a literal where a token exists, then hierarchy and
copy, then polish.
