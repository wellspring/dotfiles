function _____ --description 'print "_____" multiple times as a separator (e.g. _____ x 20)'
	set -q argv[2]; and set -l length $argv[2]; or set -l length $COLUMNS;
	perl -e "print '_' x $length"
  echo
end
