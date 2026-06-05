//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

///  Represents the chosen SDP semantics for the RTCPeerConnection.
public enum SdpSemantics: Int8, Hashable, CaseIterable, Codable, Sendable {
    case planB = 0

    case unifiedPlan = 1
}

extension SdpSemantics {
    init(_ semantics: RTCSdpSemantics) {
        switch semantics {
        case .planB:
            self = .planB
        case .unifiedPlan:
            self = .unifiedPlan
        @unknown default:
            assertionFailure()
            self = .unifiedPlan
        }
    }
}

extension RTCSdpSemantics {
    init(_ semantics: SdpSemantics) {
        switch semantics {
        case .planB:
            self = .planB
        case .unifiedPlan:
            self = .unifiedPlan
        }
    }
}
