all: REPORT.pdf
.PHONY: report clean open

clean: 
	rm REPORT.pdf

open: report
	code ../report/REPORT.pdf

report: REPORT.pdf 

PANDOC_ARGS = -t revealjs -s -V revealjs-url=https://unpkg.com/reveal.js --include-in-header=./presentations/slides.css.html -V theme=serif

%: ./presentations/%.md
	pandoc $< \
	 	$(PANDOC_ARGS) \
		--lua-filter=./include-md.lua \
		--citeproc \
		-t revealjs \
		--toc -s \
		-o $@.html

REPORT.pdf: REPORT.md src/**.md
	pandoc $< \
		--toc -s \
		--lua-filter=./include-md.lua \
		--citeproc \
		-o $@

