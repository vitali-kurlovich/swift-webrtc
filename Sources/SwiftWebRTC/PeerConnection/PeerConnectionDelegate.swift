//
//  Created by Kurlovich Vitali on 5/28/26.
//

import Logging
import WebRTC

final class PeerConnectionDelegate: NSObject, RTCPeerConnectionDelegate, @unchecked Sendable {
    var logger: Logger?

    let events: AsyncStream<PeerConnectionEvent>
    private let continuation: AsyncStream<PeerConnectionEvent>.Continuation

    deinit {
        continuation.finish()
    }

    override init() {
        let (events, continuation) = AsyncStream.makeStream(of: PeerConnectionEvent.self)
        self.events = events
        self.continuation = continuation

        super.init()
    }

    func peerConnection(_: RTCPeerConnection, didChange newState: RTCPeerConnectionState) {
        let newState = PeerConnectionState(newState)
        logger?.debug("RTCPeerConnectionDelegate changeConnectionState: \(newState)")
        continuation.yield(.changeConnectionState(newState))
    }

    func peerConnection(_: RTCPeerConnection, didChange newState: RTCSignalingState) {
        let newState = SignalingState(newState)
        logger?.debug("RTCPeerConnectionDelegate changeSignalingState: \(newState)")
        continuation.yield(.changeSignalingState(newState))
    }

    func peerConnection(_: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        let newState = IceConnectionState(newState)
        logger?.debug("RTCPeerConnectionDelegate changeIceConnectionState: \(newState)")
        continuation.yield(.changeIceConnectionState(newState))
    }

    func peerConnection(_: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        let newState = IceGatheringState(newState)
        logger?.debug("RTCPeerConnectionDelegate changeIceGatheringState: \(newState)")
        continuation.yield(.changeIceGatheringState(newState))
    }

    func peerConnection(_: RTCPeerConnection, didAdd mediaStream: RTCMediaStream) {
        logger?.debug("RTCPeerConnectionDelegate didAdd mediaStream: \(mediaStream.description)")

        // TODO:
        continuation.yield(.addMediaStream)
    }

    func peerConnection(_: RTCPeerConnection, didRemove mediaStream: RTCMediaStream) {
        logger?.debug("RTCPeerConnectionDelegate didRemove mediaStream: \(mediaStream.description)")

        // TODO:
        continuation.yield(.removeMediaStream)
    }

    func peerConnectionShouldNegotiate(_: RTCPeerConnection) {
        logger?.debug("RTCPeerConnectionDelegate peerConnectionShouldNegotiate")

        continuation.yield(.shouldNegotiate)
    }

    func peerConnection(_: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        logger?.debug("RTCPeerConnectionDelegate didGenerate candidate: \(candidate.description)")

        let candidate = IceCandidate(candidate)
        continuation.yield(.generateCandidate(candidate))
    }

    func peerConnection(_: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        logger?.debug("RTCPeerConnectionDelegate didRemove candidates: \(candidates.description)")

        let candidates = candidates.map { IceCandidate($0) }
        continuation.yield(.removeCandidateas(candidates))
    }

    func peerConnection(_: RTCPeerConnection, didOpen channel: RTCDataChannel) {
        logger?.debug("RTCPeerConnectionDelegate didOpen channel: \(channel.description)")

        let channel = DataChannel(channel)
        continuation.yield(.openChannel(channel))
    }
}
