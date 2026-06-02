//
//  Created by Kurlovich Vitali on 5/28/26.
//

import Logging
import WebRTC

final class PeerConnectionDelegate: NSObject, RTCPeerConnectionDelegate, @unchecked Sendable {
    weak var connection: PeerConnection?

    var logger: Logger?

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCPeerConnectionState) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didChange newState: \(newState)")

        connection?.connectionState = .init(newState)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didChange stateChanged: \(stateChanged)")

        connection?.signalingState = .init(stateChanged)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didChange newState: \(newState)")

        connection?.iceConnectionState = .init(newState)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didChange newState: \(newState)")

        connection?.iceGatheringState = .init(newState)
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd mediaStream: RTCMediaStream) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didAdd mediaStream: \(mediaStream.description)")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove mediaStream: RTCMediaStream) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didRemove mediaStream: \(mediaStream.description)")
    }

    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate peerConnectionShouldNegotiate")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didGenerate candidate: \(candidate.description)")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didRemove candidates: \(candidates.description)")
    }

    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen channel: RTCDataChannel) {
        assert(connection?.peerConnection === peerConnection)
        logger?.debug("RTCPeerConnectionDelegate didOpen channel: \(channel.description)")
    }
}
