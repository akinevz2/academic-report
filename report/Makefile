.PHONY: report *.md
all: REPORT open

# figure out how to set type to beamer
%: ./presentations/%.md
	pandoc $< \
		--lua-filter=./include-md.lua \
		--citeproc \
		-t beamer \
		-o $@.pdf

REPORT: ../report/REPORT.md ./src/**.md
	pandoc $< ./src/references.bib \
		--lua-filter=./include-md.lua \
		--citeproc \
		--number-sections \
		-o $@.pdf


open: REPORT
	code ../report/REPORT.pdf

clean: 
	rm ../report/REPORT.pdf