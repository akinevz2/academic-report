all: REMINDERS UPDATES
REMINDERS: presentations report
.PHONY: report

REPORT: report

install:
	sudo apt-get update
	sudo apt-get install -y texlive-fonts-recommended texlive-xetex


report: ./report/**/*.md
	cd report && make clean report open

presentations:
	@cd report/ && for presentation in presentations/*.md; do \
		filename=$${presentation##*/}; \
		pdf_name=$${filename%.md}; \
		echo "Building $$pdf_name"; \
		make "$$pdf_name"; done


hz: 
	@echo here's your hertz's formula
	@echo "zcr_hz = sum(1 for i in range(1, len(signal)) if signal[i-1] * signal[i] < 0) * (sample_rate / (2 * (len(signal) - 1)))" > hz_formula.terse
	@echo "cat hz_formula.terse"