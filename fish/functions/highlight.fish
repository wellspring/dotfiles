function highlight --description 'only highlight specified arguments without filtering out stuff'
	grep --color -E "$argv|\$"
end
