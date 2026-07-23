<<<<<<< HEAD
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
=======
# Reports Template 

This repository contains the markdown files and scripts necessary to build academic reports using Pandoc. I have developed this workflow over the past few years at University of Sussex, and would like to distribute these files freely.

The intended use case is to produce documents in the pdf format easily.

Academic use only. Commercial use prohibited.
Repository's home is at github.com/akinevz2/academic-report-pub.

Please respect the author's choices.

# Usage

```
# edit the report/REPORT.md
cd report/ && make REPORT
# open the report in your 
# application of choice
```
>>>>>>> personal
