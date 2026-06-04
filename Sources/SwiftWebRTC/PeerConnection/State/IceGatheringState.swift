//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

/** Represents the ice gathering state of the peer connection. */
public enum IceGatheringState: Int8, Hashable, CaseIterable, Codable, Sendable {
    case new = 0

    case gathering = 1

    case complete = 2

    case unknown = -1
}

extension IceGatheringState {
    init(_ state: RTCIceGatheringState) {
        switch state {
        case .new:
            self = .new
        case .gathering:
            self = .gathering
        case .complete:
            self = .complete
        @unknown default:
            self = .unknown
        }
    }
}
