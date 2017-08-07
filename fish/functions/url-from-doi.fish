function url-from-doi
	for doi in $argv
    extract-redir "https://dx.doi.org/$doi"
  end
end
