function sroutes -d "List endpoints defined in a swagger documentation (terminal documentation browser)"
  cat doc/api/latest.json | jq -r '(.schemes[0]+"://"+.host+."/"+.basePath) as $base | .paths | to_entries | map( (.value|keys[0]|ascii_upcase)+" "+$base+.key+" # "+(.value|.[]|.summary) ) | .[]' | awk '{printf "\x1b[38;5;178m"$1;for(i=0;i<(10-length($1));i++)printf " ";printf "\x1b[38;5;198m"$2;for(i=0;i<(75-length($2));i++)printf " ";print "\x1b[38;5;238m"substr($0,index($0,"#"))}'
end

