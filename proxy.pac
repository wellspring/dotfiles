// proxy.pac to redirrect all *.local websites to localhost for development
//
// Do not forget to set your proxy file to...
// * Linux    : file:///home/<USERNAME HERE>/.proxy.pac
// * Mac OS X : file:///Users/<USERNAME HERE>/.proxy.pac
// * Windows  : C:/proxy.pac

function FindProxyForURL(url, host) {
    if (shExpMatch(host, "*.local")) {
        return "PROXY localhost";
    }
    return "DIRECT";
}
