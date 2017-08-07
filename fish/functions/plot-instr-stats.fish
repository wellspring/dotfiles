function plot-instr-stats -d ""
  set -l font 'Open Sans Light,10'
  set -l file $argv[1]

	command objdump -CgdM intel $file \
    | awk -F'\t+' '{print $3}' \
    | awk '/^[a-z]/{print $1}' \
    | sort \
    | uniq -c \
    | sort -rn \
    | gnuplot --persist -e "set terminal wxt size 700,400 enhanced font '$font' persist rounded dashed;
                            set style data histogram;
                            set style histogram rowstacked;
                            set boxwidth 0.8;
                            set style fill solid;
                            set yrange [0:*];
                            set title '$file';
                            set xlabel 'Instructions';
                            set ylabel 'Occurences';
                            plot '-' using 1:xtic(2) notitle with histograms"
end

