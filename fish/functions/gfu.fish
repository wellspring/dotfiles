function gfu --description 'grep through fish user defined functions'
	functions -a | grep $argv;
end
