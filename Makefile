all: watch-report
.PHONY: report clean open server watch-report mermaid-diagrams

clean: 
	rm -f REPORT.pdf ./presentations/*.pdf ./presentations/*.html

open: report
	code REPORT.pdf

report: REPORT.pdf 

# Find all markdown files in presentations/
PRESENTATIONS := $(wildcard presentations/*.md)
# Extract just the names (1, 2, 3, 4, 5, rubymoon)
PRESENTATION_NAMES := $(notdir $(basename $(PRESENTATIONS)))

# Build PDF targets: 5.pdf, 4.pdf, etc.
PDF_TARGETS := $(PRESENTATION_NAMES:=.pdf)
# Build HTML targets: 5.html, 4.html, etc.
HTML_TARGETS := $(PRESENTATION_NAMES:=.html)

presentations: $(PDF_TARGETS) $(HTML_TARGETS)

PANDOC_ARGS = -t s5 --include-in-header=./slides.css.html -V theme=serif

%.pdf: presentations/%.md
	pandoc $< -s --lua-filter=./include-md.lua --citeproc -t beamer -o presentations/$@

%.html: presentations/%.md
	pandoc $< $(PANDOC_ARGS) --lua-filter=./include-md.lua --citeproc -t revealjs -o presentations/$@

present: 
	npx serve -s presentations


MD_SRC := $(shell find src -type f -name '*.md' | sort)

MERMAID_SRC := $(wildcard diagrams/*.mmd)
MERMAID_OUT := $(patsubst diagrams/%.mmd,images/%.png,$(MERMAID_SRC))

mermaid-diagrams: $(MERMAID_OUT)

images/%.png: diagrams/%.mmd mermaid.puppeteer.json
	@mkdir -p images
	npx --yes @mermaid-js/mermaid-cli -i $< -o $@ -p mermaid.puppeteer.json -w 2200 -H 1200 -s 2

REPORT.pdf: src/TOC.md $(MD_SRC) mermaid-diagrams
	pandoc $< \
		-s \
		--toc \
		--number-sections \
		--lua-filter=./include-md.lua \
		--citeproc \
		-o $@

cw:
	pandoc src/assignment.md -o assignment.pdf
	code assignment.pdf

code:
	code Makefile

edit:
	code src/TOC.md

watch-report: report
	@echo "Watching markdown files with npx chokidar-cli (Ctrl+C to stop)..."
	@npx --yes chokidar-cli "**/*.md" \
		-i "**/.git/**" \
		-i "**/node_modules/**" \
		-c "$(MAKE) --no-print-directory report"