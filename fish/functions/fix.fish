function fix --description 'git commit with fixup (syntax: fix <commit-id>)'
	git commit -a --fixup $argv;
end
