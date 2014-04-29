function restart -d 'Restart the specified service.'
    switch $os
        case arch
            RUN_AS_ROOT systemctl restart $argv[1]
        case gentoo
            RUN_AS_ROOT /etc/init.d/$argv[1] restart
        case debian
            RUN_AS_ROOT service $argv[1] restart
        case '*'
            echo "Command not supported on this Operating System."
    end
end

