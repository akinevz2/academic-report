all: REMINDERS install UPDATES
REMINDERS: presentations report
UPDATES: presentation report quarkus-test

REPORT: report

install:
	sudo apt-get update
	sudo apt-get install -y pandoc texlive-xetex texlive-fonts-recommended texlive-xetex
	sudo apt-get install -y maven


report: ./report/REPORT.pdf ./report/**/*.md
	cd report && make clean report open

presentations:
	@cd report/ && for presentation in presentations/*.md; do \
		filename=$${presentation##*/}; \
		pdf_name=$${filename%.md}; \
		echo "Building $$pdf_name"; \
		make "$$pdf_name"; done

.PHONY: all

hz: 
	@echo here's your hertz's formula
	@echo "zcr_hz = sum(1 for i in range(1, len(signal)) if signal[i-1] * signal[i] < 0) * (sample_rate / (2 * (len(signal) - 1)))" > hz_formula.terse
	@echo "cat hz_formula.terse"