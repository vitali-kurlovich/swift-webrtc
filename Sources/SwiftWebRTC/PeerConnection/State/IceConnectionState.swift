//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

/** Represents the ice connection state of the peer connection. */
public enum IceConnectionState: Int8, Hashable, CaseIterable, Codable, Sendable {
    case new = 0

    case checking = 1

    case connected = 2

    case completed = 3

    case failed = 4

    case disconnected = 5

    case closed = 6

    case count = 7

    case unknown = -1
}

extension IceConnectionState {
    init(_ state: RTCIceConnectionState) {
        switch state {
        case .new:
            self = .new
        case .checking:
            self = .checking
        case .connected:
            self = .connected
        case .completed:
            self = .completed
        case .failed:
            self = .failed
        case .disconnected:
            self = .disconnected
        case .closed:
            self = .closed
        case .count:
            self = .count
        @unknown default:
            self = .unknown
        }
    }
}
