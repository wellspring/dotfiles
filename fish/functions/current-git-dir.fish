function current-git-dir -d "Return the root path of the current git project"
  git rev-parse --show-toplevel
end
