# Try to guess the Operating System name
if grep 'Arch' /etc/issue >/dev/null
    set -Ux os 'arch'
else if grep 'Gentoo' /etc/issue >/dev/null
    set -Ux os 'gentoo'
else if grep 'Debian' /etc/issue >/dev/null
    set -Ux os 'debian'
else if grep 'Ubuntu' /etc/issue >/dev/null
    set -Ux os 'debian'
else
    set -Ux os 'UNKNOWN'
end

