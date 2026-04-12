# Report Template

Reusable Pandoc-based template for writing academic reports in Markdown.

## Requirements

- `pandoc`
- A PDF engine (for example TeX Live)
- Optional for live rebuilds: `npx` + `chokidar-cli`

## Quick Start

```sh
make report
make open
```

By default, the build uses `REPORT.md` when present, otherwise `TEMPLATE.md`.

## Authoring Structure

- Main entry document: `REPORT.md` or `TEMPLATE.md`
- Section files: `src/*.md`
- Bibliography: `references.bib`

The Lua filter (`include-md.lua`) expands local Markdown links to other `.md` files so you can compose reports from smaller section files.

## Useful Targets

- `make report`: build `REPORT.pdf`
- `make watch-report`: rebuild automatically when markdown files change
- `make presentations`: build Beamer PDFs from `presentations/*.md` (if present)
- `make clean`: remove generated artifacts
