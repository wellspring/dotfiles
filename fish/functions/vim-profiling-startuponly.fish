function vim-profiling-startuponly --description 'Profile vim startup time (in details)'
	set -l file /tmp/vim.startup.profiling.log
  vim --cmd "profile start $file" \
      --cmd 'profile func *' \
      --cmd 'profile file *' \
      -c 'profdel func *' \
      -c 'profdel file *' \
      -c 'qa!' \
      $argv
  less +G $file
  echo $file
end
