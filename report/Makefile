.PHONY: report *.md
all: REPORT open

../src/**/*.md: 
	@echo reading $@

REPORT: ../report/REPORT.md ../src/**/*.md
	pandoc $< ../report/references.bib \
		--lua-filter=include-md.lua \
		--citeproc \
		--number-sections \
		-o $@.pdf

# figure out how to set type to beamer
%.pdf: ../presentations/%.md
	pandoc $< \
		--lua-filter=include-md.lua \
		--citeproc \
		--number-sections \
		-o $@

open: REPORT
	code REPORT.pdf

clean: 
	rm ../report/REPORT.pdf