function ssa --description 'start ssh-agent and ask the key using ssh-add'
	ssh-agent -c | sed 's/setenv/set -Ux/' | fish
  ssh-add
end
