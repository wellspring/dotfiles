function unescape --description 'URI unescape()'
	perl -MURI::Escape -lne 'print uri_unescape($_)'
end
