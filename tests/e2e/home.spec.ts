import { test, expect } from "@playwright/test";

test.describe("Deep Native landing page", () => {
  test("loads with no console errors", async ({ page }) => {
    const consoleErrors: string[] = [];
    page.on("console", (msg) => {
      if (msg.type() === "error") consoleErrors.push(msg.text());
    });
    await page.goto("/");
    await expect(page).toHaveTitle(/Deep Native/i);
    expect(consoleErrors, consoleErrors.join("\n")).toEqual([]);
  });

  test("hero headline positions Deep Native around regulated modernization", async ({ page }) => {
    await page.goto("/");
    await expect(page.locator("h1.dn-hero__headline")).toContainText(
      /regulated modernization/i
    );
    await expect(page.locator("h1.dn-hero__headline")).not.toContainText(/AML/i);
  });

  test("primary CTA opens a mailto", async ({ page }) => {
    await page.goto("/");
    const primary = page.locator(".dn-hero__ctas a.dn-cta-primary").first();
    await expect(primary).toHaveAttribute("href", /^mailto:info@deepnative\.io/);
  });

  test("AML Open Framework link points to GitHub", async ({ page }) => {
    await page.goto("/");
    const fwLinks = page.locator(
      'a[href="https://github.com/deepnative/aml_open_framework"]'
    );
    expect(await fwLinks.count()).toBeGreaterThan(0);
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

  test("credentials table has at least 6 rows", async ({ page }) => {
    await page.goto("/");
    const rows = page.locator(".dn-credentials tbody tr");
    expect(await rows.count()).toBeGreaterThanOrEqual(6);
  });

  test("no images have empty alt attributes", async ({ page }) => {
    await page.goto("/");
    const imagesMissingAlt = await page.locator("img:not([alt]), img[alt='']").count();
    expect(imagesMissingAlt).toBe(0);
  });

  test("no leaked client names appear on the public page", async ({ page }) => {
    await page.goto("/");
    const body = (await page.locator("body").innerText()).toLowerCase();
    for (const name of ["eq bank", "gore mutual", "lbc", "themeix", "lorem ipsum"]) {
      expect(body, `forbidden term: ${name}`).not.toContain(name);
    }
  });
});
