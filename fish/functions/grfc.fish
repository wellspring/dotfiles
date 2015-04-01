function grfc --description 'Search for RFC by title (using a pre-generated file)'
	grep --color=always -i "$argv" /disk/doc/rfc/index.lst; 
end
