//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

/** Represents the combined ice+dtls connection state of the peer connection. */
public enum PeerConnectionState: Int8, Hashable, CaseIterable, Codable, Sendable {
    case new = 0

    case connecting = 1

    case connected = 2

    case disconnected = 3

    case failed = 4

    case closed = 5

    case unknown = -1
}

extension PeerConnectionState {
    init(_ state: RTCPeerConnectionState) {
        switch state {
        case .new:
            self = .new
        case .connecting:
            self = .connecting
        case .connected:
            self = .connected
        case .disconnected:
            self = .disconnected
        case .failed:
            self = .failed
        case .closed:
            self = .closed
        @unknown default:
            self = .unknown
        }
    }
}
