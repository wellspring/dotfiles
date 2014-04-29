function bootadd -d 'Register the specified service to start at boot time'
    switch $os
        case arch
            RUN_AS_ROOT systemctl enable $argv[1]
        case gentoo
            RUN_AS_ROOT rc-update add $argv[1] default
        case debian
            RUN_AS_ROOT update-rc.d $argv[1] defaults
        case '*'
            echo "Command not supported on this Operating System."
    end
end

