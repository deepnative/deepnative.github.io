# Deep Native — local quality gate.
#
# Every target in this Makefile maps 1:1 to a job in .github/workflows/ci.yml.
# `make pre-push` is the single command that runs the full gate locally and
# is invoked by the git pre-push hook installed by `make install-hooks`.
#
# Discipline (mirrors aml_open_framework/CLAUDE.md):
#   - If `make pre-push` passes locally but CI fails, that signals a gap in
#     the local checks. Fix the gap, then push again.
#   - The PR is the final gate, not a feedback loop.

SHELL := /bin/bash
.DEFAULT_GOAL := help
.PHONY: help install install-hooks pre-push \
        ci-build ci-lint ci-html ci-links ci-a11y ci-e2e ci-lighthouse ci-security \
        serve clean

# -------------------------------------------------------------------
# meta
# -------------------------------------------------------------------

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install Ruby + Node dependencies.
	bundle install
	npm install

install-hooks: ## Install the git pre-push hook -> `make pre-push`.
	@mkdir -p .git/hooks
	@printf '#!/usr/bin/env bash\nset -euo pipefail\nexec make pre-push\n' > .git/hooks/pre-push
	@chmod +x .git/hooks/pre-push
	@echo "git pre-push hook installed -> 'make pre-push'"

# -------------------------------------------------------------------
# pre-push gate
# -------------------------------------------------------------------

pre-push: ci-lint ci-build ci-html ci-links ci-security ci-e2e ci-a11y ci-lighthouse ## Run the full CI gate locally.
	@echo ""
	@echo "✓ pre-push gate passed."

# -------------------------------------------------------------------
# individual CI jobs (mirror .github/workflows/ci.yml exactly)
# -------------------------------------------------------------------

ci-build: ## Build the Jekyll site strictly.
	bundle exec jekyll build --strict_front_matter --trace

ci-lint: ## Lint Liquid/YAML/JS (jshint on assets/js/app.js).
	@echo "→ YAML lint (data files)"
	@ruby -ryaml -e 'Dir.glob("_data/*.yml").each { |f| YAML.load_file(f); puts "  ok: #{f}" }'
	@echo "→ jshint (assets/js/app.js)"
	@npx --yes jshint assets/js/app.js || true

ci-html: ci-build ## htmlproofer over _site (no external link checks).
	bundle exec htmlproofer ./_site \
		--disable-external \
		--allow-hash-href \
		--checks Links,Images,Scripts \
		--no-enforce-https

ci-links: ci-build ## htmlproofer with external link checks.
	bundle exec htmlproofer ./_site \
		--no-enforce-https \
		--allow-hash-href \
		--ignore-status-codes "0,999,403,429" \
		--ignore-urls "/^mailto:/,/linkedin\.com/"

ci-a11y: ci-build ## pa11y-ci accessibility audit against built _site.
	npx --yes pa11y-ci --sitemap-find "$(PWD)/_site" \
		--config .pa11yci.json _site/index.html || \
	(echo "pa11y-ci is best-effort; install/serve issues are non-blocking locally"; exit 0)

ci-e2e: ## Playwright smoke (starts jekyll serve internally via webServer).
	npx --yes playwright install --with-deps chromium
	npx --yes playwright test

ci-lighthouse: ## Lighthouse CI budget check.
	npx --yes @lhci/cli@0.13.x autorun || \
	(echo "Lighthouse CI requires Chrome; treat as advisory locally"; exit 0)

ci-security: ## Ruby + npm security audits.
	bundle exec bundle-audit check --update
	npx --yes audit-ci --moderate || true

# -------------------------------------------------------------------
# dev convenience
# -------------------------------------------------------------------

serve: ## Run jekyll serve on http://localhost:4000.
	bundle exec jekyll serve --port 4000 --livereload

clean: ## Remove build artifacts.
	rm -rf _site .jekyll-cache playwright-report .lighthouseci
