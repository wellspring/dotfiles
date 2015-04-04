#!/bin/bash
# Install -> curl -sSL http://j.mp/welldot | sh

# 0- Install dependancies...
# ...

# 1- Clone the repository...
git clone --recursive https://github.com/wellspring/dotfiles.git /usr/share/dotfiles

# 2- Create symlinks...
for file in /usr/share/dotfiles/*; do ln -sf $file ~/.$(basename "$file"); done
ln -s /usr/share/dotfiles ~/.dotfiles
rm ~/.README.md

# 3- Initialize fish & vim
#sh$ fish -c ~/.config/fish/init.fish
#sh$ vim +PlugInstall

