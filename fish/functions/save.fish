function save --description 'Save the last command to cmd_history.txt'
	echo $history[1] >> cmd_history.txt
end
