//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

///  Represents the tcp candidate policy.
public enum TcpCandidatePolicy: Int8, Hashable, CaseIterable, Codable, Sendable {
    case enabled = 0

    case disabled = 1
}

extension TcpCandidatePolicy {
    init(_ policy: RTCTcpCandidatePolicy) {
        switch policy {
        case .enabled:
            self = .enabled
        case .disabled:
            self = .disabled
        @unknown default:
            assertionFailure()
            self = .enabled
        }
    }
}

extension RTCTcpCandidatePolicy {
    init(_ policy: TcpCandidatePolicy) {
        switch policy {
        case .enabled:
            self = .enabled
        case .disabled:
            self = .disabled
        }
    }
}
