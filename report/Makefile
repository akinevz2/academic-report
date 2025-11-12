.PHONY: report
all: REPORT.pdf open

%.pdf: ../src/%.md ../src/**/*.md
	pandoc $< doc/references.bib \
		--lua-filter=include-md.lua \
		--citeproc \
		--number-sections \
		-o $@
	touch $@

# figure out how to set type to beamer
%.pdf: ../presentations/%.md
	pandoc $< \
		--lua-filter=include-md.lua \
		--citeproc \
		--number-sections \
		-o $@

open: REPORT.pdf
	code REPORT.pdf

clean: 
	rm REPORT.pdf