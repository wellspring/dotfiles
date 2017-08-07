function extract-doi --description 'extract the first doi found in stdin'
	extract-dois | head -1
end
