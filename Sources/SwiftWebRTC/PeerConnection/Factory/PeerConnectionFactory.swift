//
//  Created by Kurlovich Vitali on 6/5/26.
//

import Logging
import WebRTC

public enum PeerConnectionFactoryError: Error {
    case cantCreatePeerConnection
}

public final class PeerConnectionFactory: @unchecked Sendable {
    let factory: RTCPeerConnectionFactory

    var logger: Logger?

    deinit {
        logger?.debug("\(String(describing: Self.self)) deinit")
        logger?.info("\(String(describing: Self.self)) RTCCleanupSSL")
        RTCCleanupSSL()
    }

    public init(logger: Logger? = nil) {
        self.logger = logger

        logger?.info("\(String(describing: Self.self)) RTCInitializeSSL")

        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        factory = RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }
}

public extension PeerConnectionFactory {
    func peerConnection(configuration: Configuration,
                        options: PeerMediaOption = [.tlsSrtp],
                        logger: Logger? = nil) throws -> PeerConnection
    {
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil,
                                              optionalConstraints: options.dict)

        guard let connection = factory.peerConnection(with: .init(configuration), constraints: constraints, delegate: nil) else {
            throw PeerConnectionFactoryError.cantCreatePeerConnection
        }

        return PeerConnection(peerConnection: connection, logger: logger ?? self.logger)
    }

    func peerConnection(iceServers: [IceServer],
                        options: PeerMediaOption = [.tlsSrtp],
                        logger: Logger? = nil) throws -> PeerConnection
    {
        var configuration = Configuration()
        configuration.iceServers = iceServers

        // Unified plan is more superior than planB
        configuration.sdpSemantics = .unifiedPlan

        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        configuration.continualGatheringPolicy = .gatherContinually

        return try peerConnection(configuration: configuration, options: options, logger: logger)
    }
}
