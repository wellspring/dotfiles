# Aliases
alias lll 'ls -la | less'
alias ll  'ls -l'
alias mm  'll'
alias l   'ls -dF'
alias la  'ls -la'
alias lh  'ls -lh'

# Other aliases
function lsbig --description 'List the 10 biggest files/folders in the specified directory.'
    du -sh $argv/* | sort -rh | head
end
alias duf 'du -sh * | sort -h'
alias duh 'du -sh .'
alias dfh 'df -lPH'

