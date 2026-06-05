//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public struct Certificate: Hashable, Sendable {
    /// Private key in PEM.
    public let privateKey: String

    /// Public key in an x509 cert encoded in PEM.
    public let certificate: String

    /// Initialize an RTCCertificate with PEM strings for private_key and certificate.
    public init(privateKey: String, certificate: String) {
        self.privateKey = privateKey
        self.certificate = certificate
    }
}

public extension Certificate {
    /** Generate a new certificate for 're' use.
     *
     * Optional dictionary of parameters. Defaults to KeyType ECDSA if none are
     * provided.
     * - name: "ECDSA" or "RSASSA-PKCS1-v1_5"
     */
    static func generate(withParams params: [AnyHashable: Any]) -> Certificate? {
        guard let certificate = RTCCertificate.generate(withParams: params) else {
            return nil
        }
        return Certificate(certificate)
    }
}

extension Certificate {
    init(_ certificate: RTCCertificate) {
        self.init(privateKey: certificate.private_key, certificate: certificate.certificate)
    }
}

extension RTCCertificate {
    convenience init(_ certificate: Certificate) {
        self.init(privateKey: certificate.privateKey, certificate: certificate.certificate)
    }
}
