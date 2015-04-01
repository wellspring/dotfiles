# ********************************************************************* #
#                            * config.fish *                            #
#                              ~~~~~~~~~~~                              #
#   Author         : William Hubault                                    #
#   Description    : fish shell configuration                           #
#   Last modified  : 17/03/2015                                         #
#   Version        : 1.9.0                                              #
# ********************************************************************* #

# Configure the environment variables
set -x EDITOR "vim -X --noplugin"
set -x SVN_EDITOR "$EDITOR"
set -x SUDO_EDITOR "$EDITOR"
set -x VISUAL "vim"
set -x PAGER "less"
set -x BROWSER "chromium"
set -x TERMINAL "st"

set -x SBT_OPTS "-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
set -x VMWARE_USE_SHIPPED_GTK yes
set -x RAILS_ENV development

# Configure paths
#set -x CDPATH ...
#set -x PATH ...

# Configure fish paths
set fish_complete_path ~/.config/fish/completions /etc/fish/completions /usr/share/fish/completions
set fish_function_path ~/.config/fish/prompt ~/.config/fish/functions /etc/fish/functions /usr/share/fish/functions

