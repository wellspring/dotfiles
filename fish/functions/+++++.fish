function +++++ --description 'print "+++++" multiple times as a separator (e.g. +++++ x 20)'
	set -q argv[2]; and set -l length $argv[2]; or set -l length $COLUMNS;
	perl -e "print '+' x $length"
  echo
end
