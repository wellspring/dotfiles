# prelink
# Autogenerated from man page /usr/share/man/man8/prelink.8.gz
# using Deroffing man parser
complete -c prelink -o v--verbose --description 'Verbose mode.'
complete -c prelink -o n--dry-run --description 'Don\'t actually prelink anything; just collect t… [See Man Page]'
complete -c prelink -s a -l all --description 'Prelink all binaries and dependent libraries fo… [See Man Page]'
complete -c prelink -s m -l conserve-memory --description 'When assigning addresses to libraries, allow ov… [See Man Page]'
complete -c prelink -s R -l random --description 'When assigning addresses to libraries, start wi… [See Man Page]'
complete -c prelink -s r -l reloc-only --description 'Instead of prelinking, just relink given shared… [See Man Page]'
complete -c prelink -s N -l no-update-cache --description 'Don\'t save the cache file after prelinking.'
complete -c prelink -s c -l config-file --description 'Specify an alternate config file instead of def… [See Man Page]'
complete -c prelink -s C -l cache-file --description 'Specify an alternate cache file instead of defa… [See Man Page]'
complete -c prelink -s f -l force --description 'Force re-prelinking even for already prelinked … [See Man Page]'
complete -c prelink -s q -l quick --description 'Run prelink in quick mode.'
complete -c prelink -s p -l print-cache --description 'Print the contents of the cache file (normally R /etc/prelink.'
complete -c prelink -l dynamic-linker --description 'Specify an alternate dynamic linker instead of the default.'
complete -c prelink -l ld-library-path --description 'Specify a special R LD_LIBRARY_PATH to be used … [See Man Page]'
complete -c prelink -l libs-only --description 'Only prelink ELF shared libraries, don\'t prelink any binaries.'
complete -c prelink -s h -l dereference --description 'When processing command line directory argument… [See Man Page]'
complete -c prelink -s l -l one-file-system --description 'When processing command line directory argument… [See Man Page]'
complete -c prelink -s u -l undo --description 'Revert binaries and libraries to their original… [See Man Page]'
complete -c prelink -s y -l verify --description 'Verifies a prelinked binary or library.'
complete -c prelink -l md5 --description 'This is similar to  --verify option, except ins… [See Man Page]'
complete -c prelink -l sha --description 'This is similar to  --verify option, except ins… [See Man Page]'
complete -c prelink -l exec-shield -l no-exec-shield --description 'On IA-32, if the kernel supports Exec-Shield, p… [See Man Page]'
complete -c prelink -s b -l black-list --description 'This option allows blacklisting certain paths, … [See Man Page]'
complete -c prelink -s o -l undo-output --description 'When performing an  --undo operation, don\'t ove… [See Man Page]'
complete -c prelink -s V -l version --description 'Print version and exit.'
complete -c prelink -s v -l verbose --description 'Verbose mode.'
complete -c prelink -s n -l dry-run --description 'Don\'t actually prelink anything; just collect t… [See Man Page]'
complete -c prelink -s '?' -l help --description 'Print short help and exit.'
