function extract-isbn-from-amazon --description 'Extract the ISBN of the book form Amazon.com'
	for url in $argv
    curl "$url" | awk -F'[<>]' '/a-size-base a-color-base/&&/[0-9]</ { gsub(/[^0-9]/,"",$3); print $3; exit }'
  end
end
