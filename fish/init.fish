#!/usr/bin/fish
#-----------------------------------------------------------
# Please run this script before using fish on your computer.
#-----------------------------------------------------------

# Configure the classic environment variables
set -Ux EDITOR "vim --noplugin"
set -Ux SVN_EDITOR "$EDITOR"
set -Ux SUDO_EDITOR "$EDITOR"
set -Ux VISUAL "vim"
set -Ux PAGER "less"
set -Ux BROWSER "firefox"
set -Ux TERMINAL "urxvtc"
# Configure various apps using environement variables
set -Ux LESS "-McifR"
set -Ux TZ "Europe/Paris"
set -Ux SBT_OPTS "-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
set -Ux VMWARE_USE_SHIPPED_GTK yes
set -Ux RAILS_ENV development
# Configure the paths
set -U fish_complete_path ~/.config/fish/completions /etc/fish/completions /usr/share/fish/completions
set -U fish_function_path ~/.config/fish/prompt ~/.config/fish/functions /etc/fish/functions /usr/share/fish/functions
set -U fish_user_paths $fish_user_paths ~/.bin
set -Ux CDPATH . ~

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
switch (awk '{print $1;exit}' /etc/issue)
  case '*Arch*';                                  set -Ux os 'arch'
  case '*Gentoo*';                                set -Ux os 'gentoo'
  case '*Debian*' '*Ubuntu*';                     set -Ux os 'debian'
end

# Try to estimate the best "make -j" option
set -Ux make_j (echo (cat /proc/cpuinfo | grep -c processor)'*2+1' | bc)

# Set the colors for 'ls' (according to dircolors)
set -Ux LS_COLORS (dircolors ~/.dir_colors | awk -F"'" '{print $2;exit}')


# -----
echo Done.
