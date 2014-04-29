set -Ux make_j (echo (cat /proc/cpuinfo | grep -c processor)'*2+1' | bc)

# Aliases
alias build='./configure --prefix=/usr; and make; and RUN_AS_ROOT make install'
alias nomake='/usr/bin/make -s'
alias vcm='vi **/CMakeLists.txt'
alias make="make -j$make_j"
alias mk='make'
alias mi='RUN_AS_ROOT make install'
alias cm='cmake -H. -Bbuild; and cd build; and make'
alias menuconfig='nomake menuconfig'

