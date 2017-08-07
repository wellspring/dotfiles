function parallel
  set -l arguments (echo "$argv" | sed 's_\\\\_&&_g; s_[\'"$!#?*;&|]_\\\\&_g')
  set -lx PARALLEL_TMUX 'tmux -c zsh'
  set -lx PARALLEL_SHELL 'zsh'
	set -lx SHELL 'zsh'
  #zsh -c "strace -f -s 20000 -o /tmp/strace.log parallel $arguments 2>&1";
  zsh -c "parallel $arguments";
end
