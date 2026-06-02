//
//  Created by Kurlovich Vitali on 5/26/26.
//

import Logging
import Observation
import WebRTC

public enum PeerConnectionError: Error {
    case cantCreateNewConnection
    case cantCreateNewDataChannel
}

public enum PeerConnectionEvent {
    case addMediaStream
    case removeMediaStream

    case shouldNegotiate
    case generateCandidate(IceCandidate)
    case removeCandidateas([IceCandidate])

    case openChannel(DataChannel)
}

@Observable
public final class PeerConnection: @unchecked Sendable {
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

        signalingState = .init(connection.signalingState)
        iceConnectionState = .init(connection.iceConnectionState)
        connectionState = .init(connection.connectionState)
        iceGatheringState = .init(connection.iceGatheringState)

        connectionDelegate.connection = self
        peerConnection.delegate = connectionDelegate
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

extension PeerConnection {
    var events: AsyncStream<PeerConnectionEvent> {
        connectionDelegate.events
    }
}

public extension PeerConnection {
    var logger: Logger? {
        get {
            connectionDelegate.logger
        }
        set {
            connectionDelegate.logger = newValue
        }
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
        logger?.info("\(String(describing: Self.self)) channel")

        guard let channel = peerConnection.dataChannel(forLabel: label, configuration: .init(configuration)) else {
            let error = PeerConnectionError.cantCreateNewDataChannel
            logger?.error("\(String(describing: Self.self)) \(error.localizedDescription)", error: error)
            throw error
        }

        let dataChanel = DataChannel(channel)
        dataChanel.logger = logger
        return dataChanel
    }
}

public extension PeerConnection {
    // MARK: Signaling

    @discardableResult
    func offer(_ options: PeerMediaOption = [.offerToReceiveAudio, .offerToReceiveVideo]) async throws -> SessionDescription {
        do {
            logger?.info("\(String(describing: Self.self)) offer")
            logger?.debug("options: \(options)")

            let mediaConstrains = RTCMediaConstraints(mandatoryConstraints: options.dict, optionalConstraints: nil)
            let description = try await peerConnection.offer(for: mediaConstrains)

            logger?.debug("\(String(describing: Self.self)) \(description.description)")

            try await peerConnection.setLocalDescription(description)
            return .init(description)
        } catch {
            logger?.error("\(String(describing: Self.self)) \(error.localizedDescription)", error: error)
            throw error
        }
    }

    @discardableResult
    func answer(_ options: PeerMediaOption = [.offerToReceiveAudio, .offerToReceiveVideo]) async throws -> SessionDescription {
        do {
            logger?.info("\(String(describing: Self.self)) answer")
            logger?.debug("options: \(options)")

            let mediaConstrains = RTCMediaConstraints(mandatoryConstraints: options.dict, optionalConstraints: nil)
            let description = try await peerConnection.answer(for: mediaConstrains)

            logger?.debug("\(String(describing: Self.self)) \(description.description)")

            try await peerConnection.setLocalDescription(description)
            return .init(description)
        } catch {
            logger?.error("\(String(describing: Self.self)) \(error.localizedDescription)", error: error)
            throw error
        }
    }
}

public extension PeerConnection {
    /** Terminate all media and close the transport. */
    func close() {
        logger?.info("\(String(describing: Self.self)) close")
        peerConnection.close()
    }
}

public extension PeerConnection {
    func setRemote(_ session: SessionDescription) async throws {
        do {
            logger?.info("\(String(describing: Self.self)) setRemoteDescription:")
            logger?.debug("session: \(session)")
            try await peerConnection.setRemoteDescription(.init(session))
        } catch {
            logger?.error("\(String(describing: Self.self)) \(error.localizedDescription)", error: error)
            throw error
        }
    }
}

public extension PeerConnection {
    func add(_ candidate: IceCandidate) async throws {
        do {
            logger?.info("\(String(describing: Self.self)) add candidate")
            logger?.debug("candidate: \(candidate)")
            try await peerConnection.add(.init(candidate))
        } catch {
            logger?.error("\(String(describing: Self.self)) \(error.localizedDescription)", error: error)
            throw error
        }
    }

    func remove(_ candidates: [IceCandidate]) {
        let candidates = candidates.map { RTCIceCandidate($0) }

        logger?.info("\(String(describing: Self.self)) remove candidates")
        logger?.debug("candidates: \(candidates)")

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
