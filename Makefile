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


folder:
	mkdir -p reports/$(TODAY)

	# Clean old reports (older than today).
	find reports -type d \! -wholename 'reports/$(TODAY)' \! -wholename 'reports' -delete

report_makefile:: repositories.csv
	# Rebuild a makefile based on the repository list.
	awk -f createmake.awk -v TODAY=$(TODAY) repositories.csv > report_makefile

clean:
	rm -f report_makefile report.csv newreport.csv
	touch report.csv
	rm -rf reports

.PHONY: clean folder all daily_report downloads

repositories.csv:
Makefile:
