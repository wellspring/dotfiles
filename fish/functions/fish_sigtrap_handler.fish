function fish_sigtrap_handler --description 'Signal handler for the TRAP signal. Launches a debug prompt.' --no-scope-shadowing --on-signal SIGTRAP
	breakpoint
end
