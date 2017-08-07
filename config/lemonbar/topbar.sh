#!/usr/bin/bash
# ./example.sh  | lemonbar -p -g 1920x40 -B '#000000' -F '#FFFFFF' -u 2 -f 'Droid Sans:size=13' -f 'FontAwesome:size=13'

workspaces() { i3-msg -t get_workspaces | jq -r $'.[] | "  %{F"+(if .urgent then "#ff0000" elif .focused then "#cccccc" else "#333333" end)+"}"+.name+"%{F-}  "' | sed 's/[0-9]://g' | tr -d '\n'; }
clock() { echo `date +'    %a %d %b, %H:%M:%S  '`; }

while true
do
  echo -n "%{l} $(workspaces)"
  echo -n "%{c}%{U#c02942}%{+u}    $(clock)   %{-u}%{U-}"
  echo -n "%{r}%{F#ff4444}%{F-}   "
  echo
  sleep 0.1
done
