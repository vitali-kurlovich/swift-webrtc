//
//  Created by Kurlovich Vitali on 6/4/26.
//

import Logging
import WebRTC

public extension LocalDataChannel {
    var messageUpdates: AsyncStream<DataMessage> {
        _messageUpdates
    }
}

public final class LocalDataChannel: DataChannel {
    init(_ channel: RTCDataChannel, logger: Logger? = nil) {
        super.init(channel, type: .local, logger: logger)
    }
}
