## Summary

<!-- 1–3 bullets on what changed and why. Link the source request / issue. -->

## Type

- [ ] feat
- [ ] fix
- [ ] chore
- [ ] docs

## Pre-push gate

- [ ] `make pre-push` passes locally
- [ ] `make ci-build` produces a `_site/index.html` with no Lorem Ipsum / template strings
- [ ] No real client names introduced to public files (see [CLAUDE.md §1.4](../CLAUDE.md))

## Tests

- [ ] Playwright smoke (`tests/e2e/home.spec.ts`) updated if a new section / CTA was added
- [ ] Forbidden-term list updated if a new name needs to be blocked

## Review

- [ ] Codex review (`/codex:review --base master`) reports no blockers
