//
//  Created by Kurlovich Vitali on 5/26/26.
//

import Observation
import WebRTC

public enum PeerConnectionError: Error {
    case cantCreateNewConnection
    case cantCreateNewDataChannel
}

@Observable
@MainActor
public final class PeerConnection {
    private let factory: RTCPeerConnectionFactory
    private let configuration: RTCConfiguration

    let peerConnection: RTCPeerConnection
    private let connectionDelegate: PeerConnectionDelegate

    public internal(set) var connectionState: PeerConnectionState
    public internal(set) var signalingState: SignalingState
    public internal(set) var iceConnectionState: IceConnectionState
    public internal(set) var iceGatheringState: IceGatheringState

    public init(factory: RTCPeerConnectionFactory, configuration: RTCConfiguration) throws {
        self.factory = factory
        self.configuration = configuration

        // Define media constraints. DtlsSrtpKeyAgreement is required to be true to be able to connect with web browsers.
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil,
                                              optionalConstraints: ["DtlsSrtpKeyAgreement": kRTCMediaConstraintsValueTrue])

        let connectionDelegate = PeerConnectionDelegate()

        self.connectionDelegate = connectionDelegate

        guard let connection = factory.peerConnection(with: configuration, constraints: constraints, delegate: connectionDelegate) else {
            throw PeerConnectionError.cantCreateNewConnection
        }

        peerConnection = connection
        peerConnection.delegate = connectionDelegate

        signalingState = .init(connection.signalingState)
        iceConnectionState = .init(connection.iceConnectionState)
        connectionState = .init(connection.connectionState)
        iceGatheringState = .init(connection.iceGatheringState)

        connectionDelegate.connection = self
    }
}

public extension PeerConnection {
    convenience init(configuration: RTCConfiguration) throws {
        try self.init(factory: Self.initializePeerConnectionFactory(), configuration: configuration)
    }

    convenience init(iceServers: [IceServer]) throws {
        let configuration = RTCConfiguration()
        configuration.iceServers = iceServers.map(\.server)

        // Unified plan is more superior than planB
        configuration.sdpSemantics = .unifiedPlan

        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        configuration.continualGatheringPolicy = .gatherContinually

        try self.init(configuration: configuration)
    }
}

public extension PeerConnection {
    var localStreams: [RTCMediaStream] {
        peerConnection.localStreams
    }
}

public extension PeerConnection {
    var localDescription: SessionDescription? {
        guard let desc = peerConnection.localDescription else {
            return nil
        }

        return .init(desc)
    }

    var remoteDescription: SessionDescription? {
        guard let desc = peerConnection.remoteDescription else {
            return nil
        }

        return .init(desc)
    }
}

public extension PeerConnection {
    /** Create a new data channel with the given label and configuration. */
    func channel(label: String, with configuration: DataChannelConfiguration = .init()) throws -> DataChannel {
        guard let channel = peerConnection.dataChannel(forLabel: label, configuration: .init(configuration)) else {
            // debugPrint("Warning: Couldn't create data channel.")
            throw PeerConnectionError.cantCreateNewDataChannel
        }

        return DataChannel(channel)
    }
}

public extension PeerConnection {
    // MARK: Signaling

    func offer(_ options: PeerMediaOption = [.offerToReceiveAudio, .offerToReceiveVideo]) async throws -> SessionDescription {
        let mediaConstrains = RTCMediaConstraints(mandatoryConstraints: options.dict, optionalConstraints: nil)
        let description = try await peerConnection.offer(for: mediaConstrains)
        try await peerConnection.setLocalDescription(description)
        return .init(description)
    }

    func answer(_ options: PeerMediaOption = [.offerToReceiveAudio, .offerToReceiveVideo]) async throws -> SessionDescription {
        let mediaConstrains = RTCMediaConstraints(mandatoryConstraints: options.dict, optionalConstraints: nil)
        let description = try await peerConnection.answer(for: mediaConstrains)
        try await peerConnection.setLocalDescription(description)
        return .init(description)
    }
}

public extension PeerConnection {
    /** Terminate all media and close the transport. */
    func close() {
        peerConnection.close()
    }
}

public extension PeerConnection {
    func setRemoteDescription(_ description: SessionDescription) async throws {
        try await peerConnection.setRemoteDescription(.init(description))
    }
}

public extension PeerConnection {
    func add(_ candidate: IceCandidate) async throws {
        try await peerConnection.add(.init(candidate))
    }

    func remove(_ candidates: [IceCandidate]) {
        let candidates = candidates.map { RTCIceCandidate($0) }
        peerConnection.remove(candidates)
    }
}

private extension PeerConnection {
    static func initializePeerConnectionFactory() -> RTCPeerConnectionFactory {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }
}
