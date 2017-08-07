function book+ --description 'search for a book on libgen.io'
	set -l query (echo $argv | sed 's/ /+/g')

  curl "http://libgen.io/search.php?req=$query&open=0&res=25&view=simple&phrase=1&column=def" | awk '/Edit/,/<\/table>/' | awk 'NR>1' | sed 's/<\/\?a[^>]*>//g' | awk -F '[<>]' 'BEGIN{i=1} /<td/{col[i]=$3;i=i+1} /<\/tr>/{print col[2]"~"col[3]"~"col[5]"~"col[6]" pages~"col[9]; i=1}' | perl -pe 's/,?\s*,?(B\.Sc\.|Ph\.D\.)\s*//g; s/ +/ /g' | column -ts "~"
end
