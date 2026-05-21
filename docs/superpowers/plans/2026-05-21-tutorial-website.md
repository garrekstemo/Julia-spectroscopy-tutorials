# Tutorial Website Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the "Introduction to Julia for Spectroscopy" tutorial from a markdown-only repo into a published Astro Starlight website (EN + JA) styled to feel like garrek.org, deployed to GitHub Pages.

**Architecture:** Astro Starlight as the static site generator. Markdown chapters live under `src/content/docs/{en,ja}/chapters/`. Custom CSS in `src/styles/custom.css` overrides Starlight's design tokens to match garrek.org (Libre Baskerville body, Courier Prime sidebar, Courier Prime Code for code, blue/terracotta palette, distinctive link hover). Two Astro component overrides (`SiteTitle`, `PageTitle`) for typography. GitHub Actions builds and deploys to the `gh-pages` branch on every push to `main`.

**Tech Stack:** Node.js 20+, Astro 4.x, `@astrojs/starlight`, `remark-math`, `rehype-katex`, KaTeX, Shiki (bundled with Starlight), Pagefind (bundled). Deploys via `actions/deploy-pages`.

**Reference paths:**
- Tutorial repo (working dir): `/Users/garrek/Developer/Julia Tutorials/Intro to Julia for spectroscopy/`
- Personal site repo (style source): `/Users/garrek/Developer/garrek-org/`
- Spec: [`docs/superpowers/specs/2026-05-21-tutorial-website-design.md`](../specs/2026-05-21-tutorial-website-design.md)
- GitHub repo: `garrekstemo/Intro-to-Julia-for-spectroscopy`
- Deployed URL: `https://garrekstemo.github.io/Intro-to-Julia-for-spectroscopy/`

---

## Task 1: Initialize Astro + Starlight project in-place

**Files:**
- Create: `package.json`, `astro.config.mjs`, `tsconfig.json`, `src/`, `public/`, `.gitignore` entries

- [ ] **Step 1: Initialize package.json**

The working directory contains chapters/, ja/, etc. We're adding Astro alongside them. From the repo root:

```bash
npm init -y
```

- [ ] **Step 2: Install Astro + Starlight**

```bash
npm install astro @astrojs/starlight sharp
```

- [ ] **Step 3: Replace `package.json` scripts**

Edit `package.json` and replace the `scripts` block with:

```json
"scripts": {
  "dev": "astro dev",
  "start": "astro dev",
  "build": "astro build",
  "preview": "astro preview",
  "astro": "astro"
}
```

- [ ] **Step 4: Create initial astro.config.mjs**

Create `astro.config.mjs` at the repo root:

```js
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://garrekstemo.github.io',
  base: '/Intro-to-Julia-for-spectroscopy',
  integrations: [
    starlight({
      title: 'Intro to Julia for Spectroscopy',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy' },
      ],
    }),
  ],
});
```

- [ ] **Step 5: Create `tsconfig.json`**

```json
{
  "extends": "astro/tsconfigs/strict"
}
```

- [ ] **Step 6: Create `src/content/docs/index.md` placeholder**

So `astro dev` has something to render:

```markdown
---
title: Intro to Julia for Spectroscopy
---

Placeholder landing page. Real content lands in Task 12.
```

- [ ] **Step 7: Update `.gitignore`**

Append to the existing `.gitignore`:

```
# Astro
dist/
.astro/
node_modules/
```

- [ ] **Step 8: Verify dev server**

```bash
npm run dev
```

Expected: server starts at `http://localhost:4321/Intro-to-Julia-for-spectroscopy/`. Visit it and confirm the placeholder landing page renders. Kill with Ctrl-C.

- [ ] **Step 9: Commit**

```bash
git add package.json package-lock.json astro.config.mjs tsconfig.json src/content/docs/index.md .gitignore
git commit -m "Initialize Astro Starlight project"
```

---

## Task 2: Add fonts to public/fonts/

**Files:**
- Create: `public/fonts/Libre-Baskerville/*`, `public/fonts/Courier-Prime/*`, `public/fonts/Courier-Prime-Code/*`

- [ ] **Step 1: Create the fonts directory tree**

```bash
mkdir -p public/fonts/Libre-Baskerville public/fonts/Courier-Prime public/fonts/Courier-Prime-Code
```

- [ ] **Step 2: Copy Libre Baskerville from garrek-org**

```bash
cp -R "/Users/garrek/Developer/garrek-org/src/assets/fonts/Libre-Baskerville/." public/fonts/Libre-Baskerville/
ls public/fonts/Libre-Baskerville/
```

Expected: at least Regular, Italic, Bold variants.

- [ ] **Step 3: Copy Courier Prime from garrek-org**

```bash
cp -R "/Users/garrek/Developer/garrek-org/src/assets/fonts/Courier-Prime/." public/fonts/Courier-Prime/
ls public/fonts/Courier-Prime/
```

- [ ] **Step 4: Download Courier Prime Code (manual)**

Visit [quoteunquoteapps.com/courierprime](https://quoteunquoteapps.com/courierprime/) and download Courier Prime Code (the code-optimized variant). Place the `.ttf` files into `public/fonts/Courier-Prime-Code/`. Required variants: Regular, Italic, Bold, BoldItalic.

After downloading, verify:

```bash
ls public/fonts/Courier-Prime-Code/
```

Expected: 4 `.ttf` files named like `CourierPrimeCode-*.ttf`.

- [ ] **Step 5: Commit**

```bash
git add public/fonts
git commit -m "Add Libre Baskerville, Courier Prime, Courier Prime Code fonts"
```

---

## Task 3: Write base custom.css — fonts and color tokens

**Files:**
- Create: `src/styles/custom.css`
- Modify: `astro.config.mjs`

- [ ] **Step 1: Create `src/styles/custom.css`**

```css
/* ------------------------------------------------------------------ */
/* Font faces                                                          */
/* ------------------------------------------------------------------ */

@font-face {
  font-family: "Libre Baskerville";
  font-weight: 400;
  font-style: normal;
  font-display: swap;
  src: url("/Intro-to-Julia-for-spectroscopy/fonts/Libre-Baskerville/LibreBaskerville-Regular.ttf") format("truetype");
}
@font-face {
  font-family: "Libre Baskerville";
  font-weight: 400;
  font-style: italic;
  font-display: swap;
  src: url("/Intro-to-Julia-for-spectroscopy/fonts/Libre-Baskerville/LibreBaskerville-Italic.ttf") format("truetype");
}
@font-face {
  font-family: "Libre Baskerville";
  font-weight: 700;
  font-style: normal;
  font-display: swap;
  src: url("/Intro-to-Julia-for-spectroscopy/fonts/Libre-Baskerville/LibreBaskerville-Bold.ttf") format("truetype");
}

@font-face {
  font-family: "Courier Prime";
  font-weight: 400;
  font-style: normal;
  font-display: swap;
  src: url("/Intro-to-Julia-for-spectroscopy/fonts/Courier-Prime/CourierPrime-Regular.ttf") format("truetype");
}
@font-face {
  font-family: "Courier Prime";
  font-weight: 700;
  font-style: normal;
  font-display: swap;
  src: url("/Intro-to-Julia-for-spectroscopy/fonts/Courier-Prime/CourierPrime-Bold.ttf") format("truetype");
}

@font-face {
  font-family: "Courier Prime Code";
  font-weight: 400;
  font-style: normal;
  font-display: swap;
  src: url("/Intro-to-Julia-for-spectroscopy/fonts/Courier-Prime-Code/CourierPrimeCode-Regular.ttf") format("truetype");
}
@font-face {
  font-family: "Courier Prime Code";
  font-weight: 400;
  font-style: italic;
  font-display: swap;
  src: url("/Intro-to-Julia-for-spectroscopy/fonts/Courier-Prime-Code/CourierPrimeCode-Italic.ttf") format("truetype");
}
@font-face {
  font-family: "Courier Prime Code";
  font-weight: 700;
  font-style: normal;
  font-display: swap;
  src: url("/Intro-to-Julia-for-spectroscopy/fonts/Courier-Prime-Code/CourierPrimeCode-Bold.ttf") format("truetype");
}

/* ------------------------------------------------------------------ */
/* Starlight design-token overrides — typography and palette           */
/* ------------------------------------------------------------------ */

:root {
  /* Font stacks */
  --sl-font: "Libre Baskerville", Georgia, "Times New Roman", serif;
  --sl-font-system: "Libre Baskerville", Georgia, "Times New Roman", serif;
  --sl-font-system-mono: "Courier Prime Code", "Courier Prime", "Courier New", Courier, monospace;

  /* Layout */
  --sl-content-width: 50rem;       /* ~800px content column */
  --sl-sidebar-width: 11.25rem;    /* 180px sidebar */
  --sl-text-base: 1rem;
  --sl-line-height: 1.6;
}

/* Light theme — lifted from garrek-org/src/css/styles.css */
:root[data-theme="light"] {
  --sl-color-bg: #ffffff;
  --sl-color-bg-nav: #ffffff;
  --sl-color-bg-sidebar: #ffffff;
  --sl-color-text: #202020;
  --sl-color-text-accent: #1478d4;
  --sl-color-white: #000;
  --sl-color-gray-1: #202020;
  --sl-color-gray-2: #3b3b3b;
  --sl-color-gray-3: #4c4c4c;
  --sl-color-gray-4: #818181;
  --sl-color-gray-5: #e5e5e5;
  --sl-color-gray-6: #f8f9fa;
  --sl-color-accent: #2090e0;
  --sl-color-accent-low: #e5e5e5;
  --sl-color-accent-high: #1478d4;
  --sl-color-hover: #e05a3a;
  --sl-color-hr: #2090e0;
  --sl-color-code-bg: #fafafa;
  --sl-color-code-border: #e5e5e5;
}

/* Dark theme */
:root[data-theme="dark"] {
  --sl-color-bg: #15252b;
  --sl-color-bg-nav: #15252b;
  --sl-color-bg-sidebar: #15252b;
  --sl-color-text: #d0d0d0;
  --sl-color-text-accent: #5aafe6;
  --sl-color-white: #d4795a;
  --sl-color-gray-1: #e8e8e8;
  --sl-color-gray-2: #d0d0d0;
  --sl-color-gray-3: #b0b0b0;
  --sl-color-gray-4: #818181;
  --sl-color-gray-5: #2a3d44;
  --sl-color-gray-6: #1e3036;
  --sl-color-accent: #2090e0;
  --sl-color-accent-low: #2a3d44;
  --sl-color-accent-high: #5aafe6;
  --sl-color-hover: #e8734f;
  --sl-color-hr: #2090e0;
  --sl-color-code-bg: #1e3036;
  --sl-color-code-border: #2a3d44;
}
```

- [ ] **Step 2: Register custom.css in astro.config.mjs**

Edit `astro.config.mjs` — inside the `starlight({ ... })` call, add the `customCss` field:

```js
starlight({
  title: 'Intro to Julia for Spectroscopy',
  customCss: ['./src/styles/custom.css'],
  social: [
    { icon: 'github', label: 'GitHub', href: 'https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy' },
  ],
}),
```

- [ ] **Step 3: Restart dev server and verify**

```bash
npm run dev
```

Visit `http://localhost:4321/Intro-to-Julia-for-spectroscopy/`. Expected: body text now renders in Libre Baskerville serif. Background should be white (light) or `#15252b` (dark) depending on system preference.

Kill the server.

- [ ] **Step 4: Commit**

```bash
git add astro.config.mjs src/styles/custom.css
git commit -m "Add fonts and color tokens to custom.css"
```

---

## Task 4: Typography scale, link hover, layout overrides

**Files:**
- Modify: `src/styles/custom.css`

- [ ] **Step 1: Append typography + link + layout rules**

Append the following to `src/styles/custom.css`:

```css
/* ------------------------------------------------------------------ */
/* Typography scale (Major Third — 1.25 ratio)                        */
/* ------------------------------------------------------------------ */

body {
  font-family: var(--sl-font);
  font-size: var(--sl-text-base);
  line-height: var(--sl-line-height);
}

.sl-markdown-content h1,
.sl-markdown-content h2,
.sl-markdown-content h3,
.sl-markdown-content h4,
.sl-markdown-content h5,
.sl-markdown-content h6 {
  font-family: var(--sl-font);
}

.sl-markdown-content h1 { font-size: 2em; font-weight: 700; }
.sl-markdown-content h2 { font-size: 1.5em; line-height: 1.4; }
.sl-markdown-content h3 { font-size: 1.25em; margin-top: 1.5em; margin-bottom: 1em; }

/* ------------------------------------------------------------------ */
/* Link hover — distinctive thick-underline (from garrek.org)         */
/* ------------------------------------------------------------------ */

.sl-markdown-content a {
  color: var(--sl-color-text);
  text-decoration: underline;
  text-decoration-color: var(--sl-color-accent);
  text-decoration-thickness: 0.1em;
  text-underline-offset: 0.3em;
}

.sl-markdown-content a:hover {
  color: var(--sl-color-text);
  text-decoration-color: var(--sl-color-hover);
  text-decoration-thickness: 0.6em;
  text-underline-offset: -5px;
  text-decoration-skip-ink: none;
}

.sl-markdown-content h1 a,
.sl-markdown-content h2 a,
.sl-markdown-content h3 a {
  text-decoration: none;
}

/* ------------------------------------------------------------------ */
/* Sidebar — Courier Prime, right-aligned on desktop                  */
/* ------------------------------------------------------------------ */

starlight-sidebar nav,
.sidebar nav {
  font-family: "Courier Prime", "Courier New", Courier, monospace;
}

starlight-sidebar a,
.sidebar a {
  font-family: "Courier Prime", "Courier New", Courier, monospace;
  font-size: 1.05em;
  font-weight: 400;
}

/* ------------------------------------------------------------------ */
/* hr — blue 1px rule (from garrek.org)                                */
/* ------------------------------------------------------------------ */

.sl-markdown-content hr {
  height: 1px;
  width: 100%;
  border: 0;
  background-color: var(--sl-color-hr);
  margin-top: 3em;
  margin-bottom: 3em;
}
```

- [ ] **Step 2: Run dev server and verify**

```bash
npm run dev
```

Visit `http://localhost:4321/Intro-to-Julia-for-spectroscopy/`. Add some markdown link to `src/content/docs/index.md` if needed to inspect hover. Expected: hovering a link in body content gives the thick `0.6em` overlapping underline. Sidebar entries (just "Index" at this point) render in Courier Prime monospace.

Kill the server.

- [ ] **Step 3: Commit**

```bash
git add src/styles/custom.css
git commit -m "Add typography scale, link hover, sidebar font"
```

---

## Task 5: Math support — remark-math + rehype-katex

**Files:**
- Modify: `astro.config.mjs`
- Modify: `src/styles/custom.css`

- [ ] **Step 1: Install dependencies**

```bash
npm install remark-math rehype-katex katex
```

- [ ] **Step 2: Wire plugins into astro.config.mjs**

Edit `astro.config.mjs`. Add imports at the top:

```js
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
```

Add the `markdown` block at the top level of `defineConfig({...})`:

```js
export default defineConfig({
  site: 'https://garrekstemo.github.io',
  base: '/Intro-to-Julia-for-spectroscopy',
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  integrations: [
    starlight({
      // ... existing config
    }),
  ],
});
```

- [ ] **Step 3: Import KaTeX CSS into custom.css**

Prepend to `src/styles/custom.css` (before the `@font-face` block):

```css
@import "katex/dist/katex.min.css";
```

- [ ] **Step 4: Add a math sample to the placeholder index**

Edit `src/content/docs/index.md`:

```markdown
---
title: Intro to Julia for Spectroscopy
---

Inline math: $E = mc^2$.

Display math:

$$
\hat{H} \psi = E \psi
$$
```

- [ ] **Step 5: Run dev server and verify**

```bash
npm run dev
```

Visit the index page. Expected: $E = mc^2$ renders inline with proper math typography. The display equation centers on its own line. No raw `$` characters visible.

Kill the server.

- [ ] **Step 6: Commit**

```bash
git add package.json package-lock.json astro.config.mjs src/styles/custom.css src/content/docs/index.md
git commit -m "Add math support (remark-math + rehype-katex)"
```

---

## Task 6: Configure code block styling and Shiki themes

**Files:**
- Modify: `astro.config.mjs`
- Modify: `src/styles/custom.css`

- [ ] **Step 1: Set Shiki themes in astro.config.mjs**

Inside the `markdown` block of `astro.config.mjs`, add:

```js
markdown: {
  remarkPlugins: [remarkMath],
  rehypePlugins: [rehypeKatex],
  shikiConfig: {
    themes: {
      light: 'min-light',
      dark: 'min-dark',
    },
  },
},
```

- [ ] **Step 2: Append code-block CSS to custom.css**

Append to `src/styles/custom.css`:

```css
/* ------------------------------------------------------------------ */
/* Code blocks and inline code                                         */
/* ------------------------------------------------------------------ */

.sl-markdown-content code {
  font-family: var(--sl-font-system-mono);
  font-size: 0.95em;
}

.sl-markdown-content :not(pre) > code {
  /* inline code — no decoration, just the monospace font */
  background: transparent;
  padding: 0 0.1em;
}

.sl-markdown-content pre {
  font-family: var(--sl-font-system-mono);
  font-size: 0.95em;
  line-height: 1.6;
  padding: 1em 1.25em;
  border: 1px solid var(--sl-color-code-border);
  border-radius: 8px;
  background-color: var(--sl-color-code-bg);
  overflow: auto;
}

.sl-markdown-content pre code {
  background: transparent;
  font-size: inherit;
}
```

- [ ] **Step 3: Add a Julia sample to the placeholder index**

Append to `src/content/docs/index.md`:

````markdown

A Julia sample:

```julia
function lorentzian(p, x)
    A, x0, gamma = p
    @. A * gamma^2 / ((x - x0)^2 + gamma^2)
end
```
````

- [ ] **Step 4: Run dev server and verify**

```bash
npm run dev
```

Expected: the code block renders in Courier Prime Code with a faint background, 1px border, 8px radius. Syntax theming is muted (mostly weight/italic, barely any color). Hovering the block reveals a copy button at the top-right.

If the `min-*` themes feel too quiet, swap to `'github-light'` / `'github-dark'` in Step 1 and revisit.

Kill the server.

- [ ] **Step 5: Commit**

```bash
git add astro.config.mjs src/styles/custom.css src/content/docs/index.md
git commit -m "Configure Shiki min-light/min-dark and code block styling"
```

---

## Task 7: Component override — SiteTitle

**Files:**
- Create: `src/components/SiteTitle.astro`
- Modify: `astro.config.mjs`

- [ ] **Step 1: Create the component**

Create `src/components/SiteTitle.astro`:

```astro
---
const { siteTitle, siteTitleHref } = Astro.locals.starlightRoute;
---
<a href={siteTitleHref} class="site-title">{siteTitle}</a>

<style>
  .site-title {
    font-family: "Libre Baskerville", Georgia, "Times New Roman", serif;
    font-size: 1.6em;
    font-weight: 400;
    text-decoration: none;
    color: var(--sl-color-text);
    display: inline-block;
  }
  .site-title:hover {
    text-decoration: none;
  }
</style>
```

`Astro.locals.starlightRoute.siteTitle` and `siteTitleHref` are provided by Starlight on every route. They handle locale-correct linking automatically.

- [ ] **Step 2: Register the override in astro.config.mjs**

Inside `starlight({...})`, add:

```js
starlight({
  // ... existing fields
  components: {
    SiteTitle: './src/components/SiteTitle.astro',
  },
  customCss: ['./src/styles/custom.css'],
  // ...
}),
```

- [ ] **Step 3: Verify**

```bash
npm run dev
```

Site title in the top-left should render in Libre Baskerville at 1.6em, matching garrek.org's `.site-title`. Kill the server.

- [ ] **Step 4: Commit**

```bash
git add src/components/SiteTitle.astro astro.config.mjs
git commit -m "Override SiteTitle with Libre Baskerville"
```

---

## Task 8: Component override — PageTitle

**Files:**
- Create: `src/components/PageTitle.astro`
- Modify: `astro.config.mjs`

- [ ] **Step 1: Create the component**

Create `src/components/PageTitle.astro`:

```astro
---
const { entry } = Astro.locals.starlightRoute;
---
<h1 class="page-title">{entry.data.title}</h1>

<style>
  .page-title {
    font-family: "Libre Baskerville", Georgia, "Times New Roman", serif;
    font-size: 2em;
    font-weight: 700;
    line-height: 1.2;
    margin: 0 0 0.5em 0;
    color: var(--sl-color-white);
  }
</style>
```

- [ ] **Step 2: Register the override**

In `astro.config.mjs`, extend the `components` object:

```js
components: {
  SiteTitle: './src/components/SiteTitle.astro',
  PageTitle: './src/components/PageTitle.astro',
},
```

- [ ] **Step 3: Verify**

```bash
npm run dev
```

Page title h1 should now render in Libre Baskerville at 2em, weight 700. Headings in dark mode should pick up the terracotta `#d4795a` from `--sl-color-white` (Starlight uses that token for headings).

- [ ] **Step 4: Commit**

```bash
git add src/components/PageTitle.astro astro.config.mjs
git commit -m "Override PageTitle with Libre Baskerville h1"
```

---

## Task 9: Configure i18n locales

**Files:**
- Modify: `astro.config.mjs`
- Create: `src/content/docs/en/index.md` (move from `src/content/docs/index.md`)
- Create: `src/content/docs/ja/index.md`

- [ ] **Step 1: Move the placeholder index under en/**

```bash
mkdir -p src/content/docs/en src/content/docs/ja
git mv src/content/docs/index.md src/content/docs/en/index.md
```

- [ ] **Step 2: Create a JA placeholder**

Create `src/content/docs/ja/index.md`:

```markdown
---
title: 分光のためのJulia入門
---

仮の日本語ランディングページです。Task 16で本物に差し替えます。
```

- [ ] **Step 3: Configure locales in astro.config.mjs**

Inside `starlight({...})`, add:

```js
starlight({
  title: 'Intro to Julia for Spectroscopy',
  defaultLocale: 'en',
  locales: {
    en: { label: 'English' },
    ja: { label: '日本語' },
  },
  components: { /* ... existing ... */ },
  customCss: ['./src/styles/custom.css'],
  social: [ /* ... existing ... */ ],
}),
```

- [ ] **Step 4: Verify**

```bash
npm run dev
```

Expected URLs:
- `http://localhost:4321/Intro-to-Julia-for-spectroscopy/` → redirects to `/en/`
- `http://localhost:4321/Intro-to-Julia-for-spectroscopy/en/` → EN placeholder
- `http://localhost:4321/Intro-to-Julia-for-spectroscopy/ja/` → JA placeholder

A language switcher should appear in the header. Clicking it on `/en/` should take you to `/ja/`.

Kill the server.

- [ ] **Step 5: Commit**

```bash
git add astro.config.mjs src/content/docs/
git commit -m "Configure EN + JA locales and placeholder landing pages"
```

---

## Task 10: Move images to public/

**Files:**
- Move: `images/*` → `public/images/*`

- [ ] **Step 1: Rename "vacant cavity.png" to remove the space**

```bash
git mv "images/vacant cavity.png" "images/vacant_cavity.png"
```

- [ ] **Step 2: Move the entire images directory under public/**

```bash
mkdir -p public
git mv images public/images
ls public/images/
```

Expected: 16 PNG files in `public/images/`.

- [ ] **Step 3: Commit**

```bash
git commit -m "Move images to public/ for site serving"
```

---

## Task 11: Migrate EN landing page from ReadMe.md

**Files:**
- Modify: `src/content/docs/en/index.md`

- [ ] **Step 1: Read ReadMe.md**

```bash
cat ReadMe.md
```

- [ ] **Step 2: Rewrite `src/content/docs/en/index.md`**

Replace its contents with (adapt from ReadMe.md — keep the schedule table, drop GitHub-repo-only paragraphs):

```markdown
---
title: Intro to Julia for Spectroscopy
---

This short course introduces students to the Julia programming language applied to spectroscopy data analysis. It is intended for students who have never programmed before, or who have only done a little programming in another language.

The course covers programming fundamentals (Chapters 1–6) and data analysis and visualization (Chapters 7–10). Tested with Julia 1.12.

## How the course is organized

Lessons include short in-class exercises and longer take-home problems, organized by chapter. The code that generates figures is in the [`generate_images`](https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/tree/main/generate_images) directory of the source repository. Data for exercises is in [`data`](https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/tree/main/data).

The corresponding experimental tutorials are at [Optics Tutorials](https://github.com/garrekstemo/Optics-Tutorials).

## Recommended pace

Chapters 1 through 6 cover programming fundamentals — ideally two weeks with about one hour of class per chapter and 2–3 hours of homework per week.

Chapters 7 through 10 cover data analysis and visualization — about one week, depending on depth.

### Example schedule

#### Week 1
| Day | Chapter | Topics |
|-----|---------|--------|
| Monday | Ch 1: Introduction to Julia | Installation, files, folders, environments |
| Wednesday | Ch 2: Variables, operators, and types | Variables, basic operations, types, strings |
| Friday | Ch 3: Conditionals | Boolean expressions, comparison operators, logic, if/else |

#### Week 2
| Day | Chapter | Topics |
|-----|---------|--------|
| Monday | Ch 4: Iteration | while and for loops |
| Wednesday | Ch 5: Functions | Built-in functions, user-defined functions, assignment form |
| Friday | Ch 6: Arrays | Indexing, slicing, range objects, multi-dimensional arrays, broadcasting, comprehensions |

#### Week 3
| Day | Chapter | Topics |
|-----|---------|--------|
| Monday | Review Ch 1–6 | Variables, conditionals, iteration, arrays, functions |
| Wednesday | Ch 7: Plotting | Basic plotting with Makie.jl |
| Friday | Ch 8: Fitting | Least squares fitting with CurveFit.jl |

#### Week 4
| Day | Chapter | Topics |
|-----|---------|--------|
| Monday | Ch 9: Fourier transform | FT basics with FFTW.jl |
| Wednesday | Ch 10: Transfer matrix | Thin-film optics with TransferMatrix.jl |
| Friday | Review Ch 7–10 | Plotting, fitting, Fourier transforms, transfer matrix |
```

- [ ] **Step 3: Verify**

```bash
npm run dev
```

Visit `/en/`. Confirm the landing page renders with table, headings, links.

- [ ] **Step 4: Commit**

```bash
git add src/content/docs/en/index.md
git commit -m "Write EN landing page"
```

---

## Task 12: Migrate EN chapters

**Files:**
- Move: `chapters/*.md` → `src/content/docs/en/chapters/*.md`

**Filename mapping:**

| Original | New |
|---|---|
| `chapters/01. Introduction.md` | `src/content/docs/en/chapters/01-introduction.md` |
| `chapters/02. Variables, operators, and types.md` | `src/content/docs/en/chapters/02-variables-operators-types.md` |
| `chapters/03. Conditionals.md` | `src/content/docs/en/chapters/03-conditionals.md` |
| `chapters/04. Iteration.md` | `src/content/docs/en/chapters/04-iteration.md` |
| `chapters/05. Functions.md` | `src/content/docs/en/chapters/05-functions.md` |
| `chapters/06. Arrays.md` | `src/content/docs/en/chapters/06-arrays.md` |
| `chapters/07. Plotting.md` | `src/content/docs/en/chapters/07-plotting.md` |
| `chapters/08. Fitting.md` | `src/content/docs/en/chapters/08-fitting.md` |
| `chapters/09. Fourier transform.md` | `src/content/docs/en/chapters/09-fourier-transform.md` |
| `chapters/10. Transfer matrix.md` | `src/content/docs/en/chapters/10-transfer-matrix.md` |

**Title mapping** (insert as the value of `title:` in each file's frontmatter):

| File | Title |
|---|---|
| `01-introduction.md` | `Introduction` |
| `02-variables-operators-types.md` | `Variables, operators, and types` |
| `03-conditionals.md` | `Conditionals` |
| `04-iteration.md` | `Iteration` |
| `05-functions.md` | `Functions` |
| `06-arrays.md` | `Arrays` |
| `07-plotting.md` | `Plotting` |
| `08-fitting.md` | `Fitting` |
| `09-fourier-transform.md` | `Fourier transform` |
| `10-transfer-matrix.md` | `Transfer matrix` |

- [ ] **Step 1: Create target directory and git-move files**

```bash
mkdir -p src/content/docs/en/chapters

git mv "chapters/01. Introduction.md" src/content/docs/en/chapters/01-introduction.md
git mv "chapters/02. Variables, operators, and types.md" src/content/docs/en/chapters/02-variables-operators-types.md
git mv "chapters/03. Conditionals.md" src/content/docs/en/chapters/03-conditionals.md
git mv "chapters/04. Iteration.md" src/content/docs/en/chapters/04-iteration.md
git mv "chapters/05. Functions.md" src/content/docs/en/chapters/05-functions.md
git mv "chapters/06. Arrays.md" src/content/docs/en/chapters/06-arrays.md
git mv "chapters/07. Plotting.md" src/content/docs/en/chapters/07-plotting.md
git mv "chapters/08. Fitting.md" src/content/docs/en/chapters/08-fitting.md
git mv "chapters/09. Fourier transform.md" src/content/docs/en/chapters/09-fourier-transform.md
git mv "chapters/10. Transfer matrix.md" src/content/docs/en/chapters/10-transfer-matrix.md

rmdir chapters
```

- [ ] **Step 2: For each chapter, add frontmatter and remove the leading `# Heading`**

For each file in the table above:
1. Open it
2. Prepend the YAML frontmatter block:

```yaml
---
title: <Title from the title mapping>
---

```

3. Delete the original `# Heading` line (and any blank line immediately after) since `title:` now provides it
4. Save

Concrete example for `src/content/docs/en/chapters/01-introduction.md` — top should look like:

```markdown
---
title: Introduction
---

Welcome to the world of programming with Julia!
...
```

(Where `Welcome to...` is what used to follow `# Introduction`.)

- [ ] **Step 3: Rewrite image paths in all chapters**

Image refs change from `../images/foo.png` to `/Intro-to-Julia-for-spectroscopy/images/foo.png` (absolute with base prefix). Also handle the renamed `vacant cavity.png` → `vacant_cavity.png` if any chapter referenced it.

Run a single sed pass:

```bash
cd src/content/docs/en/chapters

# Rewrite relative image paths to absolute
for f in *.md; do
  sed -i '' 's|](\.\./images/|](/Intro-to-Julia-for-spectroscopy/images/|g' "$f"
  sed -i '' 's|/images/vacant cavity\.png|/images/vacant_cavity.png|g' "$f"
done

cd -
```

- [ ] **Step 4: Verify image rewrites**

```bash
grep -rn "../images" src/content/docs/en/chapters/
```

Expected: no matches (zero remaining `../images/` references).

```bash
grep -rn "/Intro-to-Julia-for-spectroscopy/images/" src/content/docs/en/chapters/ | head
```

Expected: several matches showing the rewritten paths.

- [ ] **Step 5: Verify dev server renders chapters**

```bash
npm run dev
```

Visit each chapter URL — at minimum spot-check:
- `/en/chapters/01-introduction/`
- `/en/chapters/07-plotting/` (verify images render)
- `/en/chapters/08-fitting/` (verify math renders)
- `/en/chapters/09-fourier-transform/`

For each, confirm: title displays in Libre Baskerville, body text in serif, images load, math renders, code blocks render.

- [ ] **Step 6: Commit**

```bash
git add src/content/docs/en/chapters
git commit -m "Migrate EN chapters into Starlight content tree"
```

---

## Task 13: Fix cross-chapter links in EN chapters

**Files:**
- Modify: any `src/content/docs/en/chapters/*.md` containing inter-chapter links

- [ ] **Step 1: Find cross-references**

```bash
grep -rn "\.md)" src/content/docs/en/chapters/ | grep -v "Project\.toml\|\.jl"
```

Expected output: a list of links that point at the old `NN. Chapter Name.md` format. Examples to expect:

```
src/content/docs/en/chapters/02-variables-operators-types.md:NNN:... [Chapter 1](01. Introduction.md) ...
```

If output is empty, skip to Step 3.

- [ ] **Step 2: Rewrite each cross-reference**

For each match, rewrite the link target to the new slug, **without** the `.md` extension and as a relative path. Mapping is the same as the filename mapping in Task 12.

Example: `[Chapter 1](01. Introduction.md)` → `[Chapter 1](./01-introduction/)`

Do this with a sed pass:

```bash
cd src/content/docs/en/chapters

sed -i '' 's|](01\. Introduction\.md)|](./01-introduction/)|g' *.md
sed -i '' 's|](02\. Variables, operators, and types\.md)|](./02-variables-operators-types/)|g' *.md
sed -i '' 's|](03\. Conditionals\.md)|](./03-conditionals/)|g' *.md
sed -i '' 's|](04\. Iteration\.md)|](./04-iteration/)|g' *.md
sed -i '' 's|](05\. Functions\.md)|](./05-functions/)|g' *.md
sed -i '' 's|](06\. Arrays\.md)|](./06-arrays/)|g' *.md
sed -i '' 's|](07\. Plotting\.md)|](./07-plotting/)|g' *.md
sed -i '' 's|](08\. Fitting\.md)|](./08-fitting/)|g' *.md
sed -i '' 's|](09\. Fourier transform\.md)|](./09-fourier-transform/)|g' *.md
sed -i '' 's|](10\. Transfer matrix\.md)|](./10-transfer-matrix/)|g' *.md

cd -
```

- [ ] **Step 3: Verify**

```bash
grep -rn "\.md)" src/content/docs/en/chapters/
```

Expected: no remaining `.md)` matches that point at chapter files. (External links like `Project.toml` or `.jl` are fine.)

Run dev server and click a cross-chapter link to confirm it navigates correctly:

```bash
npm run dev
```

- [ ] **Step 4: Commit**

```bash
git add src/content/docs/en/chapters
git commit -m "Fix cross-chapter links in EN chapters"
```

---

## Task 14: Configure the sidebar in astro.config.mjs

**Files:**
- Modify: `astro.config.mjs`

- [ ] **Step 1: Add sidebar config**

Inside `starlight({...})`, add the `sidebar` field:

```js
starlight({
  title: 'Intro to Julia for Spectroscopy',
  defaultLocale: 'en',
  locales: {
    en: { label: 'English' },
    ja: { label: '日本語' },
  },
  sidebar: [
    {
      label: 'Chapters',
      translations: { ja: '章' },
      items: [
        { slug: 'chapters/01-introduction' },
        { slug: 'chapters/02-variables-operators-types' },
        { slug: 'chapters/03-conditionals' },
        { slug: 'chapters/04-iteration' },
        { slug: 'chapters/05-functions' },
        { slug: 'chapters/06-arrays' },
        { slug: 'chapters/07-plotting' },
        { slug: 'chapters/08-fitting' },
        { slug: 'chapters/09-fourier-transform' },
        { slug: 'chapters/10-transfer-matrix' },
      ],
    },
  ],
  // ... rest of config (components, customCss, social) ...
}),
```

- [ ] **Step 2: Verify**

```bash
npm run dev
```

Sidebar should list all 10 chapters under "Chapters" (or "章" when switched to JA — once JA chapter files exist; for now JA sidebar will show the EN slugs but localised section label).

Kill the server.

- [ ] **Step 3: Commit**

```bash
git add astro.config.mjs
git commit -m "Configure 10-chapter sidebar"
```

---

## Task 15: Migrate JA landing page

**Files:**
- Modify: `src/content/docs/ja/index.md`

- [ ] **Step 1: Read the existing JA ReadMe.md**

```bash
cat ja/ReadMe.md
```

- [ ] **Step 2: Rewrite `src/content/docs/ja/index.md`**

Replace its contents with:

```markdown
---
title: 分光学のための Julia 入門
---

この短期講座は、分光学のデータ解析に応用するという観点から、Julia プログラミング言語を学生に紹介します。プログラミングがまったく初めての学生、あるいは他言語で少しだけプログラミング経験のある学生を想定しています。

第 1 章から第 6 章までがプログラミングの基礎、第 7 章から第 10 章までがデータ解析と可視化を扱います。動作確認済み Julia バージョン: 1.12。

## この講座の構成

レッスンには授業中に行う短い演習と、授業外で取り組む長めの問題が含まれています。図を生成するコードは [`generate_images`](https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/tree/main/generate_images) にあります。演習用データは [`data`](https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/tree/main/data) にあります。

対応する実験チュートリアルは [Optics Tutorials](https://github.com/garrekstemo/Optics-Tutorials) にあります。

## 推奨される進め方

第 1 章から第 6 章はプログラミングの基礎を扱います。1 章あたり授業時間約 1 時間、週 2-3 時間の宿題を想定し、2 週間程度で進めるのが理想です。

第 7 章から第 10 章はデータ解析と可視化を扱います。内容の掘り下げ具合にもよりますが、約 1 週間で進められます。

### 講義スケジュール例

#### 第 1 週
| 曜日 | 章 | トピック |
|-----|---------|--------|
| 月曜 | 第 1 章: Julia 入門 | インストール、ファイル、フォルダ、環境 |
| 水曜 | 第 2 章: 変数、演算子、型 | 変数、基本演算、型、文字列 |
| 金曜 | 第 3 章: 条件分岐 | ブール式、比較演算子、論理、if/else 文 |

#### 第 2 週
| 曜日 | 章 | トピック |
|-----|---------|--------|
| 月曜 | 第 4 章: 反復処理 | while ループと for ループ |
| 水曜 | 第 5 章: 関数 | 組み込み関数、ユーザー定義関数、代入形式 |
| 金曜 | 第 6 章: 配列 | インデックス、スライス、範囲オブジェクト、多次元配列、ブロードキャスト、内包表記 |

#### 第 3 週
| 曜日 | 章 | トピック |
|-----|---------|--------|
| 月曜 | 第 1-6 章の復習 | 変数、条件分岐、反復処理、配列、関数 |
| 水曜 | 第 7 章: プロット | Makie.jl による基本的なプロット |
| 金曜 | 第 8 章: フィッティング | CurveFit.jl による最小二乗フィッティング |

#### 第 4 週
| 曜日 | 章 | トピック |
|-----|---------|--------|
| 月曜 | 第 9 章: フーリエ変換 | フーリエ変換の基本と FFTW.jl |
| 水曜 | 第 10 章: 転送行列 | TransferMatrix.jl による薄膜光学 |
| 金曜 | 第 7-10 章の復習 | プロット、フィッティング、フーリエ変換、転送行列 |
```

- [ ] **Step 3: Verify**

```bash
npm run dev
```

Visit `/ja/`. Confirm the JA landing renders with the table and headings.

- [ ] **Step 4: Commit**

```bash
git add src/content/docs/ja/index.md
git commit -m "Write JA landing page"
```

---

## Task 16: Migrate JA chapters

**Files:**
- Move: `ja/chapters/*.md` → `src/content/docs/ja/chapters/*.md`

**Filename mapping** (JA filenames take the EN slug; the JA title goes in frontmatter):

| Original | New | `title:` value |
|---|---|---|
| `ja/chapters/01. はじめに.md` | `src/content/docs/ja/chapters/01-introduction.md` | `はじめに` |
| `ja/chapters/02. 変数、演算子、型.md` | `src/content/docs/ja/chapters/02-variables-operators-types.md` | `変数、演算子、型` |
| `ja/chapters/03. 条件分岐.md` | `src/content/docs/ja/chapters/03-conditionals.md` | `条件分岐` |
| `ja/chapters/04. 反復処理.md` | `src/content/docs/ja/chapters/04-iteration.md` | `反復処理` |
| `ja/chapters/05. 関数.md` | `src/content/docs/ja/chapters/05-functions.md` | `関数` |
| `ja/chapters/06. 配列.md` | `src/content/docs/ja/chapters/06-arrays.md` | `配列` |
| `ja/chapters/07. プロット.md` | `src/content/docs/ja/chapters/07-plotting.md` | `プロット` |
| `ja/chapters/08. フィッティング.md` | `src/content/docs/ja/chapters/08-fitting.md` | `フィッティング` |
| `ja/chapters/09. フーリエ変換.md` | `src/content/docs/ja/chapters/09-fourier-transform.md` | `フーリエ変換` |
| `ja/chapters/10. 転送行列.md` | `src/content/docs/ja/chapters/10-transfer-matrix.md` | `転送行列` |

- [ ] **Step 1: Create target dir and git-move files**

```bash
mkdir -p src/content/docs/ja/chapters

git mv "ja/chapters/01. はじめに.md" src/content/docs/ja/chapters/01-introduction.md
git mv "ja/chapters/02. 変数、演算子、型.md" src/content/docs/ja/chapters/02-variables-operators-types.md
git mv "ja/chapters/03. 条件分岐.md" src/content/docs/ja/chapters/03-conditionals.md
git mv "ja/chapters/04. 反復処理.md" src/content/docs/ja/chapters/04-iteration.md
git mv "ja/chapters/05. 関数.md" src/content/docs/ja/chapters/05-functions.md
git mv "ja/chapters/06. 配列.md" src/content/docs/ja/chapters/06-arrays.md
git mv "ja/chapters/07. プロット.md" src/content/docs/ja/chapters/07-plotting.md
git mv "ja/chapters/08. フィッティング.md" src/content/docs/ja/chapters/08-fitting.md
git mv "ja/chapters/09. フーリエ変換.md" src/content/docs/ja/chapters/09-fourier-transform.md
git mv "ja/chapters/10. 転送行列.md" src/content/docs/ja/chapters/10-transfer-matrix.md
```

- [ ] **Step 2: Add frontmatter and remove leading `# 見出し` for each JA chapter**

For each file in the mapping table above, open it and:
1. Prepend the YAML frontmatter using the title from the third column
2. Delete the original Japanese `# 見出し` line and any blank line after it

Example for `src/content/docs/ja/chapters/01-introduction.md`:

```markdown
---
title: はじめに
---

<body — Japanese content starts here>
```

- [ ] **Step 3: Rewrite image paths and cross-references in JA chapters**

JA chapter files reference images via `../../images/foo.png` (because they were two levels deep under `ja/chapters/`). After migration they live under `src/content/docs/ja/chapters/`, but image paths must become absolute under the site base.

```bash
cd src/content/docs/ja/chapters

# Rewrite both possible relative depths to absolute paths
for f in *.md; do
  sed -i '' 's|](\.\./\.\./images/|](/Intro-to-Julia-for-spectroscopy/images/|g' "$f"
  sed -i '' 's|](\.\./images/|](/Intro-to-Julia-for-spectroscopy/images/|g' "$f"
  sed -i '' 's|/images/vacant cavity\.png|/images/vacant_cavity.png|g' "$f"
done

# Rewrite cross-chapter links (Japanese filenames → English slugs)
sed -i '' 's|](01\. はじめに\.md)|](./01-introduction/)|g' *.md
sed -i '' 's|](02\. 変数、演算子、型\.md)|](./02-variables-operators-types/)|g' *.md
sed -i '' 's|](03\. 条件分岐\.md)|](./03-conditionals/)|g' *.md
sed -i '' 's|](04\. 反復処理\.md)|](./04-iteration/)|g' *.md
sed -i '' 's|](05\. 関数\.md)|](./05-functions/)|g' *.md
sed -i '' 's|](06\. 配列\.md)|](./06-arrays/)|g' *.md
sed -i '' 's|](07\. プロット\.md)|](./07-plotting/)|g' *.md
sed -i '' 's|](08\. フィッティング\.md)|](./08-fitting/)|g' *.md
sed -i '' 's|](09\. フーリエ変換\.md)|](./09-fourier-transform/)|g' *.md
sed -i '' 's|](10\. 転送行列\.md)|](./10-transfer-matrix/)|g' *.md

cd -
```

- [ ] **Step 4: Verify no broken refs remain**

```bash
grep -rn "../images" src/content/docs/ja/chapters/
grep -rn "\.md)" src/content/docs/ja/chapters/ | grep -v "Project\.toml\|\.jl"
```

Expected: both produce no matches.

- [ ] **Step 5: Verify in browser**

```bash
npm run dev
```

Visit `/ja/chapters/01-introduction/`, `/ja/chapters/07-plotting/`, `/ja/chapters/08-fitting/`. Confirm titles render in Japanese, images load, math renders. Click the language switcher on `/ja/chapters/07-plotting/` and confirm it navigates to `/en/chapters/07-plotting/`.

- [ ] **Step 6: Commit**

```bash
git add src/content/docs/ja
git commit -m "Migrate JA chapters into Starlight content tree"
```

---

## Task 17: End-to-end local verification

**Files:** none modified — verification only.

- [ ] **Step 1: Run build (not dev) to catch production-only issues**

```bash
npm run build
```

Expected: exits 0 with a summary like `✓ Completed in N.NNs.` and `Pages built: 22+` (1 EN landing + 10 EN chapters + 1 JA landing + 10 JA chapters = 22, plus i18n routing).

If there are errors, fix them before proceeding. Common issues:
- Missing or wrong-cased slug in `sidebar.items` → fix the slug in `astro.config.mjs`
- Image path 404 → re-run the sed rewrites in Tasks 12/16
- Frontmatter missing → check that every chapter file has `title:`

- [ ] **Step 2: Preview the production build**

```bash
npm run preview
```

Visit `http://localhost:4321/Intro-to-Julia-for-spectroscopy/` and click through:
- [ ] EN landing page renders, schedule table is intact
- [ ] All 10 EN chapters render correctly
- [ ] JA landing page renders
- [ ] All 10 JA chapters render correctly
- [ ] Math renders on chapters 8, 9 (both EN and JA)
- [ ] Images load on chapter 7 (multi-axis plots), chapter 10 (transfer matrix)
- [ ] Code blocks render with Courier Prime Code and have a copy button
- [ ] Sidebar in Courier Prime, listing all chapters
- [ ] Language switcher in the header takes EN ↔ JA
- [ ] Link hover shows the thick overlapping underline
- [ ] Search (top of page) returns results when you type "function"
- [ ] Toggle light/dark mode — palette matches garrek.org (blue accents, terracotta on hover, deep teal dark bg)

Kill the server.

- [ ] **Step 3: Commit any incidental fixes**

```bash
git status
```

If there are stray edits, commit them now under a descriptive message before moving on.

---

## Task 18: Remove obsolete files

**Files:**
- Delete: `src/make_pdf.sh`, `src/` (the shell-script `src/`, **not** the new `src/` we created at the repo root — paths below disambiguate)
- Delete: `pdf/`
- Delete: `ja/ReadMe.md` and the now-empty `ja/` tree (including `ja/src/` if present)

**Important caveat:** Astro put new files at repo-root `src/`. The old shell script was at repo-root `src/make_pdf.sh`. After Astro init, `src/` contains BOTH. We need to delete only `src/make_pdf.sh`, not all of `src/`.

- [ ] **Step 1: Inspect what's currently in repo-root src/**

```bash
ls src/
```

Expected: `components/`, `content/`, `styles/`, **and** `make_pdf.sh`.

- [ ] **Step 2: Remove make_pdf.sh**

```bash
git rm src/make_pdf.sh
```

- [ ] **Step 3: Remove pdf/ artifact directory**

```bash
git rm -r pdf
```

- [ ] **Step 4: Remove residual ja/ tree**

```bash
ls ja/
```

If nothing remains except `ReadMe.md` and possibly `src/`:

```bash
git rm -r ja
```

Otherwise list what's left and remove only the obsolete pieces.

- [ ] **Step 5: Verify build still works**

```bash
npm run build
```

Expected: still succeeds.

- [ ] **Step 6: Commit**

```bash
git status
git commit -m "Remove obsolete PDF build and old chapter trees"
```

---

## Task 19: GitHub Actions deployment workflow

**Files:**
- Create: `.github/workflows/deploy.yml`

- [ ] **Step 1: Create the workflow file**

```bash
mkdir -p .github/workflows
```

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy site to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - name: Install
        run: npm ci
      - name: Build
        run: npm run build
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./dist

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

- [ ] **Step 2: Commit and push**

```bash
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Pages deployment workflow"
git push origin main
```

- [ ] **Step 3: Enable Pages (manual, one-time)**

In a browser:
1. Navigate to `https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/settings/pages`
2. Under "Build and deployment" → "Source," select **GitHub Actions**
3. Save

- [ ] **Step 4: Verify deployment**

Visit `https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy/actions` and wait for the workflow to complete (~2–3 minutes). When green, visit `https://garrekstemo.github.io/Intro-to-Julia-for-spectroscopy/` and confirm the site loads.

Spot-check the same items from Task 17 Step 2 on the deployed site.

---

## Task 20: Update top-level ReadMe.md

**Files:**
- Modify: `ReadMe.md`

- [ ] **Step 1: Rewrite ReadMe.md**

Replace `ReadMe.md` with a much shorter version pointing at the published site:

```markdown
# Introduction to Julia for Spectroscopy

A short course introducing Julia for spectroscopy data analysis, intended for students with little or no programming background.

**Read the course online:** [garrekstemo.github.io/Intro-to-Julia-for-spectroscopy](https://garrekstemo.github.io/Intro-to-Julia-for-spectroscopy/) (English and Japanese)

## Repository contents

- `src/content/docs/` — chapter markdown (EN under `en/`, JA under `ja/`)
- `public/images/` — figures used in the chapters
- `data/` — data files for the exercises
- `generate_images/` — Julia scripts that produce the figures

## Running the site locally

```bash
npm install
npm run dev
```

Then visit `http://localhost:4321/Intro-to-Julia-for-spectroscopy/`.

## Related

- [Optics Tutorials](https://github.com/garrekstemo/Optics-Tutorials) — the experimental tutorials this course pairs with
```

- [ ] **Step 2: Commit**

```bash
git add ReadMe.md
git commit -m "Update ReadMe to link the published site"
git push origin main
```

---

## Done

The tutorial site is live at `https://garrekstemo.github.io/Intro-to-Julia-for-spectroscopy/` with EN and JA content, garrek.org-inspired styling, math rendering, code highlighting, search, and a language switcher. The old PDF build is retired. Future chapter edits are one-file changes: edit a `.md` under `src/content/docs/<locale>/chapters/`, push, and the Action redeploys.
