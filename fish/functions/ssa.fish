function ssa --description 'start ssh-agent and ask the key using ssh-add (30min)'
	ssh-agent -c -t 1800 | sed 's/setenv/set -Ux/' | fish
  ssh-add
end
