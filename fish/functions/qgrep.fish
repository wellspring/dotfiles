function qgrep --description 'grep texts inside quotes (Usage: qgrep <regex> <file [file [...]]>)'
  set -l regex $argv[1]
  set -l files -
  test (count $argv) -gt 1; and set -l files $argv[2..-1]
	grep -Eo '("[^"]*'"$regex"'[^"]*"|\'[^\']*'"$regex"'[^\']*\')' $files | tr -d "\"'" | grep "$regex"
  #grep -o '"[^"]*'"$argv[1]"'[^"]*"' "$argv[2..-1]" | tr -d '"'
  #grep -o "'[^']*""$argv[1]""[^']*'" "$argv[2..-1]" | tr -d "'"
end
