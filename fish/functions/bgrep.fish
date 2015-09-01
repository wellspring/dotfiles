function bgrep --description 'blame git grep: grep through files but also show the author/commit.'
	git grep -P $argv | awk -F: '{print "\"git --no-pager blame -L "$2","$2" "$1"\""}' | xargs -L1 bash -c | sort;
end
