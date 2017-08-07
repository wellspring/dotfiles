function location
	curl http://ip-api.com/json | jq -r .city,.regionName,.country
end
