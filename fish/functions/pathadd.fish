function pathadd --description 'Add a path to the $PATH variable'
	for p in $argv
    if test -d $p
      set -U fish_user_paths $fish_user_paths $argv;
    else
      echo "Error: not adding path \"$p\" since the directory doesn't exists. Is it a mistake?"
    end
  end
end
