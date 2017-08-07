function firefox-addons --description 'List firefox addons'
	echo Addons installed on firefox: | colorize 198
  jq -r '.addons[].name' ~/.mozilla/firefox/*/addons.json | indent
end
