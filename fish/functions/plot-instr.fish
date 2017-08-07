function plot-instr -d "show the use of instructions in a binary (usage: plot-instr <xor,or,and>)"
  set -l font 'Open Sans Light,10'

  set -l file $argv[1]
  set -l instr (echo -n $argv[2..-1] | tr '\n' ' ' | downcase | sed 's/^\s*//;s/\s*$//; s/[^a-za-z]/|/g')

	command objdump -CgdM intel $file \
    | awk -F"[\t :]+" "/\s($instr)\s/ { print strtonum(\"0x\"\$2) }" \
    > /tmp/data
  gnuplot --persist -e "set terminal wxt size 700,400 enhanced font '$font' persist rounded dashed;
                      bin(x, s) = s*int(x/s);
                      set zeroaxis;
                      set style data points;
                      set boxwidth 0.05;
                        set title '$file';
                        set xlabel 'virtual address (in memory)';
                        set ylabel 'occurences of "(echo "$instr" | upcase | sed "s_[|]_/_g")"';
                        plot \
                             '/tmp/data' u (bin(\$1,0.05)):(20/300.) smooth freq t 'smooth frequency' w boxes"
                             #plot '/tmp/data' using 1:0,
end

