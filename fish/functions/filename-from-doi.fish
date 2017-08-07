function filename-from-doi
  for doi in $argv
    #curl http://api.crossref.org/works/$doi | jq -r '.message | .title[0] + "(" + (.["published-print"]["date-parts"][0][0]|tostring) + "; DOI " + .DOI + ").pdf"' | sed 's|/| |g'
    curl -LH "Accept: application/rdf+xml;q=0.5, application/vnd.citationstyles.csl+json;q=1.0" https://doi.org/$doi | jq -r '(.title|gsub("/";" ")) + " (" + (.["published-print"]["date-parts"][0][0]|tostring) + "; DOI " + (.DOI|gsub("/";"@")) + ").pdf"' | sed 's|/| |g'
  end
end
