function lss --description '(alias for ls -Ssh | head)'
	echo Listing the top 15 largest files... | colorize 240
  ls -Ssh $argv | head -15
end
