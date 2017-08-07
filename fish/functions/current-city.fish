function current-city
	curl http://ip-api.com/json | jq -r .city
end
