function asm -d "assemble using nasm (e.g. asm 'push ax' -> 6650)"
  set -l src (mktemp)
  echo -ne "BITS 32\n\n$argv" > $src
  nasm $src -O0 -o /dev/stdout | xxd -p $bin
  rm -f $src
end
