//
//  Created by Kurlovich Vitali on 5/28/26.
//

import WebRTC

final class PeerConnectionDelegate: NSObject, RTCPeerConnectionDelegate {
    weak var connection: PeerConnection?

    @MainActor
    private var peerConnection: RTCPeerConnection? {
        connection?.peerConnection
    }

    func peerConnection(_: RTCPeerConnection, didChange newState: RTCPeerConnectionState) {
        guard let connection else { return }

        Task { @MainActor [connection] in
            // assert(connection.peerConnection === peerConnection)
            connection.connectionState = .init(newState)
        }
    }

    func peerConnection(_: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        guard let connection else { return }
        Task { @MainActor in
            // assert(self.peerConnection === peerConnection)
            connection.signalingState = .init(stateChanged)
        }
    }

    func peerConnection(_: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        guard let connection else { return }

        Task { @MainActor in
            // assert(self.peerConnection === peerConnection)

            connection.iceConnectionState = .init(newState)
        }
    }

    func peerConnection(_: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        guard let connection else { return }
        Task { @MainActor in
            // assert(self.peerConnection === peerConnection)
            connection.iceGatheringState = .init(newState)
        }
    }

    func peerConnection(_: RTCPeerConnection, didAdd _: RTCMediaStream) {
        guard let connection else { return }

        Task { @MainActor in
            // assert(self.peerConnection === peerConnection)
        }
    }

    func peerConnection(_: RTCPeerConnection, didRemove _: RTCMediaStream) {
        Task { @MainActor in
            // assert(self.peerConnection === peerConnection)
        }
    }

    func peerConnectionShouldNegotiate(_: RTCPeerConnection) {
        Task { @MainActor in
            //  assert(self.peerConnection === peerConnection)
        }
    }

    func peerConnection(_: RTCPeerConnection, didGenerate _: RTCIceCandidate) {
        Task { @MainActor in
            // assert(self.peerConnection === peerConnection)
        }
    }

    func peerConnection(_: RTCPeerConnection, didRemove _: [RTCIceCandidate]) {
        Task { @MainActor in
            // assert(self.peerConnection === peerConnection)
        }
    }

    func peerConnection(_: RTCPeerConnection, didOpen _: RTCDataChannel) {
        Task { @MainActor in
            //  assert(connection === peerConnection)
        }
    }
}

/*

 /*
  * The name of the sub-protocol used with this data channel, if any. Otherwise
  * this returns an empty string.
  */
 open var `protocol`: String { get }

 /*  The identifier for this data channel. */
 open var channelId: Int32 { get }

 /*
  * The number of bytes of application data that have been queued using
  * `sendData:` but that have not yet been transmitted to the network.
  */
 open var bufferedAmount: UInt64 { get }

 /*  The delegate for this data channel. */
 weak open var delegate: (any RTCDataChannelDelegate)?

 /*  Closes the data channel. */
 open func close()

 /*  Attempt to send `data` on this data channel's underlying data transport. */
 open func sendData(_ data: RTCDataBuffer) -> Bool

 */
