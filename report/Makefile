all: REPORT.pdf

report: open

clean: 
	rm REPORT.pdf

open: REPORT.pdf
	code ../report/REPORT.pdf

PANDOC_ARGS = -t revealjs -s -V revealjs-url=https://unpkg.com/reveal.js/ --include-in-header=./presentations/slides.css.frag -V theme=serif

5: ./presentations/5.md
	pandoc $< \
	 	$(PANDOC_ARGS) \
		--lua-filter=./include-md.lua \
		--citeproc \
		-t revealjs \
		-o 5.html

4: ./presentations/4.md
	pandoc $< \
		--toc -s \
		--lua-filter=./include-md.lua \
		--citeproc \
		-o $@.pdf



%: ./presentations/%.md
	pandoc $< \
		--lua-filter=./include-md.lua \
		--citeproc \
		-t beamer \
		-o $@.pdf

REPORT.pdf: REPORT.md src/**.md
	pandoc $< \
		--toc -s \
		--lua-filter=./include-md.lua \
		--citeproc \
		-o $@

