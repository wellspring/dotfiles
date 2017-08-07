function extract-dois --description 'extract all the DOIs from stdin'
	cat | perl -pe 's/\/[\n\r\t ]*/\//m' | grep -Poi '(10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?![%"#? ])\S)+)' | sed 's/[-.,:;\'"]$//'
end
