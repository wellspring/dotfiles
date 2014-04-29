function bootdel -d 'Unegister the specified service to NOT start at boot time'
    switch $os
        case arch
            RUN_AS_ROOT systemctl disable $argv[1]
        case gentoo
            RUN_AS_ROOT rc-update del $argv[1] default
        case debian
            RUN_AS_ROOT update-rc.d -f $argv[1] remove
        case '*'
            echo "Command not supported on this Operating System."
    end
end

