# Filters factorio-current.log down to the lines logged by one mod.
# Usage: awk -v mod="mod-name" -v info="path/to/deployed/info.json" -f mod-log.awk

BEGIN {
	modpath = "__" mod "__";
	prefix = "Script @" modpath "/";
	dim = "\033[2m";
	red = "\033[31m";
	reset = "\033[0m"
}

# Reads the version from the deployed info.json, so it is current for every game launch
function read_version(   l, v) {
	v = "?"
	while ((getline l < info) > 0) {
		if (match(l, /"version"[ \t]*:[ \t]*"[^"]*"/)) {
			v = substr(l, RSTART, RLENGTH)
			sub(/"$/, "", v)
			sub(/.*"/, "", v)
			break
		}
	}
	close(info)
	return v
}

# Every new log entry starts with a timestamp; continuation lines do not
/^ *[0-9]+\.[0-9]+ / {
	mine = 0
	pending = 0

	# Error entry: "   2.628 Error AppManagerStates.cpp:1683: <mod> 0.1.7 errored ..."
	if ($2 == "Error") {
		line = dim $1 reset " " red substr($0, index($0, "Error")) reset
		if (index($0, mod)) {
			print line
			mine = 1
			fflush()
		} else {
			# Mod may only be named in a continuation line, so hold the header until then
			buf = line
			pending = 1
		}
		next
	}

	# Header line: "   0.000 2026-11-16 00:03:15; Factorio ..."
	if ($1 == "0.000" && $2 ~ /^[0-9]+-/ && $3 ~ /;$/) {
		sub(/;$/, "", $3)
		printf "\n%s--- %s (v%s) %s ---%s\n", dim, mod, read_version(), $3, reset
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
mine { print; fflush(); next }

# Continuation line of an error that has not mentioned our mod yet
pending {
	buf = buf "\n" $0
	if (index($0, modpath)) {
		print buf
		mine = 1
		pending = 0
		fflush()
	}
}
