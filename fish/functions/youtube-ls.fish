function youtube-ls --description 'List videos from a youtube user (e.g. youtube-ls cauetofficiel)'
	curl -s "https://www.youtube.com/user/$argv/videos" | awk -F\" '/yt-lockup-title/ {print "https://www.youtube.com"$14};'
end


