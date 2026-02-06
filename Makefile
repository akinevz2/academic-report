all: REPORT.pdf

report: open

clean: 
	rm REPORT.pdf

open: REPORT.pdf
	code REPORT.pdf

%: ./presentations/%.md
	pandoc $< \
		--lua-filter=./include-md.lua \
		--citeproc \
		-t beamer \
		-o $@.pdf

REPORT.pdf: REPORT.md src/**.md
	pandoc $< ./references.bib \
		--toc -s \
		--lua-filter=./include-md.lua \
		--citeproc \
		-o $@

