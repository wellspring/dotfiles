function cgrep --description 'context grep (grep -o ........<REGEX>.........)'
	set -l context_size 30
  set -l regex $argv[1]
  set -l files -
  test (count $argv) -gt 1; and set -l files $argv[2..-1]
  #set -l context ".{0,$context_size}"
  #cat $files | grep -Eo "$context""$regex""$context" | grep "$regex"
  awk "/$regex/ { match(\$0, /$regex/); print substr(\$0, RSTART - $context_size, RLENGTH + ($context_size)*2); }" $files | grep "$regex"
end
