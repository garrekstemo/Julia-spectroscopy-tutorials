# Tutorial website design

**Date:** 2026-05-21
**Status:** Proposed
**Goal:** Publish the "Introduction to Julia for Spectroscopy" tutorial as a navigable website to improve student usability and visibility.

## Context

The repo currently contains:

- 10 chapter markdown files in `chapters/` (English) and `ja/chapters/` (Japanese)
- Math via `$...$` (heavy in ch. 8 fitting and ch. 9 FFT; lighter elsewhere)
- Images in `images/` referenced as `../images/foo.png`
- A schedule table in `ReadMe.md`
- `src/make_pdf.sh` — pandoc + LuaLaTeX build producing a combined PDF
- A `generate_images/` folder of Julia scripts that produce the figures
- `data/` for student exercises

Audience: students new to programming. Primary growth driver: easier navigation and shareable links.

**Scope note:** The existing PDF build is being retired — nobody uses it. The website is the new canonical deliverable. `src/make_pdf.sh` and the `pdf/` artifact directory will be removed as part of this migration.

## Approaches considered

| Option | Pros | Cons |
|---|---|---|
| **MkDocs Material** (recommended) | Plain `.md` files unchanged. Most polished default theme of any docs framework. Mature i18n plugin. Simple to maintain. Familiar to students from other docs sites. | Code blocks are static (no execution). Requires Python tooling in CI. |
| Quarto | Native Julia code execution at build time. Designed for scientific/technical content. | Chapter files would migrate `.md → .qmd` (rename + YAML frontmatter). Heavier toolchain than needed without the PDF use case. |
| mdBook | Lightweight, plain markdown, recognizable (Rust Book). | Smaller plugin ecosystem; less polished UI; weaker i18n story. |

**Decision:** MkDocs Material. With PDF off the table, the deciding factor is migration cost vs. polish, and Material wins on both: zero source rewrite, no YAML frontmatter, best-in-class default theme. Quarto's code-execution superpower is real but not needed for a tutorial whose code outputs are already captured as pre-rendered figures.

## Architecture

### Source layout

The current `chapters/` and `ja/chapters/` move under `docs/` (MkDocs's content root convention). This is a `git mv` — markdown bodies are unchanged.

```
mkdocs.yml                         # site config
docs/
  index.md                         # landing page (English) — derived from ReadMe.md
  index.ja.md                      # landing page (Japanese)
  chapters/
    01-introduction.md
    01-introduction.ja.md          # Japanese counterpart, same slug
    02-variables-operators-types.md
    02-variables-operators-types.ja.md
    ...
    10-transfer-matrix.md
    10-transfer-matrix.ja.md
  images/                          # moved from repo root, refs updated
  assets/
    extra.css                      # minor font/spacing overrides
data/                              # unchanged at repo root
generate_images/                   # unchanged at repo root
.github/workflows/publish.yml      # build + deploy
```

Notes on naming:
- Filenames drop `". "` (e.g. `01. Introduction.md` → `01-introduction.md`) for clean URLs. The chapter's `# Heading` becomes the page title automatically — no YAML frontmatter needed.
- i18n uses the **suffix** mode of `mkdocs-static-i18n`: `foo.md` (default/English) and `foo.ja.md` (Japanese) sit side by side. This keeps EN and JA chapters paired in the file tree.
- `ja/chapters/01. はじめに.md` → `docs/chapters/01-introduction.ja.md`. The displayed title comes from the Japanese `# はじめに` heading inside the file; only the filename slug is anglicized for URL stability.

### Site configuration (`mkdocs.yml`)

Key settings:

```yaml
site_name: Introduction to Julia for Spectroscopy
site_url: https://garrekstemo.github.io/Intro-to-Julia-for-spectroscopy/
repo_url: https://github.com/garrekstemo/Intro-to-Julia-for-spectroscopy
repo_name: garrekstemo/Intro-to-Julia-for-spectroscopy

theme:
  name: material
  features:
    - navigation.tabs        # top-level sections as tabs
    - navigation.sections    # group sidebar items
    - navigation.top         # back-to-top button
    - search.suggest
    - search.highlight
    - content.code.copy      # one-click copy on code blocks
  palette:
    - scheme: default
      primary: indigo
      toggle: { icon: material/brightness-7, name: Dark mode }
    - scheme: slate
      toggle: { icon: material/brightness-4, name: Light mode }

plugins:
  - search
  - i18n:
      docs_structure: suffix
      languages:
        - locale: en
          default: true
          name: English
        - locale: ja
          name: 日本語

markdown_extensions:
  - admonition
  - pymdownx.arithmatex:    # math
      generic: true
  - pymdownx.highlight:     # code
      anchor_linenums: true
  - pymdownx.superfences
  - pymdownx.tabbed
  - tables
  - toc:
      permalink: true

extra_javascript:
  - https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js

nav:
  - Home: index.md
  - Chapters:
      - 1. Introduction: chapters/01-introduction.md
      - 2. Variables, operators, and types: chapters/02-variables-operators-types.md
      - 3. Conditionals: chapters/03-conditionals.md
      - 4. Iteration: chapters/04-iteration.md
      - 5. Functions: chapters/05-functions.md
      - 6. Arrays: chapters/06-arrays.md
      - 7. Plotting: chapters/07-plotting.md
      - 8. Fitting: chapters/08-fitting.md
      - 9. Fourier transform: chapters/09-fourier-transform.md
      - 10. Transfer matrix: chapters/10-transfer-matrix.md
```

The i18n plugin reads the same `nav:` block but resolves each path to its localized counterpart when a Japanese page exists (`chapters/01-introduction.ja.md`).

### Language switcher

The `mkdocs-static-i18n` plugin renders a language selector in the Material theme header automatically. Switching language on chapter X takes the user to the JA version of chapter X (per-chapter mirroring is built in, not a follow-up — this is a free win versus the Quarto path).

## Build & deploy

### Local development

- `pip install mkdocs-material mkdocs-static-i18n pymdown-extensions`
- `mkdocs serve` — live-reload at `http://127.0.0.1:8000`
- `mkdocs build` — produce static site in `site/`

A `requirements.txt` (or `pyproject.toml`) at the repo root pins versions for reproducibility.

### GitHub Pages deployment

`.github/workflows/publish.yml`:

1. Trigger: push to `main`, manual dispatch
2. Set up Python 3.12
3. `pip install -r requirements.txt`
4. `mkdocs gh-deploy --force` — builds and pushes to `gh-pages` branch in one step
5. Pages serves from the `gh-pages` branch

Site URL: `https://garrekstemo.github.io/Intro-to-Julia-for-spectroscopy/`.

## Content handling

| Element | Current | Under MkDocs Material |
|---|---|---|
| Inline math | `$x^2$` | Same — `pymdownx.arithmatex` + MathJax |
| Display math | `$$ ... $$` | Same |
| Images | `![](../images/foo.png)` | Rewritten to `![](../images/foo.png)` relative to new `docs/chapters/` location (resolves to `docs/images/foo.png`). The relative path string is unchanged because the relative jump is the same — `chapters/` → `images/` is still `../images/`. |
| Julia code blocks | ` ```julia ` | Same — syntax-highlighted, with copy button |
| Tables (schedule) | Pipe tables | Same |
| Cross-chapter links | `[Chapter 7](07. Plotting.md)` | Rewritten to `[Chapter 7](07-plotting.md)` during the slug migration |

## Migration plan (preview — full plan written separately)

1. Add MkDocs project files: `mkdocs.yml`, `requirements.txt`
2. `git mv chapters docs/chapters`, then rename each file to lower-case-dashed slug (`01. Introduction.md` → `01-introduction.md`)
3. `git mv ja/chapters/*.md` into `docs/chapters/` as `<slug>.ja.md` (one rename per file; titles inside files unchanged)
4. `git mv images docs/images`
5. Delete the now-empty `ja/` tree and `ja/ReadMe.md`, `ja/src/`
6. Create `docs/index.md` (and `docs/index.ja.md`) from the current `ReadMe.md` content
7. Sweep chapter files for cross-references and fix any broken paths (`02. Variables, operators, and types.md` references etc.)
8. Verify locally: `mkdocs serve`, click through every chapter, both languages, check math and images
9. Add GitHub Actions workflow, enable Pages from `gh-pages` branch
10. Delete `src/make_pdf.sh`, the now-empty `src/`, and `pdf/`
11. Update top-level `ReadMe.md`: shorten to a brief intro + link to the published site; keep the schedule table or move it onto `docs/index.md`

## Out of scope

- PDF output (explicitly retired)
- Code execution at build time (MkDocs doesn't natively support this; would require switching to Quarto or adding `mkdocs-jupyter`)
- Interactive in-browser Julia (Pluto, Pyodide) — large separate project
- Per-page search backend beyond MkDocs's built-in (Material includes a polished client-side search)
- Custom theming beyond Material defaults + a small `extra.css` for fonts/spacing
- Custom domain (can be added later via `CNAME`)

## Success criteria

- Site is live at a public URL with both EN and JA content
- All 10 chapters render correctly with math, code blocks (with copy button), images, tables
- Language switcher takes the user to the matching page in the other language
- Search works across all chapters in the current language
- `src/make_pdf.sh`, `pdf/`, and the old top-level `chapters/` and `ja/` trees are gone
- Updating a chapter is a one-file edit — no separate build artifacts to regenerate
