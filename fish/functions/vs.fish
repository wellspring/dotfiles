function vs -d 'Attach screen to the currently started vagrant vm'
  set -l gitpath (git rev-parse --show-toplevel ^/dev/null)
  set -l gitrepo (basename $gitpath)_ssh_screen

  # Is there a Vagrant file in the current directory? If not, try to find a vagrant dir, and go to it.
  if test ! -f Vagrantfile
    set -l vagrantdir (ag -g Vagrantfile | head -1)
    if test -n $vagrantdir
      cd (dirname $vagrantdir)
    else
      echo 'Error! Vagrant file not found.'
    end
  end

  # If the machine is not started, start it.
  if [ (vagrant status default | awk '/^default/{print $2}') != 'running' ]
    vagrant up
  end

  # Connect to the vagrant machine in a screen
  #vagrant ssh -c 'sudo aptitude install screen; cd /opt/sparkle; bundle install; rake setup; rake server:start_memcached_dev; rake db:demo_data'
  vagrant ssh -c "screen -t $gitrepo -a -A -U -O -xRR" -- -A
end

