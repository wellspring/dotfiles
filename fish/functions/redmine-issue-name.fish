function redmine-issue-name --description Retreive\ a\ redmine\ issue\ name/subject\ from\ it\'s\ \#id\ or\ url
  curl -sH "X-Redmine-API-Key: $REDMINE_KEY" (redmine-issue-url $argv) | jq -r '.issue.subject'
end
