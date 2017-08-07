function find-doi
	set -l title (echo $argv | sed 's/\s*([^)]*)//g; s/\.[^.]\+\*\?$//g; s/[^ \/A-Za-z0-9]//; s/ /+/g' | downcase)
  set -l api_key (cat ~/.mendeley.apitoken)

  # Search for the paper (using Mendeley's API)...
  #----
  #DISABLED: I don't trust them.
  #DISABLED: I don't trust them.
  #DISABLED: I don't trust them.
  #----
  #curl "https://api.mendeley.com/search/catalog?query=$title&limit=1" -H "Authorization: Bearer $api_key" -H "Accept: application/vnd.mendeley-document.1+json" | jq -r '.[0]|.identifiers.doi'
  #----
  #DISABLED: I don't trust them.
  #DISABLED: I don't trust them.
  #DISABLED: I don't trust them.
  #----
  #See also: https://www.programmableweb.com/api/crossref-doi-resolver
end
