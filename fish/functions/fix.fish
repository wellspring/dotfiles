function fix --description 'git commit --fixup <commit-id>'
	git commit --fixup $argv;
  echo -n '[fixup '(git rev-parse HEAD)']' | clipboard-copy
end
