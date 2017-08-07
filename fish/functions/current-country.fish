function current-country
	curl http://ip-api.com/json | jq -r .country
end
