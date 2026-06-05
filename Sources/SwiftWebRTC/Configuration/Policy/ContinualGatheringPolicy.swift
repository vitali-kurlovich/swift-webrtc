//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

///  Represents the continual gathering policy.
public enum ContinualGatheringPolicy: Int8, Hashable, CaseIterable, Codable, Sendable {
    case gatherOnce = 0

    case gatherContinually = 1
}

extension ContinualGatheringPolicy {
    init(_ policy: RTCContinualGatheringPolicy) {
        switch policy {
        case .gatherOnce:
            self = .gatherOnce
        case .gatherContinually:
            self = .gatherContinually
        @unknown default:
            assertionFailure()
            self = .gatherOnce
        }
    }
}

extension RTCContinualGatheringPolicy {
    init(_ policy: ContinualGatheringPolicy) {
        switch policy {
        case .gatherOnce:
            self = .gatherOnce
        case .gatherContinually:
            self = .gatherContinually
        }
    }
}
