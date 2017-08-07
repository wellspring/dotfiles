function qgrep-end --description 'grep texts inside quotes ending with... (Usage: qgrep <regex> <file [file [...]]>)'
	set -l regex $argv[1]
  set -l files -
  test (count $argv) -gt 1; and set -l files $argv[2..-1]
	grep -Eo '("[^"]*'"$regex"'"|\'[^\']*'"$regex"'\')' $files | tr -d "\"'" | grep "$regex"
end
