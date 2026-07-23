.PHONY: report
all: report open

src/**/*.md: 
	@echo reading $@

static/proposal.pdf: src/**.md ./static/proposal.md
	pandoc ./static/proposal.md static/references.bib \
		--lua-filter=include-md.lua \
		--citeproc \
		--number-sections \
		-o $@

static/report/REPORT.pdf: src/**.md ./TEMPLATE.md
	pandoc TEMPLATE.md static/references.bib \
		--lua-filter=include-md.lua \
		--citeproc \
		--number-sections \
		-o $@

# figure out how to set type to beamer
report: static/report/REPORT.pdf

proposal: static/proposal.pdf

open: static/report/REPORT.pdf
	code $<

preview: static/proposal.pdf
	code $<

clean: 
	rm static/report/REPORT.pdf
	rm static/proposal.pdf
