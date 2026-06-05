//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

public struct IceServer {
    let server: RTCIceServer
}

public extension IceServer {
    /** URI(s) for this server represented as Strings. */
    var urlStrings: [String] {
        server.urlStrings
    }

    /** Username to use if this RTCIceServer object is a TURN server. */
    var username: String? {
        server.username
    }

    /** Credential to use if this RTCIceServer object is a TURN server. */
    var credential: String? {
        server.credential
    }

    /**
     * TLS certificate policy to use if this RTCIceServer object is a TURN server.
     */
    var tlsCertPolicy: TlsCertPolicy {
        .init(server.tlsCertPolicy)
    }

    /**
      If the URIs in `urls` only contain IP addresses, this field can be used
      to indicate the hostname, which may be necessary for TLS (using the SNI
      extension). If `urls` itself contains the hostname, this isn't necessary.
     */
    var hostname: String? {
        server.hostname
    }

    /** List of protocols to be used in the TLS ALPN extension. */
    var tlsAlpnProtocols: [String] {
        server.tlsAlpnProtocols
    }

    /**
     List elliptic curves to be used in the TLS elliptic curves extension.
     Only curve names supported by OpenSSL should be used (eg. "P-256","X25519").
     */
    var tlsEllipticCurves: [String] {
        server.tlsEllipticCurves
    }
}

public extension IceServer {
    /** Initializer for a server with no authentication (e.g. STUN). */
    init(urlStrings: [String]) {
        let server = RTCIceServer(urlStrings: urlStrings)
        self.init(server: server)
    }

    /**
     * Initialize an RTCIceServer with its associated URLs, optional username,
     * optional credential, and credentialType.
     */
    init(urlStrings: [String], username: String?, credential: String?) {
        let server = RTCIceServer(urlStrings: urlStrings, username: username, credential: credential)
        self.init(server: server)
    }

    /**
     * Initialize an RTCIceServer with its associated URLs, optional username,
     * optional credential, and TLS cert policy.
     */
    init(urlStrings: [String], username: String?, credential: String?, tlsCertPolicy: TlsCertPolicy) {
        let server = RTCIceServer(urlStrings: urlStrings, username: username, credential: credential, tlsCertPolicy: .init(tlsCertPolicy))
        self.init(server: server)
    }

    /**
     * Initialize an RTCIceServer with its associated URLs, optional username,
     * optional credential, TLS cert policy and hostname.
     */
    init(urlStrings: [String], username: String?, credential: String?, tlsCertPolicy: TlsCertPolicy, hostname: String?) {
        let server = RTCIceServer(urlStrings: urlStrings,
                                  username: username,
                                  credential: credential,
                                  tlsCertPolicy: .init(tlsCertPolicy),
                                  hostname: hostname)
        self.init(server: server)
    }

    /**
     * Initialize an RTCIceServer with its associated URLs, optional username,
     * optional credential, TLS cert policy, hostname and ALPN protocols.
     */
    init(urlStrings: [String], username: String?, credential: String?, tlsCertPolicy: TlsCertPolicy, hostname: String?, tlsAlpnProtocols: [String]) {
        let server = RTCIceServer(urlStrings: urlStrings,
                                  username: username,
                                  credential: credential,
                                  tlsCertPolicy: .init(tlsCertPolicy),
                                  hostname: hostname,
                                  tlsAlpnProtocols: tlsAlpnProtocols)
        self.init(server: server)
    }

    /**
     * Initialize an RTCIceServer with its associated URLs, optional username,
     * optional credential, TLS cert policy, hostname, ALPN protocols and
     * elliptic curves.
     */
    init(urlStrings: [String],
         username: String?,
         credential: String?,
         tlsCertPolicy: TlsCertPolicy,
         hostname: String?,
         tlsAlpnProtocols: [String]?,
         tlsEllipticCurves: [String]?)
    {
        let server = RTCIceServer(urlStrings: urlStrings,
                                  username: username,
                                  credential: credential,
                                  tlsCertPolicy: .init(tlsCertPolicy),
                                  hostname: hostname,
                                  tlsAlpnProtocols: tlsAlpnProtocols,
                                  tlsEllipticCurves: tlsEllipticCurves)
        self.init(server: server)
    }
}
