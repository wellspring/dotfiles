function RUN_AS_ROOT --description 'Run the specified function as root'
	if [ $USER = 'root' ]
        eval "$argv"
    else if type -P sudo >/dev/null
        sudo -E $argv
    else if type -P su >/dev/null
        su --shell=/usr/bin/fish --preserve-environment --command "$argv"
    else
        echo "Can't run the command '$argv' as root: sudo/su not found."
    end
end
