function psg --description 'ps + grep'
	ps auxww | grep $argv | grep -vv grep
end
