function package -d 'Cross platform package manager.'
    set a $argv[2..-1]
    switch $argv[1]

        case help
            echo "Usage: package <install|remove|search> <package-name> [...]"
            echo "Usage: package <upgrade> [...]"

        case upgrade
            switch $os
                case arch
                    yaourt -Syu
                    #or: RUN_AS_ROOT pacman -Syu
                case gentoo
                    RUN_AS_ROOT layman -S; and RUN_AS_ROOT eix-sync; and RUN_AS_ROOT emerge -uavDN world
                    #or just: RUN_AS_ROOT emerge -uavDN world
                case debian
                    RUN_AS_ROOT aptitude upgrade
                    #or: RUN_AS_ROOT apt-get upgrade
                case osx
                    brew upgrade
                case '*'
                    echo "Command not supported on this Operating System."
            end

        case install
            switch $os
                case arch
                    yaourt -S $a
                    #or: RUN_AS_ROOT pacman -S $a
                case gentoo
                    RUN_AS_ROOT emerge -av
                case debian
                    RUN_AS_ROOT aptitude install $a
                    #or: RUN_AS_ROOT apt-get install $a
                case osx
                    brew install $a
                case '*'
                    echo "Command not supported on this Operating System."
            end

        case remove
            switch $os
                case arch
                    yaourt -R $a
                    #or: RUN_AS_ROOT pacman -R $a
                case gentoo
                    RUN_AS_ROOT emerge -C $a
                case debian
                    RUN_AS_ROOT aptitude remove $a
                    #or: RUN_AS_ROOT apt-get remove $a
                case osx
                    brew rm $a
                case '*'
                    echo "Command not supported on this Operating System."
            end

        case search
            switch $os
                case arch
                    yaourt -Ss $a
                    #or: RUN_AS_ROOT pacman -Ss $a
                case gentoo
                    RUN_AS_ROOT eix $a
                    #or: RUN_AS_ROOT emerge --search $a
                case debian
                    RUN_AS_ROOT aptitude search $a
                    #or: RUN_AS_ROOT apt-cache search $a
                case osx
                    brew search $a
                case '*'
                    echo "Command not supported on this Operating System."
            end

        case '*'
            switch $os
                case arch
                    yaourt $argv
                    # or: RUN_AS_ROOT pacman $argv
                case gentoo
                    RUN_AS_ROOT emerge $argv
                case debian
                    RUN_AS_ROOT aptitude $argv
                case osx
                    brew $argv
                case '*'
                    echo "Command not supported on this Operating System."
            end
    end
end

