BEGIN {
	print "all: daily_report"
}

{
	URI=$1
	SANITIZED=$1
	gsub(/\//, "_", SANITIZED)
	gsub(/:/, "_", SANITIZED)
	gsub(/\./, "_", SANITIZED)
	gsub(/@/, "_", SANITIZED)
	
	print "reports/"TODAY"/"SANITIZED".tags:"
	print "\tgit ls-remote --tags "URI" | awk -f reportprocessor.awk -v URI="URI" -v TODAY="TODAY" > reports/"TODAY"/"SANITIZED".tags"
	TARGETS = TARGETS" reports/"TODAY"/"SANITIZED".tags"
}

END{print "download:" TARGETS}
