function contributors
  git log --format='* %aN * <%aE>' | column -t -s '*' | sort | uniq -cw26 | sort -rn | grep -v 'Unknown\s\+<unknown'
end
