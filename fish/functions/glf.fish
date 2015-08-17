function glf --description 'git log FILE (show only the commits of the file specified as an argument)'
	git --no-pager log --pretty=format:'%Creset%C(red bold)[%ad] %C(blue bold)%h %Creset%C(magenta bold)%d %Creset%s %C(green bold)(%an)%Creset' --follow $argv;
end
