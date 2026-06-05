//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

/** Represents the signaling state of the peer connection. */
public enum SignalingState: Int8, Hashable, CaseIterable, Codable, Sendable {
    case stable = 0

    case haveLocalOffer = 1

    case haveLocalPrAnswer = 2

    case haveRemoteOffer = 3

    case haveRemotePrAnswer = 4

    case closed = 5
}

extension SignalingState {
    init(_ state: RTCSignalingState) {
        switch state {
        case .stable:
            self = .stable
        case .haveLocalOffer:
            self = .haveLocalOffer
        case .haveLocalPrAnswer:
            self = .haveLocalPrAnswer
        case .haveRemoteOffer:
            self = .haveRemoteOffer
        case .haveRemotePrAnswer:
            self = .haveRemotePrAnswer
        case .closed:
            self = .closed
        @unknown default:
            assertionFailure()
            self = .stable
        }
    }
}
