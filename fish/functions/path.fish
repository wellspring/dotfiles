function path --description display\ the\ current\ \\\$PATH\ \(one\ per\ line\)
	echo $PATH | sed 's/ /\n/g'
end
