# openvpn
# Autogenerated from man page /usr/share/man/man8/openvpn.8.gz
# using Deroffing man parser
complete -c openvpn -l help --description 'Show options.'
complete -c openvpn -l config --description 'Load additional config options from  file where… [See Man Page]'
complete -c openvpn -l mode --description 'Set OpenVPN major mode.'
complete -c openvpn -l local --description 'Local host name or IP address for bind.'
complete -c openvpn -l remote --description 'Remote host name or IP address.'
complete -c openvpn -l remote-random-hostname --description 'Add a random string (6 characters) to first DNS… [See Man Page]'
complete -c openvpn -l proto-force --description 'When iterating through connection profiles, onl… [See Man Page]'
complete -c openvpn -l remote-random --description 'When multiple  --remote address/ports are speci… [See Man Page]'
complete -c openvpn -l proto --description 'Use protocol  p for communicating with remote host.'
complete -c openvpn -l connect-retry --description 'For  --proto tcp-client, take  n as the number … [See Man Page]'
complete -c openvpn -l connect-timeout --description 'For  --proto tcp-client, set connection timeout… [See Man Page]'
complete -c openvpn -l connect-retry-max --description 'For  --proto tcp-client, take  n as the number … [See Man Page]'
complete -c openvpn -l show-proxy-settings --description 'Show sensed HTTP or SOCKS proxy settings.'
complete -c openvpn -l http-proxy --description 'Connect to remote host through an HTTP proxy at… [See Man Page]'
complete -c openvpn -l http-proxy-retry --description 'Retry indefinitely on HTTP proxy errors.'
complete -c openvpn -l http-proxy-timeout --description 'Set proxy timeout to  n seconds, default=5.'
complete -c openvpn -l http-proxy-option --description 'Set extended HTTP proxy options.'
complete -c openvpn -l socks-proxy --description 'Connect to remote host through a Socks5 proxy a… [See Man Page]'
complete -c openvpn -l socks-proxy-retry --description 'Retry indefinitely on Socks proxy errors.'
complete -c openvpn -l resolv-retry --description 'If hostname resolve fails for  --remote, retry … [See Man Page]'
complete -c openvpn -l float --description 'Allow remote peer to change its IP address and/… [See Man Page]'
complete -c openvpn -l ipchange --description 'Run command  cmd when our remote ip-address is … [See Man Page]'
complete -c openvpn -l port --description 'TCP/UDP port number for both local and remote.'
complete -c openvpn -l lport --description 'TCP/UDP port number for bind.'
complete -c openvpn -l rport --description 'TCP/UDP port number for remote.'
complete -c openvpn -l bind --description 'Bind to local address and port.'
complete -c openvpn -l nobind --description 'Do not bind to local address and port.'
complete -c openvpn -l dev --description 'TUN/TAP virtual network device (  X can be omit… [See Man Page]'
complete -c openvpn -l dev-type --description 'Which device type are we using?  device-type sh… [See Man Page]'
complete -c openvpn -l topology --description 'Configure virtual addressing topology when runn… [See Man Page]'
complete -c openvpn -l tun-ipv6 --description 'Build a tun link capable of forwarding IPv6 traffic.'
complete -c openvpn -l dev-node --description 'Explicitly set the device node rather than usin… [See Man Page]'
complete -c openvpn -l lladdr --description 'Specify the link layer address, more commonly k… [See Man Page]'
complete -c openvpn -l iproute --description 'Set alternate command to execute instead of def… [See Man Page]'
complete -c openvpn -l ifconfig --description 'Set TUN/TAP adapter parameters.'
complete -c openvpn -l ifconfig-noexec --description 'Don\'t actually execute ifconfig/netsh commands,… [See Man Page]'
complete -c openvpn -l ifconfig-nowarn --description 'Don\'t output an options consistency check warni… [See Man Page]'
complete -c openvpn -l route --description 'Add route to routing table after connection is established.'
complete -c openvpn -l max-routes --description 'Allow a maximum number of n  --route options to… [See Man Page]'
complete -c openvpn -l route-gateway --description 'Specify a default gateway  gw for use with  --route.'
complete -c openvpn -l route-metric --description 'Specify a default metric  m for use with  --route.'
complete -c openvpn -l route-delay --description 'Delay  n seconds (default=0) after connection e… [See Man Page]'
complete -c openvpn -l route-up --description 'Run command  cmd after routes are added, subjec… [See Man Page]'
complete -c openvpn -l route-pre-down --description 'Run command  cmd before routes are removed upon disconnection.'
complete -c openvpn -l route-noexec --description 'Don\'t add or remove routes automatically.'
complete -c openvpn -l route-nopull --description 'When used with  --client or  --pull, accept opt… [See Man Page]'
complete -c openvpn -l allow-pull-fqdn --description 'Allow client to pull DNS names from server (rat… [See Man Page]'
complete -c openvpn -l client-nat --description 'This pushable client option sets up a stateless… [See Man Page]'
complete -c openvpn -l redirect-gateway --description 'Automatically execute routing commands to cause… [See Man Page]'
complete -c openvpn -l link-mtu --description 'Sets an upper bound on the size of UDP packets … [See Man Page]'
complete -c openvpn -l redirect-private --description 'Like --redirect-gateway, but omit actually chan… [See Man Page]'
complete -c openvpn -l tun-mtu --description 'Take the TUN device MTU to be  n and derive the… [See Man Page]'
complete -c openvpn -l tun-mtu-extra --description 'Assume that the TUN/TAP device might return as … [See Man Page]'
complete -c openvpn -l mtu-disc --description 'Should we do Path MTU discovery on TCP/UDP chan… [See Man Page]'
complete -c openvpn -l mtu-test --description 'To empirically measure MTU on connection startu… [See Man Page]'
complete -c openvpn -l fragment --description 'Enable internal datagram fragmentation so that … [See Man Page]'
complete -c openvpn -l mssfix --description 'Announce to TCP sessions running over the tunne… [See Man Page]'
complete -c openvpn -l sndbuf --description 'Set the TCP/UDP socket send buffer size.'
complete -c openvpn -l rcvbuf --description 'Set the TCP/UDP socket receive buffer size.'
complete -c openvpn -l mark --description 'Mark encrypted packets being sent with value.'
complete -c openvpn -l socket-flags --description 'Apply the given flags to the OpenVPN transport socket.'
complete -c openvpn -l txqueuelen --description '(Linux only) Set the TX queue length on the TUN/TAP interface.'
complete -c openvpn -l shaper --description 'Limit bandwidth of outgoing tunnel data to  n b… [See Man Page]'
complete -c openvpn -l inactive --description 'Causes OpenVPN to exit after  n seconds of inac… [See Man Page]'
complete -c openvpn -l ping --description 'Ping remote over the TCP/UDP control channel if… [See Man Page]'
complete -c openvpn -l ping-exit --description 'Causes OpenVPN to exit after  n seconds pass wi… [See Man Page]'
complete -c openvpn -l ping-restart --description 'Similar to  --ping-exit, but trigger a  SIGUSR1… [See Man Page]'
complete -c openvpn -l keepalive --description 'A helper directive designed to simplify the exp… [See Man Page]'
complete -c openvpn -l ping-timer-rem --description 'Run the  --ping-exit /  --ping-restart timer on… [See Man Page]'
complete -c openvpn -l persist-tun --description 'Don\'t close and reopen TUN/TAP device or run up… [See Man Page]'
complete -c openvpn -l persist-key --description 'Don\'t re-read key files across  SIGUSR1 or  --ping-restart.'
complete -c openvpn -l persist-local-ip --description 'Preserve initially resolved local IP address an… [See Man Page]'
complete -c openvpn -l persist-remote-ip --description 'Preserve most recently authenticated remote IP … [See Man Page]'
complete -c openvpn -l mlock --description 'Disable paging by calling the POSIX mlockall function.'
complete -c openvpn -l up --description 'Run command  cmd after successful TUN/TAP devic… [See Man Page]'
complete -c openvpn -l up-delay --description 'Delay TUN/TAP open and possible  --up script ex… [See Man Page]'
complete -c openvpn -l down --description 'Run command  cmd after TUN/TAP device close (po… [See Man Page]'
complete -c openvpn -l down-pre --description 'Call  --down cmd/script before, rather than aft… [See Man Page]'
complete -c openvpn -l up-restart --description 'Enable the  --up and  --down scripts to be call… [See Man Page]'
complete -c openvpn -l setenv --description 'Set a custom environmental variable  name=value… [See Man Page]'
complete -c openvpn -l setenv-safe --description 'Set a custom environmental variable  OPENVPN_na… [See Man Page]'
complete -c openvpn -l script-security --description 'This directive offers policy-level control over… [See Man Page]'
complete -c openvpn -l disable-occ --description 'Don\'t output a warning message if option incons… [See Man Page]'
complete -c openvpn -l user --description 'Change the user ID of the OpenVPN process to  u… [See Man Page]'
complete -c openvpn -l group --description 'Similar to the  --user option, this option chan… [See Man Page]'
complete -c openvpn -l cd --description 'Change directory to  dir prior to reading any f… [See Man Page]'
complete -c openvpn -l chroot --description 'Chroot to  dir after initialization.'
complete -c openvpn -l setcon --description 'Apply SELinux  context after initialization.'
complete -c openvpn -l daemon --description 'Become a daemon after all initialization functi… [See Man Page]'
complete -c openvpn -l syslog --description 'Direct log output to system logger, but do not become a daemon.'
complete -c openvpn -l errors-to-stderr --description 'Output errors to stderr instead of stdout unles… [See Man Page]'
complete -c openvpn -l passtos --description 'Set the TOS field of the tunnel packet to what … [See Man Page]'
complete -c openvpn -l inetd --description 'Use this option when OpenVPN is being run from … [See Man Page]'
complete -c openvpn -l log --description 'Output logging messages to  file, including out… [See Man Page]'
complete -c openvpn -l log-append --description 'Append logging messages to  file.'
complete -c openvpn -l suppress-timestamps --description 'Avoid writing timestamps to log messages, even … [See Man Page]'
complete -c openvpn -l writepid --description 'Write OpenVPN\'s main process ID to  file.'
complete -c openvpn -l nice --description 'Change process priority after initialization ( … [See Man Page]'
complete -c openvpn -l nice-work --description '\\"Change priority of background TLS work thread.'
complete -c openvpn -l fast-io --description '(Experimental) Optimize TUN/TAP/UDP I/O writes … [See Man Page]'
complete -c openvpn -l multihome --description 'Configure a multi-homed UDP server.'
complete -c openvpn -l echo --description 'Echo  parms to log output.'
complete -c openvpn -l remap-usr1 --description 'Control whether internally or externally genera… [See Man Page]'
complete -c openvpn -l verb --description 'Set output verbosity to  n (default=1).'
complete -c openvpn -l status --description 'Write operational status to  file every  n seconds.'
complete -c openvpn -l status-version --description 'Choose the status file format version number.'
complete -c openvpn -l mute --description 'Log at most  n consecutive messages in the same category.'
complete -c openvpn -l comp-lzo --description 'Use fast LZO compression -- may add up to 1 byt… [See Man Page]'
complete -c openvpn -l comp-noadapt --description 'When used in conjunction with  --comp-lzo, this… [See Man Page]'
complete -c openvpn -l management --description 'Enable a TCP server on  IP:port to handle daemo… [See Man Page]'
complete -c openvpn -l management-client --description 'Management interface will connect as a TCP/unix… [See Man Page]'
complete -c openvpn -l management-query-passwords --description 'Query management channel for private key passwo… [See Man Page]'
complete -c openvpn -l management-query-proxy --description 'Query management channel for proxy server infor… [See Man Page]'
complete -c openvpn -l management-query-remote --description 'Allow management interface to override  --remot… [See Man Page]'
complete -c openvpn -l management-forget-disconnect --description 'Make OpenVPN forget passwords when management s… [See Man Page]'
complete -c openvpn -l management-hold --description 'Start OpenVPN in a hibernating state, until a c… [See Man Page]'
complete -c openvpn -l management-signal --description 'Send SIGUSR1 signal to OpenVPN if management se… [See Man Page]'
complete -c openvpn -l management-log-cache --description 'Cache the most recent  n lines of log file hist… [See Man Page]'
complete -c openvpn -l management-up-down --description 'Report tunnel up/down events to management interface.'
complete -c openvpn -l management-client-auth --description 'Gives management interface client the responsib… [See Man Page]'
complete -c openvpn -l management-client-pf --description 'Management interface clients must specify a pac… [See Man Page]'
complete -c openvpn -l management-client-user --description 'When the management interface is listening on a… [See Man Page]'
complete -c openvpn -l management-client-group --description 'When the management interface is listening on a… [See Man Page]'
complete -c openvpn -l plugin --description 'Load plug-in module from the file  module-pathn… [See Man Page]'
complete -c openvpn -l server --description 'A helper directive designed to simplify the con… [See Man Page]'
complete -c openvpn -l server-bridge --description 'A helper directive similar to  --server which i… [See Man Page]'
complete -c openvpn -l push --description 'Push a config file option back to the client fo… [See Man Page]'
complete -c openvpn -l push-reset --description 'Don\'t inherit the global push list for a specif… [See Man Page]'
complete -c openvpn -l push-peer-info --description 'Push additional information about the client to server.'
complete -c openvpn -l disable --description 'Disable a particular client (based on the commo… [See Man Page]'
complete -c openvpn -l ifconfig-pool --description 'Set aside a pool of subnets to be dynamically a… [See Man Page]'
complete -c openvpn -l ifconfig-pool-persist --description 'Persist/unpersist ifconfig-pool data to  file, … [See Man Page]'
complete -c openvpn -l ifconfig-pool-linear --description 'Modifies the  --ifconfig-pool directive to allo… [See Man Page]'
complete -c openvpn -l ifconfig-push --description 'Push virtual IP endpoints for client tunnel, ov… [See Man Page]'
complete -c openvpn -l iroute --description 'Generate an internal route to a specific client.'
complete -c openvpn -l client-to-client --description 'Because the OpenVPN server mode handles multipl… [See Man Page]'
complete -c openvpn -l duplicate-cn --description 'Allow multiple clients with the same common nam… [See Man Page]'
complete -c openvpn -l client-connect --description 'Run  command cmd on client connection.'
complete -c openvpn -l client-disconnect --description 'Like  --client-connect but called on client instance shutdown.'
complete -c openvpn -l client-config-dir --description 'Specify a directory  dir for custom client config files.'
complete -c openvpn -l ccd-exclusive --description 'Require, as a condition of authentication, that… [See Man Page]'
complete -c openvpn -l tmp-dir --description 'Specify a directory  dir for temporary files.'
complete -c openvpn -l hash-size --description 'Set the size of the real address hash table to … [See Man Page]'
complete -c openvpn -l bcast-buffers --description 'Allocate  n buffers for broadcast datagrams (default=256).'
complete -c openvpn -l tcp-queue-limit --description 'Maximum number of output packets queued before … [See Man Page]'
complete -c openvpn -l tcp-nodelay --description 'This macro sets the TCP_NODELAY socket flag on … [See Man Page]'
complete -c openvpn -l max-clients --description 'Limit server to a maximum of  n concurrent clients.'
complete -c openvpn -l max-routes-per-client --description 'Allow a maximum of  n internal routes per client (default=256).'
complete -c openvpn -l stale-routes-check --description 'Remove routes haven\'t had activity for  n seconds (i. e.'
complete -c openvpn -l connect-freq --description 'Allow a maximum of  n new connections per  sec … [See Man Page]'
complete -c openvpn -l learn-address --description 'Run command  cmd to validate client virtual add… [See Man Page]'
complete -c openvpn -l auth-user-pass-verify --description 'Require the client to provide a username/passwo… [See Man Page]'
complete -c openvpn -l opt-verify --description 'Clients that connect with options that are inco… [See Man Page]'
complete -c openvpn -l auth-user-pass-optional --description 'Allow connections by clients that do not specif… [See Man Page]'
complete -c openvpn -l client-cert-not-required --description 'Don\'t require client certificate, client will a… [See Man Page]'
complete -c openvpn -l username-as-common-name --description 'For  --auth-user-pass-verify authentication, us… [See Man Page]'
complete -c openvpn -l compat-names --description 'Until OpenVPN v2. 3 the format of the X.'
complete -c openvpn -l no-name-remapping --description 'The  --no-name-remapping option is an alias for… [See Man Page]'
complete -c openvpn -l port-share --description 'When run in TCP server mode, share the OpenVPN … [See Man Page]'
complete -c openvpn -l client --description 'A helper directive designed to simplify the con… [See Man Page]'
complete -c openvpn -l pull --description 'This option must be used on a client which is c… [See Man Page]'
complete -c openvpn -l auth-user-pass --description 'Authenticate with server using username/password.'
complete -c openvpn -l auth-retry --description 'Controls how OpenVPN responds to username/passw… [See Man Page]'
complete -c openvpn -l static-challenge --description 'Enable static challenge/response protocol using… [See Man Page]'
complete -c openvpn -l server-poll-timeout --description 'when polling possible remote servers to connect… [See Man Page]'
complete -c openvpn -l explicit-exit-notify --description 'In UDP client mode or point-to-point mode, send… [See Man Page]'
complete -c openvpn -l secret --description 'Enable Static Key encryption mode (non-TLS).'
complete -c openvpn -l key-direction --description 'Alternative way of specifying the optional dire… [See Man Page]'
complete -c openvpn -l auth --description 'Authenticate packets with HMAC using message di… [See Man Page]'
complete -c openvpn -l cipher --description 'Encrypt packets with cipher algorithm  alg.'
complete -c openvpn -l keysize --description 'Size of cipher key in bits (optional).'
complete -c openvpn -l prng --description '(Advanced) For PRNG (Pseudo-random number gener… [See Man Page]'
complete -c openvpn -l engine --description 'Enable OpenSSL hardware-based crypto engine functionality.'
complete -c openvpn -l no-replay --description '(Advanced) Disable OpenVPN\'s protection against replay attacks.'
complete -c openvpn -l replay-window --description 'Use a replay protection sliding-window of size … [See Man Page]'
complete -c openvpn -l mute-replay-warnings --description 'Silence the output of replay warnings, which ar… [See Man Page]'
complete -c openvpn -l replay-persist --description 'Persist replay-protection state across sessions… [See Man Page]'
complete -c openvpn -l no-iv --description '(Advanced) Disable OpenVPN\'s use of IV (cipher … [See Man Page]'
complete -c openvpn -l use-prediction-resistance --description 'Enable prediction resistance on PolarSSL\'s RNG.'
complete -c openvpn -l test-crypto --description 'Do a self-test of OpenVPN\'s crypto options by e… [See Man Page]'
complete -c openvpn -l tls-server --description 'Enable TLS and assume server role during TLS handshake.'
complete -c openvpn -l tls-client --description 'Enable TLS and assume client role during TLS handshake.'
complete -c openvpn -l ca --description 'Certificate authority (CA) file in .'
complete -c openvpn -l capath --description 'Directory containing trusted certificates (CAs and CRLs).'
complete -c openvpn -l dh --description 'File containing Diffie Hellman parameters in .'
complete -c openvpn -l cert --description 'Local peer\'s signed certificate in .'
complete -c openvpn -l extra-certs --description 'Specify a  file containing one or more PEM cert… [See Man Page]'
complete -c openvpn -l key --description 'Local peer\'s private key in . pem format.'
complete -c openvpn -l pkcs12 --description 'Specify a PKCS #12 file containing local privat… [See Man Page]'
complete -c openvpn -l verify-hash --description 'Specify SHA1 fingerprint for level-1 cert.'
complete -c openvpn -l pkcs11-cert-private --description 'Set if access to certificate object should be p… [See Man Page]'
complete -c openvpn -l pkcs11-id --description 'Specify the serialized certificate id to be used.'
complete -c openvpn -l pkcs11-id-management --description 'Acquire PKCS#11 id from management interface.'
complete -c openvpn -l pkcs11-pin-cache --description 'Specify how many seconds the PIN can be cached,… [See Man Page]'
complete -c openvpn -l pkcs11-protected-authentication --description 'Use PKCS#11 protected authentication path, usef… [See Man Page]'
complete -c openvpn -l pkcs11-providers --description 'Specify a RSA Security Inc.'
complete -c openvpn -l pkcs11-private-mode --description 'Specify which method to use in order to perform… [See Man Page]'
complete -c openvpn -l cryptoapicert --description 'Load the certificate and private key from the W… [See Man Page]'
complete -c openvpn -l key-method --description 'Use data channel key negotiation method  m.'
complete -c openvpn -l tls-cipher --description 'A list  l of allowable TLS ciphers delimited by a colon (":").'
complete -c openvpn -l tls-timeout --description 'Packet retransmit timeout on TLS control channe… [See Man Page]'
complete -c openvpn -l reneg-bytes --description 'Renegotiate data channel key after  n bytes sen… [See Man Page]'
complete -c openvpn -l reneg-pkts --description 'Renegotiate data channel key after  n packets s… [See Man Page]'
complete -c openvpn -l reneg-sec --description 'Renegotiate data channel key after  n seconds (default=3600).'
complete -c openvpn -l hand-window --description 'Handshake Window -- the TLS-based key exchange … [See Man Page]'
complete -c openvpn -l tran-window --description 'Transition window -- our old key can live this … [See Man Page]'
complete -c openvpn -l single-session --description 'After initially connecting to a remote peer, di… [See Man Page]'
complete -c openvpn -l tls-exit --description 'Exit on TLS negotiation failure.'
complete -c openvpn -l tls-auth --description 'Add an additional layer of HMAC authentication … [See Man Page]'
complete -c openvpn -l askpass --description 'Get certificate password from console or  file … [See Man Page]'
complete -c openvpn -l auth-nocache --description 'Don\'t cache  --askpass or  --auth-user-pass use… [See Man Page]'
complete -c openvpn -l tls-verify --description 'Run command  cmd to verify the X509 name of a p… [See Man Page]'
complete -c openvpn -l tls-export-cert --description 'Store the certificates the clients uses upon co… [See Man Page]'
complete -c openvpn -l x509-username-field --description 'Field in x509 certificate subject to be used as… [See Man Page]'
complete -c openvpn -l tls-remote --description 'Accept connections only from a host with X509 n… [See Man Page]'
complete -c openvpn -l verify-x509-name --description 'Accept connections only if a host\'s X.'
complete -c openvpn -l x509-track --description 'Save peer X509  attribute value in environment … [See Man Page]'
complete -c openvpn -l ns-cert-type --description 'Require that peer certificate was signed with a… [See Man Page]'
complete -c openvpn -l remote-cert-ku --description 'Require that peer certificate was signed with a… [See Man Page]'
complete -c openvpn -l remote-cert-eku --description 'Require that peer certificate was signed with a… [See Man Page]'
complete -c openvpn -l remote-cert-tls --description 'Require that peer certificate was signed with a… [See Man Page]'
complete -c openvpn -l crl-verify --description 'Check peer certificate against the file  crl in PEM format.'
complete -c openvpn -l show-ciphers --description '(Standalone) Show all cipher algorithms to use … [See Man Page]'
complete -c openvpn -l show-digests --description '(Standalone) Show all message digest algorithms… [See Man Page]'
complete -c openvpn -l show-tls --description '(Standalone) Show all TLS ciphers (TLS used onl… [See Man Page]'
complete -c openvpn -l show-engines --description '(Standalone) Show currently available hardware-… [See Man Page]'
complete -c openvpn -l genkey --description '(Standalone) Generate a random key to be used a… [See Man Page]'
complete -c openvpn -l mktun --description '(Standalone) Create a persistent tunnel on plat… [See Man Page]'
complete -c openvpn -l rmtun --description '(Standalone) Remove a persistent tunnel.'
complete -c openvpn -l win-sys --description 'Set the Windows system directory pathname to us… [See Man Page]'
complete -c openvpn -l ip-win32 --description 'When using  --ifconfig on Windows, set the TAP-… [See Man Page]'
complete -c openvpn -l route-method --description 'Which method  m to use for adding routes on Win… [See Man Page]'
complete -c openvpn -l dhcp-option --description 'Set extended TAP-Win32 TCP/IP properties, must … [See Man Page]'
complete -c openvpn -l tap-sleep --description 'Cause OpenVPN to sleep for  n seconds immediate… [See Man Page]'
complete -c openvpn -l show-net-up --description 'Output OpenVPN\'s view of the system routing tab… [See Man Page]'
complete -c openvpn -l dhcp-renew --description 'Ask Windows to renew the TAP adapter lease on startup.'
complete -c openvpn -l dhcp-release --description 'Ask Windows to release the TAP adapter lease on shutdown.'
complete -c openvpn -l register-dns --description 'Run net stop dnscache, net start dnscache, ipco… [See Man Page]'
complete -c openvpn -l pause-exit --description 'Put up a "press any key to continue" message on… [See Man Page]'
complete -c openvpn -l service --description 'Should be used when OpenVPN is being automatica… [See Man Page]'
complete -c openvpn -l show-adapters --description '(Standalone) Show available TAP-Win32 adapters … [See Man Page]'
complete -c openvpn -l allow-nonadmin --description '(Standalone) Set  TAP-adapter to allow access f… [See Man Page]'
complete -c openvpn -l show-valid-subnets --description '(Standalone) Show valid subnets for  --dev tun emulation.'
complete -c openvpn -l show-net --description '(Standalone) Show OpenVPN\'s view of the system … [See Man Page]'
complete -c openvpn -l show-pkcs11-ids --description '(Standalone) Show PKCS#11 token object list.'
complete -c openvpn -l ifconfig-ipv6 --description 'configure IPv6 address  ipv6addr/bits on the ``tun\'\' device.'
complete -c openvpn -l route-ipv6 --description 'setup IPv6 routing in the system to send the sp… [See Man Page]'
complete -c openvpn -l server-ipv6 --description 'convenience-function to enable a number of IPv6… [See Man Page]'
complete -c openvpn -l ifconfig-ipv6-pool --description 'Specify an IPv6 address pool for dynamic assignment to clients.'
complete -c openvpn -l ifconfig-ipv6-push --description 'for ccd/ per-client static IPv6 interface confi… [See Man Page]'
complete -c openvpn -l 'route.' --description '.'
complete -c openvpn -l 'route-delay.' --description '.'
complete -c openvpn -l 'route-gateway.' --description '.'
complete -c openvpn -l 'fragment.' --description '.'
complete -c openvpn -l 'ping-restart.' --description '.'
complete -c openvpn -l reneg --description 'options (see below), then are discarded.'
complete -c openvpn -l persist --description 'options to ensure that OpenVPN doesn\'t need to … [See Man Page]'
complete -c openvpn -l 'remote.' --description 'Note that this option causes message and error … [See Man Page]'
complete -c openvpn -l 'daemon.' --description '.'
complete -c openvpn -l 'comp-lzo.' --description '.'
complete -c openvpn -l management-external-key --description 'Allows usage for external private key file instead of.'
complete -c openvpn -l 'iroute.' --description '.'
complete -c openvpn -l 'config.' --description '.'
complete -c openvpn -l 'tls-auth.' --description '.'
complete -c openvpn -l 'genkey.' --description '.'
complete -c openvpn -l 'inetd)' --description 'when OpenVPN sessions are frequently started and stopped.'
complete -c openvpn -l 'ca.' --description '.'
complete -c openvpn -o cert --description 'above).'
complete -c openvpn -l 'key.' --description 'Not available with PolarSSL.'
complete -c openvpn -l 'pkcs12.' --description '.'
complete -c openvpn -l 'float.' --description '.'
complete -c openvpn -o nodes --description 'option when you use the openssl command line to… [See Man Page]'
complete -c openvpn -l verify-x509-username --description 'option will match against the chosen fieldname … [See Man Page]'
complete -c openvpn -l 'tls-verify.' --description '.'
complete -c openvpn -l 'ifconfig.' --description '.'
complete -c openvpn -l iroute-ipv6 --description 'for ccd/ per-client static IPv6 route configuration, see.'
complete -c openvpn -l 'lport.' --description 'Set on program initiation and reset on SIGHUP.'
complete -c openvpn -l 'rport.' --description 'Set on program initiation and reset on SIGHUP.'
complete -c openvpn -l 'up.' --description 'script_type Prior to execution of any script, t… [See Man Page]'
complete -c openvpn -l ---BEGIN --description '[. ].'
complete -c openvpn -l ---END --description '</cert> When using the inline file feature with.'
