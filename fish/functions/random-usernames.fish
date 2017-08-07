function random-usernames --description 'Generate 30 random usernames'
	curl 'http://www.spinxo.com/services/NameService.asmx/GetNames' -H 'Content-Type: application/json; charset=utf-8' -H 'X-Requested-With: XMLHttpRequest' --data '{"snr":{"Stub":"username"}}' | jq -r '.d[]'
end
