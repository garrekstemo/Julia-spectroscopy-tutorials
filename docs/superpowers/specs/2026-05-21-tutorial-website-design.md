# Tutorial website design

**Date:** 2026-05-21
**Status:** Proposed
**Goal:** Publish the "Introduction to Julia for Spectroscopy" tutorial as a navigable website to improve student usability and visibility, while continuing to produce the existing combined PDF.

## Context

The repo currently contains:

- 10 chapter markdown files in `chapters/` (English) and `ja/chapters/` (Japanese)
- Math via `$...$` (heavy in ch. 8 fitting and ch. 9 FFT; lighter elsewhere)
- Images in `images/` referenced as `../images/foo.png`
- A schedule table in `ReadMe.md`
- `src/make_pdf.sh` — pandoc + LuaLaTeX build producing `pdf/Introduction to Programming with Julia.pdf`
- A `generate_images/` folder of Julia scripts that produce the figures
- `data/` for student exercises

Audience: students new to programming. Primary growth driver: easier navigation and shareable links.

## Approaches considered

| Option | Pros | Cons |
|---|---|---|
| **Quarto** (recommended) | One source → HTML + PDF + EPUB. Built for scientific/technical content. Julia-aware. Drops `make_pdf.sh`. Math, code, figures handled natively. | Chapter files migrate to `.qmd` (rename + YAML frontmatter; body unchanged). |
| MkDocs Material | Plain markdown unchanged. Most polished theme out of the box. Easy i18n via plugin. | Two parallel build systems (web + PDF). Adds Python tooling. |
| mdBook | Lightweight, recognizable (Rust Book). | Smaller ecosystem; PDF stays separate; less polish. |

**Decision:** Quarto. Unifying the website and PDF builds into one toolchain is the main lever — it removes a maintenance surface (`make_pdf.sh`) rather than adding one.

## Architecture

### Source layout

```
_quarto.yml                      # shared site config: theme, navbar, project metadata
_quarto-en.yml                   # English profile: lang: en, output-dir: _site/en
_quarto-ja.yml                   # Japanese profile: lang: ja, output-dir: _site/ja
index.qmd                        # landing page — course overview, schedule table
chapters/
  01-introduction.qmd
  02-variables-operators-types.qmd
  03-conditionals.qmd
  04-iteration.qmd
  05-functions.qmd
  06-arrays.qmd
  07-plotting.qmd
  08-fitting.qmd
  09-fourier-transform.qmd
  10-transfer-matrix.qmd
ja/
  index.qmd
  chapters/
    01-はじめに.qmd
    ... (parallel structure)
images/                          # unchanged
data/                            # unchanged
generate_images/                 # unchanged
.github/workflows/publish.yml    # builds + deploys to gh-pages
```

Notes on naming:
- Chapter filenames drop the `". "` from current names (spaces + dots cause URL and tooling friction). Human-readable titles are preserved via YAML `title:` in each file.
- JA filenames keep Japanese-script titles — Quarto handles UTF-8 paths fine, and the path is `/ja/chapters/01-はじめに/`.

### Per-chapter YAML frontmatter

```yaml
---
title: "Introduction"
---
```

The body below the YAML is the existing markdown content, unchanged. (Heading `# Introduction` is removed since `title:` now provides it.)

### Site configuration (`_quarto.yml` shared)

- Theme: `cosmo` or similar clean default — minimal custom CSS
- Navbar: site title, top-right language switcher (EN ↔ JA), link to PDF download, link to GitHub repo
- Sidebar: auto-generated from `chapters/` listing in profile-specific configs
- Math: KaTeX (default for HTML), LaTeX for PDF
- Code: syntax highlighting via highlight.js with Julia support
- Search: Quarto's built-in client-side search (no external service)

### Language switcher

Quarto navbar entries link to the mirrored path in the other language. On chapter X in EN, the switcher links to the JA equivalent of chapter X. Implementation: navbar config in each profile points at the other language's root; for chapter-level mirroring, a small JS snippet or per-page `other-language-url:` metadata field. **Initial implementation:** top-level link only (EN site root ↔ JA site root). Per-chapter mirroring is a follow-up if needed.

## Build & deploy

### Local development

- `quarto preview --profile en` — live-reload English site
- `quarto preview --profile ja` — live-reload Japanese site
- `quarto render --profile en` — produce static HTML in `_site/en/`
- `quarto render --profile ja` — produce static HTML in `_site/ja/`

### PDF generation

Replaces `src/make_pdf.sh`:

- `quarto render --profile en --to pdf` → `pdf/Introduction to Programming with Julia.pdf`
- `quarto render --profile ja --to pdf` → `pdf/プログラミング入門 (Julia編).pdf` (or similar)

PDF font/typography settings (Libertinus Serif, Libertinus Math, DejaVu Sans Mono, 1in margins) move from `make_pdf.sh` flags into `_quarto.yml` under `format: pdf:` options.

### GitHub Pages deployment

`.github/workflows/publish.yml`:

1. Trigger: push to `main`, manual dispatch
2. Set up Quarto + Julia (Julia only needed if code execution is enabled — initially not)
3. `quarto render --profile en` and `quarto render --profile ja`
4. Combine into single `_site/` with `/en/` and `/ja/` subdirs and a small root `index.html` that redirects to `/en/`. Browser-language detection can be added later.
5. Render PDFs and copy into `_site/pdf/`
6. Deploy `_site/` to `gh-pages` branch via `actions/deploy-pages` or `peaceiris/actions-gh-pages`

Site URL: `https://garrekstemo.github.io/Intro-to-Julia-for-spectroscopy/` (or custom domain later).

## Content handling

| Element | Current | Under Quarto |
|---|---|---|
| Inline math | `$x^2$` | Same — KaTeX renders for HTML, LaTeX for PDF |
| Display math | `$$ ... $$` | Same |
| Images | `![](../images/foo.png)` | Same — Quarto resolves the relative path during render |
| Julia code blocks | ` ```julia ` | Same; **not executed at build time** initially |
| Tables (schedule) | Pipe tables | Same |
| Cross-chapter links | `[Chapter 7](07. Plotting.md)` | Rewritten to `[Chapter 7](07-plotting.qmd)` during migration |

### Code execution policy

Initially, code blocks render as syntax-highlighted but **inert** text — same behavior as the current PDF. This keeps builds fast (no Julia in CI) and avoids version-pinning headaches.

Per-chapter opt-in execution can be enabled later by adding to a chapter's frontmatter:

```yaml
execute:
  enabled: true
```

Out of scope for the initial migration.

## Migration plan (preview — full plan written separately)

1. Add Quarto project files (`_quarto.yml`, `_quarto-en.yml`, `_quarto-ja.yml`)
2. Migrate one chapter end-to-end (e.g., `01. Introduction.md` → `chapters/01-introduction.qmd`) and verify local render of HTML + PDF
3. Bulk-migrate remaining EN chapters
4. Mirror migration for JA chapters
5. Build `index.qmd` (landing) from `ReadMe.md` content
6. Update internal cross-references and image paths if any break
7. Add GitHub Actions workflow, enable Pages from `gh-pages` branch
8. Verify deployed site (nav, search, math, code blocks, images, PDF download, language switcher)
9. Delete `src/make_pdf.sh` and update `ReadMe.md` to link the website + describe the new build commands
10. Optional follow-up: enable code execution on chapters 7–10 (the data-heavy chapters where seeing real output adds the most value)

## Out of scope

- Code execution at build time (deferred — opt-in per chapter later)
- Interactive in-browser Julia (Pluto, Pyodide) — large separate project
- Search backend beyond Quarto's built-in
- Custom theming beyond defaults + minor CSS for fonts
- Per-chapter language-switcher precision (initial: site-level switcher only)
- Custom domain (can be added later via `CNAME`)

## Success criteria

- Site is live at a public URL with both EN and JA content
- All 10 chapters render correctly with math, code blocks, images, tables
- Combined PDF is still produced (now via Quarto) and is linked from the site
- `make_pdf.sh` is gone; build commands are documented in `ReadMe.md`
- Updating a chapter is a one-file edit (no separate web/PDF maintenance)
