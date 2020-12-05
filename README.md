Script to monitor repositories, and keep a reference of when a tag first appeared on these repositories.

Add the repositories to monitor to repositories.csv
Run 'make' at least once a day. 
When make is run more frequent than once a day, the results will be computed only once for each individual repo. It will allow tracking new repositries though.

The follwing dependencies are required:
- make 
- awk
- jo (JSON report)
