function livecoding.play.tv --description 'Play a livecoding stream on the TV (using kodi)'
	send2kodi -u (livecoding.url $argv)
end
