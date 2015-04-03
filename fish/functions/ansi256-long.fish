function ansi256-long --description 'Display all fg/bg 256-colors of the terminal (if available)'
	for i in (seq 0 256)
    echo -n (tput setaf $i)"color #$i "
    echo -n (tput setab $i)"          "
    echo (tput setab 0)
  end
end
