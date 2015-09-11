function workon --description 'Create a new branch to work on a task defined on redmine'
  set -l issue_id (redmine-issue-id $argv)
  set -l issue_name (redmine-issue-name $argv)
  set -l issue_name_nospace (echo $issue_name | sed 's/[^A-Za-z0-9 ]//g;  s/ \([A-Za-z0-9]\)/-\1/g;  s/[A-Z]/\L&/g')

  if test -z "$issue_name_nospace"
    echo "Error: task not found. Is '$argv[1]' a correct url or issue number?"
    return -1
  end

  set -l new_branch {$REDMINE_USER}/{$issue_id}-{$issue_name_nospace}
  git checkout -b $new_branch

  set -l desc_file (current-git-dir)/.git/BRANCH_DESCRIPTION
  set -l issue_url (redmine-issue-url $argv | sed 's/\.json$//')
  echo "-----" > $desc_file
  echo "issue id ............. #$issue_id" >> $desc_file
  echo "issue name ........... $issue_name" >> $desc_file
  echo "issue url ............ $issue_url" >> $desc_file
  echo "branch name .......... $new_branch" >> $desc_file
  echo "author ............... $REDMINE_USER" >> $desc_file
  echo "-----" >> $desc_file
end
