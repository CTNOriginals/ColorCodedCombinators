# Filters factorio-current.log down to the lines logged by one mod.
# Usage: awk -v mod="__mod-name__" -f mod-log.awk

BEGIN { prefix = "Script @" mod "/"; dim = "\033[2m"; reset = "\033[0m" }

# Every new log entry starts with a timestamp; continuation lines do not
/^ *[0-9]+\.[0-9]+ / {
	mine = 0

	# Header line: "   0.000 2026-11-16 00:03:15; Factorio ..."
	if ($1 == "0.000" && $2 ~ /^[0-9]+-/ && $3 ~ /;$/) {
		sub(/;$/, "", $3)
		printf "\n%s--- game started %s ---%s\n", dim, $3, reset
		fflush()
		next
	}

	i = index($0, prefix)
	if (i) {
		rest = substr($0, i + length(prefix))
		if (match(rest, /^[^:]*:[0-9]+:/)) {
			printf "%s%s %s%s%s\n", dim, $1, substr(rest, 1, RLENGTH), reset, substr(rest, RLENGTH + 1)
		} else {
			print rest
		}
		mine = 1
		fflush()
	}
	next
}

# Continuation line of one of our messages
mine { print; fflush() }
