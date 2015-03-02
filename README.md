# dot Files

This is the personal collection of wellspring.
It's a merge from different good ideas found on internet.
I don't always use all stuff, some are used more or less often.

please Read The Fine Manual for more information...


## Installation

Clone the repository (with submodules) :

    git clone --recursive https://github.com/wellspring/dotfiles.git /usr/share/dotfiles

Create symlinks :

    for file in /usr/share/dotfiles/*; do ln -sf $file ~/.$(basename "$file"); done
    ln -s /usr/share/dotfiles ~/.dotfiles
    rm ~/.README.md


## Update

Use the pull-submodules command from gitconfig :

    (cd ~/.dotfiles && git pull-submodules)

