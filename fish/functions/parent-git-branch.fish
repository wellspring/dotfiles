function parent-git-branch
  set -l branch (current-git-branch | sed 's/[^A-Za-z0-9-_]/./g')
  git show-branch | awk -F[][~^@] '/\*/&&!/'$branch'/{print $2;exit}'
end
