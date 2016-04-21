function append_if_notexist.asroot --description 'append_if_notexist <line> <file>'
	grep -qFx $argv[1] $argv[2]; or echo $argv[1] | RUN_AS_ROOT tee -a $argv[2] >/dev/null
end
