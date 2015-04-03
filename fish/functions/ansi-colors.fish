function ansi-colors --description 'Display the 8 ANSI terminal colors'
	echo -n "   "
	for bg in (seq 40 47)
    echo -n "___"$bg"___"
  end

  # Separator
  echo

  for fg in (seq 30 37)
    # Display the foreground HEADER (y axis)
    echo -n "$fg|"

    # For each fg/bg color, display the normal color
    for bg in (seq 40 47)
      echo -en "\e["$fg";"$bg"m Normal \e[0m"
    end

    # Separator
    echo -en "\n  |"

    # For each fg/bg color, display the bold color
    for bg in (seq 40 47)
      echo -en "\e["$fg";"$bg";1m  Bold  \e[0m"
    end

    # Separator
    echo
  end
end
