//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

/// Represents the candidate network policy.
public enum CandidateNetworkPolicy: Int8, Hashable, CaseIterable, Codable, Sendable {
    case all = 0

    case lowCost = 1
}

extension CandidateNetworkPolicy {
    init(_ policy: RTCCandidateNetworkPolicy) {
        switch policy {
        case .all:
            self = .all
        case .lowCost:
            self = .lowCost
        @unknown default:
            assertionFailure()
            self = .all
        }
    }
}

extension RTCCandidateNetworkPolicy {
    init(_ policy: CandidateNetworkPolicy) {
        switch policy {
        case .all:
            self = .all
        case .lowCost:
            self = .lowCost
        }
    }
}
