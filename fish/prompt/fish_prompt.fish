# name: Cor
# Display the following bits on the left:
# * Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# * Current user
# * Current compressed directory name
# * return status if not 0

function fish_prompt
  set -l last_status $status
  set -l yellow (set_color ffff33)
  set -l dark_yellow (set_color ffb266)
  set -l red (set_color red)
  set -l green (set_color 80ff00)
  set -l normal (set_color normal)
  set -l dark_green (set_color 006600)
  set -l pink (set_color ff55ff)
  set -l pink2 (set_color ff00ff)

  # Prompt
  set -l prompt
  if [ "$UID" = "0" ]
    set prompt "$red# "
  else
    set prompt "$normal% "
  end

  # output the prompt, left to right

  # Add a newline before prompts
  #echo -e ""

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b cyan black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end
  if test $last_status -ne 0
    set ret_status $red $last_status '↵' $normal
  end

  # Display the current directory name
  set -l gitpath (git rev-parse --show-toplevel ^/dev/null)
  if test -n "$gitpath"
    set -l gitrepo (basename $gitpath)
    set -l gitpwd (git rev-parse --show-prefix)
    #set pwd {$pink2}\({$pink}git:{$gitrepo}{$pink2}\){$yellow}{/$gitpwd}
    #set pwd {$yellow}\(\(git:{$pink}{$gitrepo}{$yellow}\)\){/$gitpwd}
    set pwd {$yellow}\(git:{$pink}{$gitrepo}{$yellow}\){/$gitpwd}
  else
    set pwd $yellow(pwd | sed "s:^$HOME:~:")
  end

  # Display the prompt and terminate with a nice prompt char
  echo -n -s $green "<"(whoami)">" $dark_green ' ' $pwd $ret_status $dark_yellow \$ $normal
  echo -n -s ' ' $normal

end
