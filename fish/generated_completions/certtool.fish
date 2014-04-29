# certtool
# Autogenerated from man page /usr/share/man/man1/certtool.1.gz
# using Type1
complete -c certtool -s d -l debug --description 'Enable debugging.'
complete -c certtool -s V -l verbose --description 'More verbose output.'
complete -c certtool -l infile --description 'Input file. sp.'
complete -c certtool -l outfile --description 'Output file. sp.'
complete -c certtool -s s -l generate-self-signed --description 'Generate a self-signed certificate. sp.'
complete -c certtool -s c -l generate-certificate --description 'Generate a signed certificate. sp.'
complete -c certtool -l generate-proxy --description 'Generates a proxy certificate. sp.'
complete -c certtool -l generate-crl --description 'Generate a CRL. sp.'
complete -c certtool -s u -l update-certificate --description 'Update a signed certificate. sp.'
complete -c certtool -s p -l generate-privkey --description 'Generate a private key. sp.'
complete -c certtool -s q -l generate-request --description 'Generate a PKCS #10 certificate request.'
complete -c certtool -s e -l verify-chain --description 'Verify a PEM encoded certificate chain.'
complete -c certtool -l verify --description 'Verify a PEM encoded certificate chain using a trusted list.'
complete -c certtool -l verify-crl --description 'Verify a CRL using a trusted list.'
complete -c certtool -l generate-dh-params --description 'Generate PKCS #3 encoded Diffie-Hellman parameters. sp.'
complete -c certtool -l get-dh-params --description 'Get the included PKCS #3 encoded Diffie-Hellman parameters.'
complete -c certtool -l dh-info --description 'Print information PKCS #3 encoded Diffie-Hellman parameters.'
complete -c certtool -l load-privkey --description 'Loads a private key file.'
complete -c certtool -l load-pubkey --description 'Loads a public key file.'
complete -c certtool -l load-request --description 'Loads a certificate request file. sp.'
complete -c certtool -l load-certificate --description 'Loads a certificate file.'
complete -c certtool -l load-ca-privkey --description 'Loads the certificate authority\'s private key file.'
complete -c certtool -l load-ca-certificate --description 'Loads the certificate authority\'s certificate file.'
complete -c certtool -l password --description 'Password to use. sp.'
complete -c certtool -l hex-numbers --description 'Print big number in an easier format to parse. sp.'
complete -c certtool -l cprint --description 'In certain operations it prints the information… [See Man Page]'
complete -c certtool -l null-password --description 'Enforce a NULL password.'
complete -c certtool -s i -l certificate-info --description 'Print information on the given certificate. sp.'
complete -c certtool -l certificate-pubkey --description 'Print certificate\'s public key. sp.'
complete -c certtool -l pgp-certificate-info --description 'Print information on the given OpenPGP certificate. sp.'
complete -c certtool -l pgp-ring-info --description 'Print information on the given OpenPGP keyring structure. sp.'
complete -c certtool -s l -l crl-info --description 'Print information on the given CRL structure. sp.'
complete -c certtool -l crq-info --description 'Print information on the given certificate request. sp.'
complete -c certtool -l no-crq-extensions --description 'Do not use extensions in certificate requests. sp.'
complete -c certtool -l p12-info --description 'Print information on a PKCS #12 structure. sp.'
complete -c certtool -l p7-info --description 'Print information on a PKCS #7 structure. sp.'
complete -c certtool -l smime-to-p7 --description 'Convert S/MIME to PKCS #7 structure. sp.'
complete -c certtool -s k -l key-info --description 'Print information on a private key. sp.'
complete -c certtool -l pgp-key-info --description 'Print information on an OpenPGP private key. sp.'
complete -c certtool -l pubkey-info --description 'Print information on a public key.'
complete -c certtool -l v1 --description 'Generate an X. 509 version 1 certificate (with no extensions).'
complete -c certtool -l to-p12 --description 'Generate a PKCS #12 structure.'
complete -c certtool -l to-p8 --description 'Generate a PKCS #8 structure. sp.'
complete -c certtool -s 8 -l pkcs8 --description 'Use PKCS #8 format for private keys. sp.'
complete -c certtool -l rsa --description 'Generate RSA key.'
complete -c certtool -l dsa --description 'Generate DSA key.'
complete -c certtool -l ecc --description 'Generate ECC (ECDSA) key.'
complete -c certtool -l ecdsa --description 'This is an alias for the --ecc option.'
complete -c certtool -l hash --description 'Hash algorithm to use for signing.'
complete -c certtool -l inder -l no-inder --description 'Use DER format for input certificates, private … [See Man Page]'
complete -c certtool -l inraw --description 'This is an alias for the --inder option.'
complete -c certtool -l outder -l no-outder --description 'Use DER format for output certificates, private… [See Man Page]'
complete -c certtool -l outraw --description 'This is an alias for the --outder option.'
complete -c certtool -l bits --description 'Specify the number of bits for key generate.'
complete -c certtool -l sec-param --description 'Specify the security level [low, legacy, normal, high, ultra].'
complete -c certtool -l disable-quick-random --description 'No effect. sp.'
complete -c certtool -l template --description 'Template file to use for non-interactive operation. sp.'
complete -c certtool -l ask-pass --description 'Enable interaction for entering password when in batch mode.'
complete -c certtool -l pkcs-cipher --description 'Cipher to use for PKCS #8 and #12 operations.'
complete -c certtool -s h -l help --description 'Display usage information and exit.'
complete -c certtool -s '!' -l more-help --description 'Pass the extended usage information through a pager.'
