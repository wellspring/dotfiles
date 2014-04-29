# Fish git prompt
set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

# Aliases
alias git 'hub'
alias g   'git'
alias gd  'git diff'
alias gl  'git rlog'
alias gll 'git slog'
alias gs  'git status'
alias gc  'git commit'
alias gca 'git commit -a'
alias ga  'git add'
alias gt  'git tag'
alias gb  'git branch'
alias gj  'git checkout'
alias gjc 'git checkout -b'
alias gm  'git merge --no-ff'
alias gcl 'git clone'

