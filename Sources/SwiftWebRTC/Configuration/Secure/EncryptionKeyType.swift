//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

/// Represents the encryption key type.
public enum EncryptionKeyType: Int8, Hashable, CaseIterable, Codable, Sendable {
    case RSA = 0

    case ECDSA = 1
}

extension EncryptionKeyType {
    init(_ type: RTCEncryptionKeyType) {
        switch type {
        case .RSA:
            self = .RSA
        case .ECDSA:
            self = .ECDSA
        @unknown default:
            assertionFailure()
            self = .RSA
        }
    }
}

extension RTCEncryptionKeyType {
    init(_ type: EncryptionKeyType) {
        switch type {
        case .RSA:
            self = .RSA
        case .ECDSA:
            self = .ECDSA
        }
    }
}
