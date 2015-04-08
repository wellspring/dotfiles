function vim-profiling --description 'Profile vim (in details)'
	set -l file /tmp/vim.profiling.log
  vim --cmd "profile start $file" \
      --cmd 'profile func *' \
      --cmd 'profile file *' \
      $argv
  less +G $file
  echo $file
end
