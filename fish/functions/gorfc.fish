function gorfc --description 'Search for only obsoleted RFC by title (using a pre-generated file)'
	grfc $argv | grep -e 'Obsoleted[^)]\+'; 
end
