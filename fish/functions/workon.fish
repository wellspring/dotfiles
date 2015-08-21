function workon --description 'Create a new branch to work on a task defined on redmine'
  if test -z "$argv"
    echo "Usage: workon <url_OR_issue#>"
    return -1
  end

  set -l url (echo $argv | tr -d '#' | awk '!/^http/{printf "'$REDMINE_URL'issues/"} //{print $0".json"}')
  set -l newbranch (curl -sH "X-Redmine-API-Key: $REDMINE_KEY" $url | jq -r '"'$REDMINE_USER'/"+(.issue.id|tostring)+"_\n"+.issue.subject' | sed -e '2 s/[^A-Za-z0-9 ]//g' -e 's/ \([A-Za-z0-9]\)/-\1/g' -e 's/[A-Z]/\L&/g' | tr -d '\n')

  if test -z "$newbranch"
    echo "Error: task not found. Is '$argv[1]' a correct url or issue number?"
    return -1
  end

  git checkout -b $newbranch
end
