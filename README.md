# dot Files

This is the personal collection of wellspring.
It's a merge from different good ideas found on internet.
I don't always use all stuff, some are used more or less often.

please Read The Fine Manual for more information...


## Installation

Clone the repository :

    git clone git://github.com/wellspring/dotfiles.git ~/.dotfiles

Switch to the `~/.dotfiles` directory, and fetch submodules :

    (cd ~/.dotfiles && git submodule update --init --recursive)

Create symlinks :

    for file in ~/.dotfiles/*; do ln -sf $file ~/.$(basename "$file"); done
    rm ~/.README.md


## Update

Use the pull-submodules command from gitconfig :

    (cd ~/.dotfiles && git pull-submodules)

