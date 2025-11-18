all: REMINDERS

REMINDERS: presentations report quarkus-test

report: 
	@echo >> BUILDING REPORT PDF
	cd report && make REPORT

quarkus-test:
	@echo >> BUILDING QUARKUS APP. NOT SUPPORTED YET
	cd schematics/schematics && mvn quarkus:test

quarkus-build:
	@echo >> BUILDING QUARKUS APP. NOT SUPPORTED YET
	cd schematics/schematics && mvn quarkus:build

presentations:
	@echo >> BUILDING PRESENTATIONS PDFS
	@cd report/ && for presentation in presentations/*.md; do \
		filename=$${presentation##*/}; \
		pdf_name=$${filename%.md}.pdf; \
		echo "Building $$pdf_name"; \
		make "$$pdf_name"; done