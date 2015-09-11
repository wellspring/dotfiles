function redmine-issue-url --description "Compute the redmine issue api url (json) from it's #id or url"
  if test (count $argv) -ne 1
    echo "Usage: $_ <url_OR_issue#>"
    return -1
  end

  echo $argv | tr -d '#' | awk '!/^http/{printf "'$REDMINE_URL'issues/"} //{print $0".json"}'
end
