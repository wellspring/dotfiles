# Alias for defined functions
alias xx='extractlast'
alias x='extract'

# Package manager
alias a='package'
alias ai='package install'
alias as='package search'
alias ar='package remove'

alias sysupdate='package upgrade'

if [ $os = 'gentoo' ]
    alias perlupdater='emerge -av1 (qfile /usr/lib/perl* -Cq | sort -u)'
    alias x86emerge='env ACCEPT_KEYWORDS="~x86" package install'
    alias aemerge='package install'
    alias pemerge='package install -pf'
    alias femerge='package install -fv'
    alias temerge='time package install'
    alias umerge='package remove'
    alias vmake="$EDITOR /etc/make.conf"
    alias vuse="$EDITOR /etc/portage/package.use"
    alias vkeyw="$EDITOR /etc/portage/package.keywords"
end

