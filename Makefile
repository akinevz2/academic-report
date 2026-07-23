.PHONY: report
all: REPORT open

src/**/*.md: 
	@echo reading $@

static/report/REPORT.pdf: src/**.md ./TEMPLATE.md
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
