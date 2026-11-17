# Filters factorio-current.log down to the lines logged by one mod.
# Usage: awk -v mod="mod-name" -v info="path/to/deployed/info.json" -f mod-log.awk
#
# State:
#   mine    - the current log entry belongs to our mod, so print its continuation lines
#   pending - the current entry is an error that has not mentioned our mod yet
#   buf     - the held lines of a pending error

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

function emit(str) {
	print str
	fflush()
}

# Error entry: "   2.628 Error AppManagerStates.cpp:1683: <mod> 0.1.7 errored ..."
function handle_error(   line) {
	line = dim $1 reset " " red substr($0, index($0, "Error")) reset
	if (index($0, mod)) {
		emit(line)
		mine = 1
	} else {
		# Mod may only be named in a continuation line, so hold the header until then
		buf = line
		pending = 1
	}
}

# Header line: "   0.000 2026-11-16 00:03:15; Factorio ..."
function handle_header(   time) {
	time = $3
	sub(/;$/, "", time)
	emit(sprintf("\n%s--- %s (v%s) %s ---%s", dim, mod, read_version(), time, reset))
}

# Mod line: "   5.123 Script @__mod__/control.lua:12: message"
function handle_mod_line(   i, rest) {
	i = index($0, prefix)
	if (!i) return

	rest = substr($0, i + length(prefix))
	if (match(rest, /^[^:]*:[0-9]+:/)) {
		emit(sprintf("%s%s %s%s%s", dim, $1, substr(rest, 1, RLENGTH), reset, substr(rest, RLENGTH + 1)))
	} else {
		emit(rest)
	}
	mine = 1
}

# Continuation line of an error that has not mentioned our mod yet
function handle_pending() {
	buf = buf "\n" $0
	if (index($0, modpath)) {
		emit(buf)
		mine = 1
		pending = 0
	}
}

# Every new log entry starts with a timestamp; continuation lines do not
/^ *[0-9]+\.[0-9]+ / {
	mine = 0
	pending = 0

	if ($2 == "Error") handle_error()
	else if ($1 == "0.000" && $2 ~ /^[0-9]+-/ && $3 ~ /;$/) handle_header()
	else handle_mod_line()
	next
}

mine { emit($0); next }
pending { handle_pending() }
