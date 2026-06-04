//
//  Created by Kurlovich Vitali on 6/4/26.
//

public enum PeerConnectionEvent: Sendable {
    case changeConnectionState(PeerConnectionState)
    case changeSignalingState(SignalingState)
    case changeIceConnectionState(IceConnectionState)
    case changeIceGatheringState(IceGatheringState)

    case addMediaStream
    case removeMediaStream

    case shouldNegotiate
    case generateCandidate(IceCandidate)
    case removeCandidateas([IceCandidate])

    case openChannel(DataChannel)

    case close
}
