function findsuid
	find / -user root -perm 4000 -exec ls -ldb {} \;
end
