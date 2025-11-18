all: REMINDERS

REMINDERS: presentations report
UPDATES: presentation report quarkus-test

REPORT: report

report: ./report/**/*.md
	@echo >> BUILDING.log REPORT PDF
	cd report && make report
	cd report && make open

quarkus-test:
	@echo >> BUILDING.log QUARKUS APP. NOT SUPPORTED YET
	cd schematics/schematics && mvn quarkus:test

quarkus-build:
	@echo >> BUILDING.log QUARKUS APP. NOT SUPPORTED YET
	cd schematics/schematics && mvn quarkus:build

presentations:
	@echo >> BUILDING.log PRESENTATIONS PDFS
	@cd report/ && for presentation in presentations/*.md; do \
		filename=$${presentation##*/}; \
		pdf_name=$${filename%.md}; \
		echo "Building $$pdf_name"; \
		make "$$pdf_name"; done

.PHONY: all
