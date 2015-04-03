function ansi256 --description 'Display all the 256-colors of the terminal (if available)'
	for i in (seq 1 (tput colors))
    echo -n (tput setaf $i)"$i"(tput setab 0)" "
  end
  echo
end
