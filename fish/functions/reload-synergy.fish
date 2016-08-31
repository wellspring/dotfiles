function reload-synergy
	killall -9 synergys
  synergys >/dev/null 2>/dev/null &
end
