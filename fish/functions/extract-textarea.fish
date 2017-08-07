function extract-textarea
	pup -p textarea | grep -vP '<\/?textarea.*>'
end
