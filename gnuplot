set macros

png="set terminal pngcairo size 1800,1800 crop enhanced font '/usr/share/fonts/truetype/times.ttf,30' dashlength 2; set termoption linewidth 3"
eps="set terminal epslatex size enhanced color colortext fontfile '/usr/share/fonts/truetype/times.ttf'; set termoption linewidth 3;"
svg="set terminal svg size 350,262 fname 'Verdana' fsize 10"

set style line 1 linecolor rgb '#de181f' linetype 1 # Red
set style line 2 linecolor rgb '#0060ae' linetype 1 # Blue
set style line 3 linecolor rgb '#228C22' linetype 1 # Forest green
set style line 4 linecolor rgb '#18ded7' linetype 1 # opposite Red
set style line 5 linecolor rgb '#ae4e00' linetype 1 # opposite Blue
set style line 6 linecolor rgb '#8c228c' linetype 1 # opposite Forest green

#set label 'origin' at 0,0 point lt 1 pt 2 ps 3 offset 1,-1   # draw a point

