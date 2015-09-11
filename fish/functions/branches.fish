function branches --description 'list remote git branches and sort them by date'
  set -l name (git config user.name)
  if test -n "$argv"
    set name $argv
  end

  git for-each-ref --sort=committerdate --format='%(refname:short) * %(authorname) * %(committerdate:relative)' refs/remotes/ | column -t -s '*' | highlight ".*$name.*"
end
