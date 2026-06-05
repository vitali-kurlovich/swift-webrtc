//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

/**  Represents the rtcp mux policy. */
public enum RtcpMuxPolicy: Int8, Hashable, CaseIterable, Codable, Sendable {
    case negotiate = 0

    case require = 1
}

extension RtcpMuxPolicy {
    init(_ policy: RTCRtcpMuxPolicy) {
        switch policy {
        case .negotiate:
            self = .negotiate
        case .require:
            self = .require
        @unknown default:
            assertionFailure()
            self = .negotiate
        }
    }
}

extension RTCRtcpMuxPolicy {
    init(_ policy: RtcpMuxPolicy) {
        switch policy {
        case .negotiate:
            self = .negotiate
        case .require:
            self = .require
        }
    }
}
