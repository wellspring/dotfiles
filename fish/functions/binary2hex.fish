function binary2hex --description 'Convert string binary to hex string (e.g. binary2hex ABCD -> 41424344)'
  echo -n "$argv" | xxd -p
end

