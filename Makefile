all: report

.PHONY: all report clean open watch-report presentations

clean:
	rm -f REPORT.pdf presentations/*.pdf presentations/*.html

report: REPORT.pdf

open: report
	code REPORT.pdf

REPORT_ENTRY := $(firstword $(wildcard REPORT.md TEMPLATE.md))
MD_SRC := $(shell find src -type f -name '*.md' | sort)

REPORT.pdf: $(REPORT_ENTRY) $(MD_SRC) references.bib include-md.lua
	pandoc $< \
		-s \
		--toc \
		--number-sections \
		--lua-filter=./include-md.lua \
		--citeproc \
		-o $@

watch-report: report
	@echo "Watching markdown files with npx chokidar-cli (Ctrl+C to stop)..."
	@npx --yes chokidar-cli "**/*.md" \
		-i "**/.git/**" \
		-i "**/node_modules/**" \
		-c "$(MAKE) --no-print-directory report"

PRESENTATIONS := $(wildcard presentations/*.md)
PRESENTATION_NAMES := $(notdir $(basename $(PRESENTATIONS)))
PDF_TARGETS := $(PRESENTATION_NAMES:=.pdf)

presentations: $(PDF_TARGETS)

%.pdf: presentations/%.md
	pandoc $< -s --lua-filter=./include-md.lua --citeproc -t beamer -o presentations/$@

