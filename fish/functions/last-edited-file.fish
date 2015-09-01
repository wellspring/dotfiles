function last-edited-file --description 'Find in history which is the last file that has been edited'
	history | awk '/^([ns]?vim?|emacs|nano)/{print $2;exit}'
end
