function livecoding.play --description 'Play a live coding stream on livecoding.tv'
  set -l u $argv

  echo -n Playing user (echo $u | colorize 198) ...
  echo -ne "\n  -> stream: "(livecoding.url $u) | colorize 242
  echo -e "\n  -> chat: "(livecoding.url.chat $u) | colorize 242

  vlc --qt-minimal-view (livecoding.url $u) >/dev/null 2>/dev/null &
  #xwinwrap -ov -fs -- mplayer -quiet -wid WID -loop 0 (livecoding.url $u) >/dev/null 2>/dev/null &
end
