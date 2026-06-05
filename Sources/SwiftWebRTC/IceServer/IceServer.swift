//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

public struct IceServer: Hashable, Codable, Sendable {
    /// URI(s) for this server represented as Strings.
    public var urlStrings: [String]

    /// Username to use if this RTCIceServer object is a TURN server.
    public var username: String?

    /// Credential to use if this RTCIceServer object is a TURN server.
    public var credential: String?

    /// TLS certificate policy to use if this RTCIceServer object is a TURN server.
    public var tlsCertPolicy: TlsCertPolicy

    /**
      If the URIs in `urls` only contain IP addresses, this field can be used
      to indicate the hostname, which may be necessary for TLS (using the SNI
      extension). If `urls` itself contains the hostname, this isn't necessary.
     */
    public var hostname: String?

    /// List of protocols to be used in the TLS ALPN extension.
    public var tlsAlpnProtocols: [String]

    /**
     List elliptic curves to be used in the TLS elliptic curves extension.
     Only curve names supported by OpenSSL should be used (eg. "P-256","X25519").
     */
    public var tlsEllipticCurves: [String]

    /**
     * Initialize an RTCIceServer with its associated URLs, optional username,
     * optional credential, TLS cert policy, hostname, ALPN protocols and
     * elliptic curves.
     */
    public init(urlStrings: [String],
                username: String? = nil,
                credential: String? = nil,
                tlsCertPolicy: TlsCertPolicy = .secure,
                hostname: String? = nil,
                tlsAlpnProtocols: [String] = [],
                tlsEllipticCurves: [String] = [])
    {
        assert(!urlStrings.isEmpty)

        self.urlStrings = urlStrings
        self.username = username
        self.credential = credential
        self.tlsCertPolicy = tlsCertPolicy
        self.hostname = hostname
        self.tlsAlpnProtocols = tlsAlpnProtocols
        self.tlsEllipticCurves = tlsEllipticCurves
    }
}

extension RTCIceServer {
    convenience init(_ server: IceServer) {
        self.init(urlStrings: server.urlStrings,
                  username: server.username,
                  credential: server.credential,
                  tlsCertPolicy: .init(server.tlsCertPolicy),
                  hostname: server.hostname,
                  tlsAlpnProtocols: server.tlsAlpnProtocols.isEmpty ? nil : server.tlsAlpnProtocols,
                  tlsEllipticCurves: server.tlsEllipticCurves.isEmpty ? nil : server.tlsEllipticCurves)
    }
}

extension IceServer {
    init(_ server: RTCIceServer) {
        self.init(urlStrings: server.urlStrings,
                  username: server.username,
                  credential: server.credential,
                  tlsCertPolicy: .init(server.tlsCertPolicy),
                  hostname: server.hostname,
                  tlsAlpnProtocols: server.tlsAlpnProtocols ?? [],
                  tlsEllipticCurves: server.tlsEllipticCurves ?? [])
    }
}
