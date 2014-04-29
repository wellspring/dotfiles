function reload -d 'Reload the configuration of the specified service.'
    switch $os
        case arch
            RUN_AS_ROOT systemctl reload $argv[1]
        case gentoo
            RUN_AS_ROOT /etc/init.d/$argv[1] reload
        case debian
            RUN_AS_ROOT service $argv[1] reload
        case '*'
            echo "Command not supported on this Operating System."
    end
end

