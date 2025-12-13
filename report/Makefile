all: REPORT.pdf

report: open

clean: 
	rm REPORT.pdf

open: REPORT.pdf
	code ../report/REPORT.pdf

5: ./presentations/5.md
	pandoc $< \
		--lua-filter=./include-md.lua \
		--citeproc \
		-f markdown \
		-o 5.html


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

