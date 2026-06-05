//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

/**
 * Represents the ice transport policy. This exposes the same states in C++,
 * which include one more state than what exists in the W3C spec.
 */
public enum IceTransportPolicy: Int8, Hashable, CaseIterable, Codable, Sendable {
    case none = 0

    case relay = 1

    case noHost = 2

    case all = 3
}

extension IceTransportPolicy {
    init(_ policy: RTCIceTransportPolicy) {
        switch policy {
        case .none:
            self = .none
        case .relay:
            self = .relay
        case .noHost:
            self = .noHost
        case .all:
            self = .all
        @unknown default:
            assertionFailure()
            self = .none
        }
    }
}

extension RTCIceTransportPolicy {
    init(_ policy: IceTransportPolicy) {
        switch policy {
        case .none:
            self = .none
        case .relay:
            self = .relay
        case .noHost:
            self = .noHost
        case .all:
            self = .all
        }
    }
}
