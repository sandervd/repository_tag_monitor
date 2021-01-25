INC=reports
TODAY = $(shell date -u +%Y%m%d)
REPORT= reports/$(TODAY)/report.csv
# Disable old suffix rules for better easier debugging.
.SUFFIXES:
.DEFAULT:

include report_makefile

daily_report: $(REPORT)

$(REPORT): folder report_makefile download 
	cat reports/$(TODAY)/*.tags | sort > reports/$(TODAY)/report.csv
	-cat report.csv reports/$(TODAY)/report.csv |sort -k1,1 -k2,2 -k3,3n | sort -u -k1,1 -k2,2 > newreport.csv
	mv newreport.csv report.csv
	cat report.csv | awk '{print $$1"!"$$2"="$$3}' | jo -d! -p > report.json


folder:
	mkdir -p reports/$(TODAY)

	# Clean old reports (older than today).
	find reports -type d \! -wholename 'reports/$(TODAY)' \! -wholename 'reports' -delete

report_makefile:: repositories.csv
	# Rebuild a makefile based on the repository list.
	# The sort is a premature optimization, which helps when ssh is configured with ControlMaster auto
	# and make is executed with the -j option (theoretical).
	cat repositories.csv | sort | awk -f createmake.awk -v TODAY=$(TODAY) > report_makefile

clean:
	rm -f report_makefile report.csv newreport.csv report.json
	touch report.csv
	rm -rf reports

.PHONY: clean folder all daily_report downloads

repositories.csv:
Makefile:
