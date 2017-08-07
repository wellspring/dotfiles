#!/usr/bin/bash
# ./example.sh  | lemonbar -p -g 1920x40 -B '#000000' -F '#FFFFFF' -u 2 -f 'Droid Sans:size=13' -f 'FontAwesome:size=13'

S="//"
currently(){ cat /tmp/$USER.CURRENTLY; }
music()   { playerctl status &>/dev/null && echo '  [[  ' $(playerctl status | sed 's/Paused//;s/Playing//;s/...*/[&]/') ' ' $(playerctl metadata artist) — $(playerctl metadata title | sed 's/ - /, /g') '  ]]  ' || echo '  > > >      E N J O Y I N G      S I L E N C E      < < <  '; }
vpn()     { echo '%{F#ff5555}VPN%{F-}'; }
eth()     { ip addr show dev eth | awk -F'[ /]*' '/scope global/ {print "ETH: "$3;exit 1}' && echo '%{F#ff5555}ETH%{F-}'; }
wifi()    { echo "WIFI: $(ip addr show dev wifi | awk -F'[ /]*' '/scope global/ { print $3 }') (on $(iwconfig wifi | awk -F'"' '/ESSID/{print $2}'))"; }
mem()     { echo '%{U#e97f02}%{+u}RAM: ???%{-u}%{U-}'; }
cpu()     { echo '%{U#e97f02}%{+u}CPU: ???%{-u}%{U-}'; }
battery() { batteryinfo | awk -F': *' '/^charge:/{bat=$2+0; if(bat<20){color="red";icon=""} else if(bat<40){color="orange";icon=""} else{color="yellow";icon=""}; if(bat>80){icon=""} else if(bat>60){icon=""}} /^status:/{if($2 != "Discharging"){color="white";extra=" [CHR]"}} END{ print "%{F"color"}"icon" "bat"%"extra"%{F-}" }'; }
volume()  { amixer sget Master | awk -F '[][]' '/\[on\]/{print " "$2;exit 1}' && echo '%{F#ff5555}[MUTE]%{F-}'; }

while true
do
  echo -n "%{l}%{F#666666}    // Currently: %{F#aaaaaa}$(currently)%{F-}"
  echo -n "%{c}%{R}$(music)%{R}"
  echo -n "%{r}$(vpn)$(eth)$(wifi)$S$(mem)$S$(cpu)$S$(battery)$S$(volume)"
  echo
  sleep 0.1
done
