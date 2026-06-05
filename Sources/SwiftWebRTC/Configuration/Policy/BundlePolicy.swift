//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

/**  Represents the bundle policy. */
public enum BundlePolicy: Int8, Hashable, CaseIterable, Codable, Sendable {
    case balanced = 0

    case maxCompat = 1

    case maxBundle = 2
}

extension BundlePolicy {
    init(_ policy: RTCBundlePolicy) {
        switch policy {
        case .balanced:
            self = .balanced
        case .maxCompat:
            self = .maxCompat
        case .maxBundle:
            self = .maxBundle
        @unknown default:
            assertionFailure()
            self = .balanced
        }
    }
}

extension RTCBundlePolicy {
    init(_ policy: BundlePolicy) {
        switch policy {
        case .balanced:
            self = .balanced
        case .maxCompat:
            self = .maxCompat
        case .maxBundle:
            self = .maxBundle
        }
    }
}
