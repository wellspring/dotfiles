function append_if_notexist --description 'append_if_notexist <line> <file>'
	grep -qFx $argv[1] $argv[2]; or echo $argv[1] | tee -a $argv[2] >/dev/null
end
