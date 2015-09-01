function routes --description 'Display routes (TODO: currrently only works for Ramaze)'
	grep --color=none -h 'map \'' **/*.rb | grep "/[^']*"
end
