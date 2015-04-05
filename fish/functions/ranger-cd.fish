function ranger-cd
	set -l tmpfile (mktemp)
    ranger --choosedir=$tmpfile $argv
    set -l rangerpwd (cat $tmpfile)
    if test "$PWD" != $rangerpwd
        cd $rangerpwd
    end
end
