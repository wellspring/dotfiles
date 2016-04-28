function update-time
	RUN_AS_ROOT chronyc -a 'burst 4/4'
  RUN_AS_ROOT chronyc -a 'makestep'
end
