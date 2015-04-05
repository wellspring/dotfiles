function pathadd --description 'Add a path to the $PATH variable'
	set -U fish_user_paths $fish_user_paths $argv;
end
