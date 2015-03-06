# ********************************************************************* #
#                            * config.fish *                            #
#                              ~~~~~~~~~~~                              #
#   Author         : wellspring <wellspring.fr A T gmail.com>           #
#   Description    : BASHrc/ZSHrc mix of configurations (dotfiles...)   #
#   Last modified  : 27/02/2015                                         #
#   Version        : 1.8.2                                              #
# ********************************************************************* #

# Configure the environment variables
set -x TERMINAL st
set -x BROWSER chromium
set -x SUDO_EDITOR vim
set -x SVN_EDITOR vim
set -x EDITOR vim
set -x VISUAL vim
set -x PAGER less

#set -x CDPATH ...
#set -x PATH ...
set -x SBT_OPTS "-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
set -x VMWARE_USE_SHIPPED_GTK yes
set -x RAILS_ENV development


# Configure fish to use oh-my-fish themes/plugins...
#set fish_plugins archlinux autojump bundler extract gi localhost node rake rvm
set fish_complete_path ~/.config/fish/completions /etc/fish/completions /usr/share/fish/completions
set fish_function_path ~/.config/fish/prompt ~/.config/fish/functions /etc/fish/functions /usr/share/fish/functions

# Define an exit handler (also possible to use trap)
function on_exit --on-process %self
    echo fish is now exiting
end

# Load each auto-load files
for file in ~/.config/fish/autoload/**
    . $file
end

