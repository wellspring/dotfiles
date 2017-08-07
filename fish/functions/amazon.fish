function amazon --description 'Extract book informations form Amazon.com'
	for url in $argv
  curl "$url" | awk -F'[<>]' 'BEGIN{a=1;i=1} /productTitle/{title=$3} /a-size-medium"/{author[a]=$3;a=a+1} /a-size-base a-color-base/&&/[0-9]</{gsub(/[^0-9]/,"",$3);isbn[i]=$3;i=i+1} /bookEdition/{gsub(/[^0-9]/,"",$3);edition=$3} /Add to List/{exit} END{print "---\nTitle: "title"\nAuthor: "author[1]"\nEdition: "edition"\nISBN: "isbn[1]}'
  end
end
