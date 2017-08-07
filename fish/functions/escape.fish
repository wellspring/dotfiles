function escape --description 'URI escape()'
	perl -MURI::Escape -lne 'print uri_escape($_)'
end
