# config files

## Installation

Clone the repository (with submodules) :
```bash
    $ git clone --recursive https://github.com/wellspring/dotfiles.git /usr/share/dotfiles
```
Create symlinks :
```bash
    $ for file in /usr/share/dotfiles/*; do ln -sf $file ~/.$(basename "$file"); done
    $ ln -s /usr/share/dotfiles ~/.dotfiles
    $ rm ~/.README.md
```
## Update

Use the pull-submodules command from gitconfig :
```bash
    (cd ~/.dotfiles && git pull-submodules)
```
