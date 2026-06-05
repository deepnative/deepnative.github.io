# AGENTS.md — Deep Native website

Behavioral and CI/CD standards for any agent (Codex, Codex, human) working in this repository. Modeled on the discipline in [`tomqwu/aml_open_framework/AGENTS.md`](https://github.com/tomqwu/aml_open_framework/blob/main/AGENTS.md). Where the source framework's rules are Python-specific, this file translates them to a Jekyll static site.

## 1. Behavioral standards

Before editing:

1. **State assumptions explicitly.** This site is the public face of a regulated-industry consultancy. Wrong copy has commercial and reputational consequences. When uncertain, halt and ask rather than guess.
2. **Prioritize simplicity.** Marketing copy lives in `_data/*.yml`. Liquid templates compose data — they do not contain marketing strings inline unless there's a clear reason. Each change must pass the question: *would this survive a procurement review?*
3. **Make surgical edits.** Modify only what the task requires. Match existing patterns. Flag unrelated issues without fixing them.
4. **No silent client-name disclosure.** The public site uses anonymized credentials (`Tier-1 Canadian Bank`, `Canadian P&C Insurer`). Real client names belong in NDA-gated materials only. If a new credential lands in `_data/credentials.yml`, it must be anonymized.

## 2. CI/CD discipline

The repository enforces a **pre-push validation** gate via `make pre-push`, which runs the same checks as `.github/workflows/ci.yml`. They map 1:1 by name:

| Target              | Purpose                                                    |
|---------------------|------------------------------------------------------------|
| `make ci-build`     | `jekyll build --strict_front_matter --trace`               |
| `make ci-lint`      | YAML schema check on `_data/*.yml` + jshint on JS          |
| `make ci-html`      | `htmlproofer` over `_site` (no external link checks)       |
| `make ci-links`     | `htmlproofer` external link checks (advisory)              |
| `make ci-a11y`      | `pa11y-ci` WCAG2AA audit                                   |
| `make ci-e2e`       | Playwright smoke (`tests/e2e/home.spec.ts`)                |
| `make ci-lighthouse`| Lighthouse CI budget (perf 85+, a11y 90+, SEO 90+)         |
| `make ci-security`  | `bundle-audit` + `audit-ci --moderate`                     |

Enable the git hook once per clone:

```bash
make install-hooks
```

**The PR is the final gate, not a feedback loop.** If `make pre-push` passes locally but CI fails, that signals a gap in the local checks — fix the gap before pushing again.

## 3. PR merge criteria

A PR may merge only when:

1. CI is green on the required jobs (`build`, `lint`, `html`, `a11y`, `e2e`, `security`). `links` and `lighthouse` are advisory.
2. GitHub reports the PR is mergeable (no conflicts).
3. Codex local review (`/codex:review --base master`) reports no blocking issues.
4. No unresolved review comments.

If Codex reports blockers: keep the PR open, fix issues, run relevant `make ci-*` checks, push follow-up commits, re-run review.

## 4. Jekyll standards

- **Minimum**: Jekyll provided by the `github-pages` gem (pinned in `Gemfile`). Do not introduce plugins outside the [GitHub Pages whitelist](https://pages.github.com/versions/) — they will silently no-op in production.
- **Data first**: marketing copy lives in `_data/site.yml`, `_data/capabilities.yml`, `_data/credentials.yml`, `_data/why.yml`. Templates render data; templates do not own copy.
- **Includes**: section-level (`_includes/<section>.html`) per landing-page section. Compose them in `index.html`.
- **CSS**: `assets/css/dn-overrides.css` for Deep Native styling. The gulp-compiled `app.min.css` stays as the Bootstrap/Owl/AOS base — do not rebuild the gulp pipeline in this iteration.

## 5. Testing rules

- Every new top-level section (`#<id>`) must be referenced by an anchor test in `tests/e2e/home.spec.ts`.
- New CTAs must have a test asserting their `href` shape.
- The "no leaked client names" test is load-bearing. If a new term needs to be forbidden, add it there.
- Tests requiring browser binaries assume `npx playwright install --with-deps chromium` has run.

## 6. Branching & commits

- Branches: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`, `docs/<slug>`.
- Commits: [Conventional Commits](https://www.conventionalcommits.org/) format. Example: `feat(landing): add procurement-options section`.
- Never force-push to `master`.
- Never bypass hooks (`--no-verify`) without explicit human sign-off.

## 7. Deployment

`master` deploys automatically via `.github/workflows/pages.yml` (`actions/deploy-pages@v4`) to `https://deepnative.io`. CI must be green before the deploy job runs (gate via branch protection).

## 8. What to delete vs keep

- Do **not** reintroduce blog/posts/authors/disqus/pagination plumbing without an explicit product decision. The blog template was removed in the initial refactor.
- Do **not** add real client names to public files. If a public case study is needed, treat it as a new plan.
