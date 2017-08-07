function plot-instr-withpoweroftwo-stats -d "show the occurences of power of two as src (usage: plot-instr-withpoweroftwo-stats <file>)"
  set -l font 'Open Sans Light,10'

  set -l file $argv[1]

	command objdump -CgdM intel $file \
    | grep -o '0x[1248]0*$' \
    | awk '{print strtonum($0)}' \
    | sort -n \
    | uniq -c \
    | awk '{printf("%d 0x%x (%d)\n", $1, $2, $2)}' \
    | column -t \
    | gnuplot --persist -e "set terminal wxt size 700,400 enhanced font '$font' persist rounded dashed;
                            set style data histogram;
                            set style histogram rowstacked;
                            set style fill solid;
                            set boxwidth 0.8;
                            set yrange [0:*];
                            set title '$file';
                            set xlabel 'Number';
                            set ylabel 'Occurences in instructions (as SRC only, not DEST)';
                            plot '-' using 1:xtic(2) notitle with histograms"
end

