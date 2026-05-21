# Tutorial website design

**Date:** 2026-05-21
**Status:** Proposed
**Goal:** Publish the "Introduction to Julia for Spectroscopy" tutorial as a modern, navigable website to improve student usability and visibility.

## Context

The repo currently contains:

- 10 chapter markdown files in `chapters/` (English) and `ja/chapters/` (Japanese)
- Math via `$...$` (heavy in ch. 8 fitting and ch. 9 FFT; lighter elsewhere)
- Images in `images/` referenced as `../images/foo.png`
- A schedule table in `ReadMe.md`
- `src/make_pdf.sh` — pandoc + LuaLaTeX build producing a combined PDF
- A `generate_images/` folder of Julia scripts that produce the figures
- `data/` for student exercises

Audience: students new to programming. Primary growth driver: easier navigation, shareable links, and a modern look that doesn't feel like 2010-era documentation.

**Scope note:** The PDF build is being retired — nobody uses it. The website is the new canonical deliverable. `src/make_pdf.sh` and the `pdf/` artifact directory will be removed.

## Approaches considered

| Option | Pros | Cons |
|---|---|---|
| **Astro Starlight** (recommended) | Modern aesthetic. i18n + search built in. Static output. Markdown stays as markdown. Shiki code highlighting (excellent Julia support). Active development. | Adds Node.js to the toolchain. |
| VitePress | Very fast, minimal config. Modern look. | i18n config is fiddlier; smaller plugin ecosystem for math. |
| Nextra | Most polished "trendy" look. | Next.js dependency adds weight and complexity vs. plain static. |
| MkDocs Material | Plain `.md` unchanged, mature. | User preference: aesthetic feels classic-docs rather than modern. |
| Quarto | Native Julia code execution. | Heavier toolchain; `.md → .qmd` migration; aesthetic similar to Material. |

**Decision:** Astro Starlight. It hits the modern-aesthetic requirement, keeps content in plain markdown, has best-in-class i18n and search built in, and produces a static site that deploys cleanly to GitHub Pages.

## Architecture

### Source layout

Starlight's i18n uses one directory per locale under `src/content/docs/`. The default locale (English) sits in `src/content/docs/en/`, and translations mirror its structure under `src/content/docs/ja/`. Paired files at the same path are recognized as translations of each other.

```
astro.config.mjs                                   # Astro + Starlight config
package.json
package-lock.json
src/
  content/
    docs/
      en/
        index.md                                   # English landing page
        chapters/
          01-introduction.md
          02-variables-operators-types.md
          03-conditionals.md
          04-iteration.md
          05-functions.md
          06-arrays.md
          07-plotting.md
          08-fitting.md
          09-fourier-transform.md
          10-transfer-matrix.md
      ja/
        index.md                                   # Japanese landing
        chapters/
          01-introduction.md                       # Japanese content, same slug
          02-variables-operators-types.md
          ... (parallel structure)
public/
  images/                                          # moved from repo root, served as /images/*
data/                                              # unchanged (source data students download from the repo)
generate_images/                                   # unchanged
.github/workflows/publish.yml
```

Notes on naming:
- Filenames drop `". "` (e.g. `01. Introduction.md` → `01-introduction.md`) for clean URLs. The chapter's `# Heading` becomes the page title, or it can be set via a `title:` field in frontmatter (Starlight expects minimal frontmatter: `title`).
- JA filenames use the **same English slug** as their EN counterparts. This is how Starlight pairs them for the language switcher. The displayed page title in Japanese comes from the `title:` frontmatter field inside the JA file (e.g. `title: はじめに`).
- This is a small departure from the current `ja/chapters/01. はじめに.md` filename — slug becomes anglicized for URL stability, but the title rendered on the page is fully Japanese.

### Frontmatter (per file)

Starlight requires only a `title`. Example for `src/content/docs/ja/chapters/01-introduction.md`:

```yaml
---
title: はじめに
---
```

EN files get `title: Introduction` etc. This is the only YAML required — body markdown is otherwise unchanged.

### Site configuration (`astro.config.mjs`)

```js
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';

export default defineConfig({
  site: 'https://garrekstemo.github.io',
  base: '/Intro-to-Julia-for-spectroscopy',
  integrations: [
    starlight({
      title: 'Intro to Julia for Spectroscopy',
      social: {
        github: 'https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy',
      },
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
            // ... ten entries total
          ],
        },
      ],
      customCss: ['./src/styles/custom.css', 'katex/dist/katex.min.css'],
    }),
  ],
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
});
```

The sidebar `items` list slugs once; Starlight resolves them to the correct locale automatically. The language switcher appears in the header — clicking it on chapter X takes the user to the JA version of chapter X.

### Math

`remark-math` + `rehype-katex` handle the existing `$...$` (inline) and `$$...$$` (display) syntax without changes. KaTeX CSS is loaded via `customCss`.

### Code highlighting

Starlight uses Shiki by default — VS Code's syntax highlighter. Julia is supported out of the box. Code blocks render with a copy button automatically. No configuration needed.

### Search

Pagefind is included with Starlight — automatic indexing, client-side search, no external service. Each locale gets its own index.

## Styling — match garrek.org

The tutorial site should feel like it belongs to the same family as [garrek.org](https://garrek.org) — same typographic voice, same color palette, same link behavior — while accepting that Starlight's component architecture means we're matching the *spirit* of the design rather than pixel-perfect.

### Fonts (self-hosted, copied from garrek.org's `src/assets/fonts/`)

| Use | Family | Fallback stack |
|---|---|---|
| Body + headings | **Libre Baskerville** | `Georgia, "Times New Roman", serif` |
| Sidebar nav, buttons, callout labels | **Courier Prime** | `"Courier New", Courier, monospace` |
| Code blocks + inline code | **Courier Prime Code** | `"Courier Prime", "Courier New", monospace` |
| Figcaptions | Helvetica | `Arial, sans-serif` (system) |

Lyon Text (used on the personal site) is a trial font — substituting **Libre Baskerville** here for licensing reasons. **Courier Prime Code** is the code-optimized variant of Courier Prime (same designer, OFL-licensed). It's not yet in garrek.org's fonts folder; needs to be downloaded from [quoteunquoteapps.com/courierprime](https://quoteunquoteapps.com/courierprime/) and dropped into `public/fonts/Courier-Prime-Code/`.

All fonts live in `public/fonts/` and are loaded via `@font-face` in `src/styles/custom.css`.

### Color palette (light + dark, via `prefers-color-scheme`)

Lifted directly from `garrek-org/src/css/styles.css`:

| Token | Light | Dark |
|---|---|---|
| Background | `#ffffff` | `#15252b` (deep teal) |
| Body text | `#202020` | `#d0d0d0` |
| Heading text | `#000` (h1/h2), `#4c4c4c` (h3) | `#d4795a` (terracotta) |
| Link underline | `#2090e0` (blue) | `#2090e0` (blue) |
| Link hover underline | `#e05a3a` (terracotta) | `#e8734f` (terracotta) |
| Sidebar nav text | `#1478d4` (blue) | `#5aafe6` (light blue) |
| Sidebar nav hover | `#e05a3a` | `#e8734f` |
| Code block bg | `#fafafa` (very light gray) | `#1e3036` (slightly lifted from page bg) |
| Code block text | inherits via Shiki theme | inherits via Shiki theme |
| Code block border | `#e5e5e5` | `#2a3d44` |
| `<hr>` rule | `#2090e0` | `#2090e0` |

These are wired into Starlight via CSS custom properties in `custom.css` — Starlight exposes its design tokens as `--sl-color-*` variables which we override.

### Typography (Major Third — 1.25 ratio)

- Body: `1em` (16px), `line-height: 1.6`
- h1: `2em`, weight 700
- h2: `1.5em`, `line-height: 1.4`
- h3: `1.25em`
- Site title: `1.6em` Libre Baskerville, weight 400
- Sidebar nav: `1.2em` Courier Prime on desktop, `1em` on mobile, weight 300

### Link hover (distinctive — port verbatim)

```css
a {
  text-decoration-thickness: 0.1em;
  text-underline-offset: 0.3em;
}
a:hover {
  text-decoration-thickness: 0.6em;
  text-underline-offset: -5px;
  text-decoration-skip-ink: none;
}
```

This is the defining visual signature of garrek.org. Apply to all prose links.

### Layout adjustments

Starlight defaults that we override:
- **Content max-width**: 800px (matches garrek.org) — override `--sl-content-width`
- **Sidebar width**: 180px (matches garrek.org's left nav) — override `--sl-sidebar-width`
- **Right-side table of contents**: hidden by default on chapter pages (garrek.org doesn't have one; tutorial chapters are short enough that headings nav is overhead). Achieved per-page via `tableOfContents: false` in frontmatter, or globally via Starlight config.
- **Sidebar font**: Courier Prime, weight 300, right-aligned on desktop. Achieved via custom CSS targeting `.sidebar nav a`.

### Component overrides (Starlight slot mechanism)

Starlight lets you swap out individual components via `astro.config.mjs`:

```js
starlight({
  components: {
    SiteTitle: './src/components/SiteTitle.astro',
    PageTitle: './src/components/PageTitle.astro',
  },
  // ...
})
```

Initial overrides:
- `SiteTitle.astro`: render the site title in Libre Baskerville at `1.6em`, matching garrek.org's `.site-title`
- `PageTitle.astro`: render chapter `# Title` in the same scale as garrek.org's `h1` (`2em`, weight 700)

Header layout (sticky top, border-bottom rule, title left + repo link right) can be handled with CSS alone; no `Header.astro` override needed initially.

### Code blocks

Garrek.org disables syntax highlighting; the tutorial needs it for Julia. Since you haven't yet designed code blocks for the personal site, the goal here is **minimal default styling that doesn't fight the serif body** — a quiet container with a quiet syntax theme. This treatment can later inform code blocks on the personal site (or diverge — both decisions stay open).

- **Syntax theme:** Shiki's `min-light` / `min-dark` (Sarah Drasner's minimal themes — barely-there color, mostly weight and italic for emphasis). If those read too quiet during build review, fall back to `github-light` / `github-dark`.
- **Font:** Courier Prime Code at `0.95em`, `line-height: 1.6`
- **Container:** `1px` solid border in the muted gray tokens above, `8px` border-radius, `1em 1.25em` padding, light-gray background tint (`#fafafa` light / `#1e3036` dark)
- **Inline code:** Courier Prime Code, no background, slightly tinted text color in dark mode for readability
- **Copy button:** Starlight default — small icon in the top-right corner; restyled to match the muted palette

Net effect: code blocks read as "quietly distinct from prose," not as decorated boxes. Easy to lift back to garrek.org later as a small CSS addition.

### Out-of-scope styling deviations (intentional)

- **Some Starlight JS will be present** (search modal, mobile nav, theme toggle). Garrek.org's zero-JS principle doesn't apply here — search is the trade.
- **Syntax highlighting is on.** Justified by content (Julia tutorial); garrek.org's prose doesn't need it.
- **No "Subscribe" button** in the header. The personal site has one for newsletter; tutorial doesn't need it. Repo link in the header replaces it.
- **No light/dark toggle button** if `prefers-color-scheme` handles it cleanly. Starlight ships a toggle; we can hide it via CSS if we want to match garrek.org's purely-automatic approach. Decision: **keep the toggle** — students may want to override the system preference.



## Build & deploy

### Local development

```bash
npm install
npm run dev       # live-reload at http://localhost:4321
npm run build     # static site in dist/
npm run preview   # preview the production build locally
```

### GitHub Pages deployment

`.github/workflows/publish.yml`:

1. Trigger: push to `main`, manual dispatch
2. `actions/checkout`
3. `actions/setup-node` (Node 20+)
4. `npm ci`
5. `npm run build` — produces `dist/`
6. `actions/upload-pages-artifact` with `dist/`
7. `actions/deploy-pages` to publish

Site URL: `https://garrekstemo.github.io/Intro-to-Julia-for-spectroscopy/`.

## Content handling

| Element | Current | Under Starlight |
|---|---|---|
| Inline math | `$x^2$` | Same — remark-math + rehype-katex |
| Display math | `$$ ... $$` | Same |
| Images | `![](../images/foo.png)` | Move images to `public/images/` and rewrite refs as `![](/images/foo.png)` (absolute). Astro's `base` config prepends the repo subpath at build time. Single find-replace pass during migration. |
| Julia code blocks | ` ```julia ` | Same — Shiki highlights, copy button automatic |
| Tables (schedule) | Pipe tables | Same |
| Cross-chapter links | `[Chapter 7](07. Plotting.md)` | Rewritten to `[Chapter 7](./07-plotting)` (slug, no extension) during migration |

## Migration plan (preview — full plan written separately)

1. Initialize Astro + Starlight: `npm create astro@latest -- --template starlight`, configure `astro.config.mjs`
2. Set up fonts in `public/fonts/`:
   - Copy `garrek-org/src/assets/fonts/Libre-Baskerville/` and `Courier-Prime/`
   - Download Courier Prime Code from [quoteunquoteapps.com/courierprime](https://quoteunquoteapps.com/courierprime/) and place under `public/fonts/Courier-Prime-Code/`
3. Write `src/styles/custom.css`: `@font-face` declarations, Starlight CSS variable overrides for colors/widths/fonts, link hover rules, h1–h3 scale
4. Build component overrides: `src/components/SiteTitle.astro` and `src/components/PageTitle.astro`
5. Move EN chapters: rename `chapters/01. Introduction.md` → `src/content/docs/en/chapters/01-introduction.md`, add `title:` frontmatter, leave body alone
6. Move JA chapters: same slug as EN, but `title: <Japanese title>` in frontmatter
7. Move `images/` → `public/images/` and rewrite all `![](../images/...)` to `![](/images/...)` in chapter files (single find-replace pass)
8. Create EN and JA landing pages from `ReadMe.md` content and `ja/ReadMe.md`
9. Sweep chapter files for cross-references; convert to Starlight-style internal links
10. Delete the now-empty `ja/` tree and original top-level `chapters/`
11. Verify locally with `npm run dev`: click every chapter, both languages, check math/images/code blocks, verify link hover matches garrek.org, verify light/dark palette
12. Add GitHub Actions workflow, enable Pages with "GitHub Actions" as the source
13. Delete `src/make_pdf.sh`, the now-empty `src/`, and `pdf/`
14. Update top-level `ReadMe.md`: shorten to a brief intro + prominent link to the published site

## Out of scope

- PDF output (explicitly retired)
- Code execution at build time (would require swapping Starlight for Quarto or layering in a custom integration)
- Interactive in-browser Julia (Pluto, Pyodide) — large separate project
- Per-page search backend beyond Pagefind (Pagefind is sufficient)
- Pixel-perfect parity with garrek.org (the styling target is "feels like the same family," not "identical"). Some Starlight UI (search modal, mobile drawer, code copy buttons) will remain Starlight-shaped.
- Custom domain (can be added later via `CNAME` and config)

## Success criteria

- Site is live at a public URL with both EN and JA content
- All 10 chapters render correctly with math, code blocks (with copy button), images, tables
- Language switcher takes the user to the matching page in the other language
- Pagefind search works across all chapters in the current language
- Visual identity reads as part of the garrek.org family: Libre Baskerville body, Courier Prime sidebar, blue/terracotta link palette, distinctive thick-underline hover
- Light and dark mode both honor the lifted color palette
- `src/make_pdf.sh`, `pdf/`, and the old top-level `chapters/` and `ja/` trees are gone
- Updating a chapter is a one-file edit — no separate build artifacts to regenerate
