function gmail --description 'Get the number of unread mails in the Inbox of GMail (Usage: gmail <username>)'
	set -l gmailuser william.hubault@gmail.com
  if count $argv >/dev/null
    set gmailuser $argv[1]
  end
  curl -u "$gmailuser" --silent "https://mail.google.com/mail/feed/atom" | sed -e 's/<\/fullcount.*/\n/' | sed -e 's/.*fullcount>//'
end
