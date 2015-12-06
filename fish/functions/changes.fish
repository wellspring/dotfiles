function changes --description 'Display how much files/lines changed using git'
	git --no-pager diff master.. --shortstat
end
