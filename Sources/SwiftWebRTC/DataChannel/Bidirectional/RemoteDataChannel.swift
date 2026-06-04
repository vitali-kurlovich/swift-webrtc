//
//  Created by Kurlovich Vitali on 6/4/26.
//

import Logging
import WebRTC

public final class RemoteDataChannel: DataChannel {
    init(_ channel: RTCDataChannel, logger: Logger? = nil) {
        super.init(channel, type: .remote, logger: logger)
    }
}

public extension RemoteDataChannel {
    /** Attempt to send `buffer` on this data channel's underlying data transport. */
    func send(_ buffer: DataBuffer) -> Bool {
        _send(buffer)
    }
}
