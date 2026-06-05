# Modern Consultancy Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rework the existing Jekyll one-page site so Deep Native reads as a modern regulated-industry engineering delivery consultancy, with AML only as a representative proof point.

**Architecture:** Keep the existing data-first Jekyll structure. Update `_data/*.yml` for positioning and copy, adjust the section includes and navigation to the new one-page story, then modernize only `assets/css/dn-overrides.css` without rebuilding the inherited gulp assets.

**Tech Stack:** Jekyll via `github-pages`, Liquid includes, YAML data files, Bootstrap theme base, CSS overrides, Playwright smoke tests.

---

### Task 1: Update Behavior Tests First

**Files:**
- Modify: `tests/e2e/home.spec.ts`

- [ ] **Step 1: Write failing Playwright expectations**

Replace AML-first expectations with modern consultancy expectations:

```ts
test("hero headline positions Deep Native around regulated modernization", async ({ page }) => {
  await page.goto("/");
  await expect(page.locator("h1.dn-hero__headline")).toContainText(
    /regulated modernization/i
  );
  await expect(page.locator("h1.dn-hero__headline")).not.toContainText(/AML/i);
});

test("anchor nav targets all exist", async ({ page }) => {
  await page.goto("/");
  const anchors = ["#outcomes", "#capabilities", "#proof", "#engagement", "#contact"];
  for (const anchor of anchors) {
    const id = anchor.slice(1);
    await expect(page.locator(`section[id="${id}"]`)).toHaveCount(1);
  }
});

test("AML framework is proof content, not primary navigation", async ({ page }) => {
  await page.goto("/");
  await expect(page.locator('nav a[href$="#framework"]')).toHaveCount(0);
  await expect(page.locator("body")).toContainText(/AML Open Framework/i);
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx --yes playwright test tests/e2e/home.spec.ts`

Expected: FAIL because the current hero still mentions AML and the page still uses `#why`, `#delivery`, and `#procurement`.

### Task 2: Reposition Data and Section Flow

**Files:**
- Modify: `_data/site.yml`
- Modify: `_data/why.yml`
- Modify: `_data/capabilities.yml`
- Modify: `_data/credentials.yml`
- Modify: `index.html`
- Modify: `_includes/navigation.html`
- Modify: `_includes/header.html`
- Modify: `_includes/why.html`
- Modify: `_includes/credentials_table.html`
- Modify: `_includes/procurement.html`
- Modify: `_includes/contact_cta.html`
- Remove from page flow: `_includes/aml_framework.html`

- [ ] **Step 1: Update copy data**

Change hero headline to `Regulated modernization delivery, from strategy to shipped systems.` Change subhead to position Deep Native around cloud, data, AI, payments, platform, and product engineering. Keep Microsoft partner trust data.

Update why/outcomes entries to:

```yaml
- "Cloud-native modernization for regulated workloads"
- "Data and AI engineering tied to delivery outcomes"
- "Payments, platforms, and enterprise integration"
- "Onshore leadership with APAC delivery capacity"
- "Audit-aware delivery discipline without vendor lock-in"
```

Update capabilities around engineering pillars rather than AML job roles:

```yaml
- title: "Cloud modernization"
- title: "Data & AI engineering"
- title: "Application & product delivery"
- title: "Payments & integration"
- title: "Platform engineering & DevOps"
- title: "Delivery leadership"
```

- [ ] **Step 2: Update page composition and anchors**

Use this `index.html` include order:

```liquid
{% include trust_strip.html %}
{% include why.html %}
{% include capabilities.html %}
{% include credentials_table.html %}
{% include procurement.html %}
{% include contact_cta.html %}
```

Use visible nav anchors:

```liquid
<li><a href="{{ prefix }}#outcomes" class="js-scroll-trigger">Outcomes</a></li>
<li><a href="{{ prefix }}#capabilities" class="js-scroll-trigger">Capabilities</a></li>
<li><a href="{{ prefix }}#proof" class="js-scroll-trigger">Proof</a></li>
<li><a href="{{ prefix }}#engagement" class="js-scroll-trigger">Engagement</a></li>
<li><a href="{{ prefix }}#contact" class="js-scroll-trigger">Contact</a></li>
```

Rename section IDs in includes:

```html
<section ... id="outcomes">
<section ... id="proof">
<section ... id="engagement">
```

- [ ] **Step 3: Keep AML as a proof reference**

In `_data/credentials.yml`, keep anonymized regulated credentials and add one non-dominant `Ongoing` row for the AML Open Framework as an open reference/accelerator. Do not add real client names.

- [ ] **Step 4: Run focused tests**

Run: `npx --yes playwright test tests/e2e/home.spec.ts`

Expected: PASS for updated positioning, anchors, CTAs, external link shape, images, and no client-name leaks.

### Task 3: Modernize Visual Treatment

**Files:**
- Modify: `assets/css/dn-overrides.css`
- Modify as needed: `_includes/header.html`
- Modify as needed: `_includes/capabilities.html`
- Modify as needed: `_includes/procurement.html`
- Modify as needed: `_includes/contact_cta.html`

- [ ] **Step 1: Update CSS for a calmer enterprise page**

Implement these visual changes in `assets/css/dn-overrides.css`:

```css
:root {
  --dn-ink: #152033;
  --dn-muted: #5f6f84;
  --dn-line: #dde5ef;
  --dn-panel: #ffffff;
  --dn-soft: #f5f8fb;
  --dn-accent: #167a7f;
  --dn-accent-strong: #0f5e63;
  --dn-warm: #d9653b;
}
```

Use a light hero background, restrained accent CTA, compact cards, responsive spacing, and mobile-safe typography. Avoid one-hue dominance and avoid large decorative blobs.

- [ ] **Step 2: Verify in browser**

Run: `bundle exec jekyll serve --port 4000 --livereload`

Open `http://localhost:4000` in the in-app browser. Check desktop and a mobile-width viewport for:

- Hero text visible and not AML-led.
- Navigation anchors scroll to the right sections.
- Text does not overlap or overflow.
- Service/proof/engagement sections feel scannable.

### Task 4: Final Verification

**Files:**
- All modified production/test files

- [ ] **Step 1: Build**

Run: `bundle exec jekyll build --strict_front_matter --trace`

Expected: exit 0.

- [ ] **Step 2: E2E smoke**

Run: `npx --yes playwright test`

Expected: all tests pass.

- [ ] **Step 3: Review diff**

Run: `git diff -- _data/site.yml _data/why.yml _data/capabilities.yml _data/credentials.yml index.html _includes/navigation.html _includes/header.html _includes/why.html _includes/credentials_table.html _includes/procurement.html _includes/contact_cta.html assets/css/dn-overrides.css tests/e2e/home.spec.ts`

Expected: changes match the approved spec and do not disclose real client names.
