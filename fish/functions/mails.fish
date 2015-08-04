function mails --description 'extract mail addresses'
	grep -ao '[^@ ]*@[^ ]*'
end
