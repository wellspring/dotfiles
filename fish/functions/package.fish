function package --description 'Cross platform package manager.'
	set a $argv[2..-1]
    switch $argv[1]

        case help
            echo "Usage: package install <package-name> [...]"
            echo "Usage: package remove <package-name> [...]"
            echo "Usage: package search <package-name>"
            echo "Usage: package info <package-name>"
            echo "Usage: package files <package-name>"
            echo "Usage: package thathave <file>"
            echo "Usage: package installed"
            echo "Usage: package upgrade"

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
                    yaourt -S --needed $a
                    #or: RUN_AS_ROOT pacman -S --needed $a
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

        case remove uninstall
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

        case show info query
            switch $os
                case arch
                    yaourt -Sii $a
                    #or: RUN_AS_ROOT pacman -Sii $a
                case debian
                    RUN_AS_ROOT aptitude show $a
                    #or: RUN_AS_ROOT apt-cache show $a
                case osx
                    brew info $a
                case '*'
                    echo "Command not supported on this Operating System."
            end

        case 'bin*'
            pkg list $a | grep --color=never 'bin/.'
        case 'lib*'
            pkg list $a | grep --color=never 'lib/.'
        case list 'file*'
            switch $os
                case arch
                    yaourt -Ql $a
                    #or: RUN_AS_ROOT pacman -Ql $a
                case debian
                    RUN_AS_ROOT apt-file list $a
                case osx
                    brew list $a
                case '*'
                    echo "Command not supported on this Operating System."
            end

        case installed
            switch $os
                case arch
                    yaourt -Qet
                    #or: RUN_AS_ROOT pacman -Qet
                case debian
                    dpkg --get-selections
                case osx
                   brew list
                case '*'
                    echo "Command not supported on this Operating System."
            end

        case thathave
            switch $os
                case arch
                    yaourt -Qo
                    #or: RUN_AS_ROOT pacman -Qo
                case '*'
                    echo "Command not supported on this Operating System."
            end

        case '*'
            switch $os
                case arch
                    yaourt $a
                    # or: RUN_AS_ROOT pacman $a
                case gentoo
                    RUN_AS_ROOT emerge $a
                case debian
                    RUN_AS_ROOT aptitude $a
                case osx
                    brew $a
                case '*'
                    echo "Command not supported on this Operating System."
            end
    end
end
