function colorize --description 'Colorize the text (using 256 colors), then reset colors'
	tput setaf $argv[1]
  if test (count $argv) -ge 2
   tput setab $argv[2]
  end
  cat
  tput sgr0
end
