function disasm --description disassemble\ using\ objdump\ \(e.g.\ disasm\ 50\ -\>\ \'push\ eax\'\)
	set -l bin (mktemp)
  hex2binary $argv > $bin
  objdump -D -b binary -mi386 $bin | awk '{if(_) print $0} /<\.data>:/{_=1}'
  rm -f $bin
end
