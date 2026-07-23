<<<<<<< HEAD
.PHONY: report
all: REPORT open

src/**/*.md: 
	@echo reading $@

static/report/REPORT.pdf: src/**.md
	pandoc TEMPLATE.md static/references.bib \
		--lua-filter=include-md.lua \
		--citeproc \
		--number-sections \
		-o $@

# figure out how to set type to beamer
report: static/report/REPORT.pdf

open: static/report/REPORT.pdf
	code $<

clean: 
	rm static/report/REPORT.pdf
=======
all: watch-report
.PHONY: report clean open server watch-report mermaid-diagrams report-included-docs report-included-nonascii report-build-scan script-appendices

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

SCRIPTS_APPENDIX_DIR := src/appendices/scripts

BENCHLAM_SCRIPT := /workspaces/development/uni/2025-project/pdhd/scripts/benchlam/benchmark_ollama.py
BENCHLAM_TEST_SPEC_JSON := /workspaces/development/uni/2025-project/pdhd/scripts/benchlam/pdhd_test_cases.json

SCRIPT_SOURCES := \
	graphs/generate_benchmark_results.py \
	graphs/generate_gantt.py \
	graphs/generate_hardware_comparison.py \
	graphs/generate_multi_dim_hardware_analysis.py

SCRIPT_MDS := $(foreach s,$(SCRIPT_SOURCES),$(SCRIPTS_APPENDIX_DIR)/$(notdir $(s)).md) \
	$(SCRIPTS_APPENDIX_DIR)/benchmark_ollama.py.md \
	$(SCRIPTS_APPENDIX_DIR)/pdhd_test_cases.json.md

$(SCRIPTS_APPENDIX_DIR)/%.py.md: graphs/%.py | $(SCRIPTS_APPENDIX_DIR)
	@printf '## `%s`\n\n```python\n' "$(<F)" > $@
	@sed 's/\xe2\x94\x80/-/g; s/\xe2\x80\x93/-/g' $< >> $@
	@printf '\n```\n' >> $@

$(SCRIPTS_APPENDIX_DIR)/benchmark_ollama.py.md: $(BENCHLAM_SCRIPT) | $(SCRIPTS_APPENDIX_DIR)
	@printf '## `%s`\n\n```python\n' "$(<F)" > $@
	@sed 's/\xe2\x94\x80/-/g; s/\xe2\x80\x93/-/g' $< >> $@
	@printf '\n```\n' >> $@

$(SCRIPTS_APPENDIX_DIR)/pdhd_test_cases.json.md: $(BENCHLAM_TEST_SPEC_JSON) | $(SCRIPTS_APPENDIX_DIR)
	@printf '## `%s`\n\n```json\n' "$(<F)" > $@
	@cat $< >> $@
	@printf '\n```\n' >> $@

$(SCRIPTS_APPENDIX_DIR):
	@mkdir -p $@

script-appendices: $(SCRIPT_MDS)

REPORT.pdf: src/TOC.md $(MD_SRC) mermaid-diagrams script-appendices
	pandoc $< \
		-s \
		--toc \
		--number-sections \
		--lua-filter=./include-md.lua \
		--citeproc \
		-o $@

report-included-docs:
	@echo "Included markdown documents for REPORT build:"
	@TRACE_INCLUDE_MD=1 pandoc src/TOC.md \
		-s \
		--toc \
		--number-sections \
		--lua-filter=./include-md.lua \
		--citeproc \
		-t markdown \
		-o /dev/null 2>&1 | sed -n 's/^\[include-md\] //p' | awk '!seen[$$0]++'

report-included-nonascii:
	@echo "Non-ASCII characters in markdown documents included by Pandoc:"
	@tmpfile=$$(mktemp); \
	TRACE_INCLUDE_MD=1 pandoc src/TOC.md \
		-s \
		--toc \
		--number-sections \
		--lua-filter=./include-md.lua \
		--citeproc \
		-t markdown \
		-o /dev/null 2>&1 | sed -n 's/^\[include-md\] //p' | awk '!seen[$$0]++' > "$$tmpfile"; \
	found=0; \
	while IFS= read -r p; do \
		if [ ! -f "$$p" ]; then \
			echo "$$p: <missing file>"; \
			found=1; \
			continue; \
		fi; \
		if grep -nH -P "[^\\x00-\\x7F]" "$$p"; then \
			found=1; \
		fi; \
	done < "$$tmpfile"; \
	rm -f "$$tmpfile"; \
	if [ $$found -eq 0 ]; then \
		echo "No non-ASCII characters found in included markdown files."; \
	fi

report-build-scan: report-included-docs report-included-nonascii

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
>>>>>>> personal
