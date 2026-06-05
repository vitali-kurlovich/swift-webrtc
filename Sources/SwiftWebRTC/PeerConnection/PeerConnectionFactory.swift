//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public final class PeerConnectionFactory: @unchecked Sendable {
    let factory: RTCPeerConnectionFactory

    deinit {
        RTCCleanupSSL()
    }

    public init() {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        factory = RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }
}
