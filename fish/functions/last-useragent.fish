function last-useragent
	wget -qO- "https://user-agents.me/chrome/stable" | grep -o "Mozilla/[^\"'>]*OS X[^<\"']*" | head -1
end
