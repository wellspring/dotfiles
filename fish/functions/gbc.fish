function gbc --description 'git branch cleaning process (list merged + non-merged branches)'
  echo "Non merged branch to work on:"
  git branch -a --no-merged | grep --color=none /william/ | sed 's_^\s*remotes/origin/__' | indent
  echo
  echo "Merged branches (to REMOVE):"
  git branch -a --merged | grep --color=none /william/ | sed 's_^\s*remotes/origin/__' | indent
end
