# Please run this script before using fish on your computer.
#-----------------------------------------------------------

# Try to guess the Operating System name
set -Ux os 'UNKNOWN'
switch (uname)
  case 'Linux';                                   set -Ux os 'linux'
  case 'Darwin';                                  set -Ux os 'osx'
  case 'FreeBSD';                                 set -Ux os 'freebsd'
  case 'NetBSD';                                  set -Ux os 'netbsd'
  case 'HP-UX';                                   set -Ux os 'hpux'
  case 'AIX';                                     set -Ux os 'aix'
  case 'SunOS';                                   set -Ux os 'solaris'
  case 'Minix';                                   set -Ux os 'minix'
  case 'Windows*' '*MINGW*' '*MSYS*' 'CYGWIN*';   set -Ux os 'windows'
end
switch (cat /etc/issue)
  case 'Arch Linux*';                             set -Ux os 'arch'
  case '*Gentoo*';                                set -Ux os 'gentoo'
  case '*Debian*' '*Ubuntu*';                     set -Ux os 'debian'
end

# Try to estimate the best "make -j" option
set -Ux make_j (echo (cat /proc/cpuinfo | grep -c processor)'*2+1' | bc)

# Set the colors for 'ls' (according to dircolors)
set -Ux LS_COLORS (dircolors ~/.dir_colors | awk -F"'" '{print $2;exit}')

