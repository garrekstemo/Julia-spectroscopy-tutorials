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
2. Move EN chapters: rename `chapters/01. Introduction.md` → `src/content/docs/en/chapters/01-introduction.md`, add `title:` frontmatter, leave body alone
3. Move JA chapters: same slug as EN, but `title: <Japanese title>` in frontmatter
4. Move `images/` → `public/images/` and rewrite all `![](../images/...)` to `![](/images/...)` in chapter files (single find-replace pass)
5. Create EN and JA landing pages from `ReadMe.md` content and `ja/ReadMe.md`
6. Sweep chapter files for cross-references; convert to Starlight-style internal links
7. Delete the now-empty `ja/` tree and original top-level `chapters/`
8. Verify locally with `npm run dev`: click every chapter, both languages, check math/images/code blocks
9. Add GitHub Actions workflow, enable Pages with "GitHub Actions" as the source
10. Delete `src/make_pdf.sh`, the now-empty `src/`, and `pdf/`
11. Update top-level `ReadMe.md`: shorten to a brief intro + prominent link to the published site

## Out of scope

- PDF output (explicitly retired)
- Code execution at build time (would require swapping Starlight for Quarto or layering in a custom integration)
- Interactive in-browser Julia (Pluto, Pyodide) — large separate project
- Per-page search backend beyond Pagefind (Pagefind is sufficient)
- Custom theming beyond Starlight defaults + a small `custom.css` for fonts/spacing
- Custom domain (can be added later via `CNAME` and config)

## Success criteria

- Site is live at a public URL with both EN and JA content
- All 10 chapters render correctly with math, code blocks (with copy button), images, tables
- Language switcher takes the user to the matching page in the other language
- Pagefind search works across all chapters in the current language
- `src/make_pdf.sh`, `pdf/`, and the old top-level `chapters/` and `ja/` trees are gone
- Updating a chapter is a one-file edit — no separate build artifacts to regenerate
