function shelp -d "Help summary from a swagger documentation (terminal documentation browser)"
  cat doc/api/latest.json | jq --arg method $argv[1] --arg path $argv[2] -r '.paths[$path][$method|ascii_downcase] | "# "+.summary+"\n\n"+.description+"\n\nParameters:\n- "+(.parameters|map(.name+" ("+.type+"): "+.description)|join("\n- "))+"\n\nSample response:\n"+(.responses["200"].examples["application/json"]|tostring)+"\n"' 2>/dev/null || echo -e "\e[31mError: Endpoint not found. Is the method and path correct?\e[0m"
end
