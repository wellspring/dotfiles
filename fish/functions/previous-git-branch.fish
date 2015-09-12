function previous-git-branch
  git check-ref-format --branch '@{-1}'
end
