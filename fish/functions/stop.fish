function stop -d 'Stop the specified service.'
    switch $os
        case arch
            RUN_AS_ROOT systemctl stop $argv[1]
        case gentoo
            RUN_AS_ROOT /etc/init.d/$argv[1] stop
        case debian
            RUN_AS_ROOT service $argv[1] stop
        case '*'
            echo "Command not supported on this Operating System."
    end
end

