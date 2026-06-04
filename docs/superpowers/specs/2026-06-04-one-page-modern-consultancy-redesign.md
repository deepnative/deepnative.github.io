# Deep Native One-Page Modern Consultancy Redesign

Date: 2026-06-04

## Approved Direction

Deep Native should read as a modern regulated-industry engineering delivery
consultancy, not as an AML-first firm. The one-page site should lead with
cloud, data, AI, application modernization, platform engineering, payments, and
enterprise delivery. AML work and the AML Open Framework may appear as
representative references, but they must not drive the company profile.

## Assumptions

- Deep Native is a public site for regulated-industry buyers, so copy must stay
  conservative, procurement-safe, and commercially accurate.
- Client names remain anonymized in public files.
- Marketing copy remains data-first in `_data/*.yml`; Liquid templates compose
  data and avoid owning major marketing strings.
- The existing Jekyll/GitHub Pages stack remains in place. No new non-whitelisted
  Jekyll plugins are introduced.
- The gulp-compiled theme assets remain untouched; Deep Native-specific styling
  stays in `assets/css/dn-overrides.css`.

## Page Story

1. Hero: Position Deep Native as an accountable delivery partner for regulated
   modernization programs. The headline should not mention AML.
2. Trust strip: Keep Microsoft Solutions Partner and delivery model signals.
3. Outcomes: Replace AML-heavy "why" framing with outcomes such as modernization
   delivery, data/AI enablement, platform reliability, delivery governance, and
   regulated workload experience.
4. Capabilities: Present service pillars for cloud, data, AI, application
   engineering, platform/DevOps, payments, and delivery leadership.
5. Proof: Show anonymized delivery credentials as proof of regulated-industry
   execution. AML references can live here as one item among broader work.
6. Engagement: Keep simple paths for pilot/SOW and flexible team augmentation,
   but avoid making procurement language dominate the page.
7. Contact: Keep one direct inbox CTA and delivery-lead tone.

## Information Architecture

The site remains a single page composed from section includes in `index.html`.
Recommended visible nav anchors:

- `#outcomes`
- `#capabilities`
- `#proof`
- `#engagement`
- `#contact`

The current standalone `#framework` section should be removed or folded into the
proof area as a small reference. It should not appear in primary navigation.

## Visual Direction

Use an "Outcomes First" layout: a direct hero, restrained trust signals, compact
scannable sections, and proof rows. The site should feel current but still
appropriate for banks, insurers, and enterprise technology buyers.

Visual requirements:

- Calm enterprise palette with more neutral space and a restrained accent.
- Cleaner nav and tighter typography than the inherited theme.
- Fewer large decorative cards; use compact service/proof blocks.
- No heavy AML/security imagery as brand identity.
- No marketing splash page before the actual one-page content.
- Text must fit cleanly at mobile and desktop breakpoints.

## Data Model

Keep and adapt the existing data files:

- `_data/site.yml`: hero, trust, engagement/contact/footer, and any selected
  reference copy.
- `_data/why.yml`: rename or repurpose content toward modernization outcomes.
- `_data/capabilities.yml`: broaden service pillars beyond AML.
- `_data/credentials.yml`: keep anonymized delivery references; add or adjust
  AML references only as project proof, not headline positioning.

If a new data file meaningfully improves clarity, it may be added, but prefer
adapting the existing files first.

## Testing

Update Playwright smoke tests to match the new one-page story:

- Hero test should assert modern regulated delivery positioning instead of AML.
- Anchor test should cover the final section IDs.
- CTA tests should continue to assert `mailto:` and external link shapes.
- The no leaked client names test remains load-bearing.
- If new top-level sections are added, include them in
  `tests/e2e/home.spec.ts`.

Run at least:

- `bundle exec jekyll build --strict_front_matter --trace`
- `npx --yes playwright test`

Run broader `make ci-*` checks as time and local dependencies allow.

## Out of Scope

- Reintroducing blog, authors, pagination, Disqus, or removed theme plumbing.
- Publishing real client names.
- Adding new Jekyll plugins outside the GitHub Pages whitelist.
- Rebuilding the gulp/Sass asset pipeline.
