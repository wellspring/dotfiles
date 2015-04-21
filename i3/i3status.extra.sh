#!/bin/sh

i3status -c ~/.i3/i3status.conf | while :
do
  read line
  MEM=$(free | awk '/Mem/ {printf "%d%%", $3/$2 * 100.0}')
  (echo $line || exit 1) | sed 's/CPU"},/&{"name":"memory","full_text":"'$MEM' RAM"},/'
done
