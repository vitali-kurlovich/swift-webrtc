//
//  Created by Kurlovich Vitali on 5/28/26.
//

import Logging
import WebRTC

final class DataChannelDelegate: NSObject, RTCDataChannelDelegate, @unchecked Sendable {
    unowned var channel: DataChannel!

    var logger: Logger?

    /** The data channel state changed. */
    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        assert(channel.channel === dataChannel)

        let readyState = dataChannel.readyState
        logger?.debug("RTCDataChannelDelegate dataChannelDidChangeState: \(readyState)")

        channel.readyState = DataChannelState(readyState)
    }

    /** The data channel successfully received a data buffer. */
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        assert(channel.channel === dataChannel)
        logger?.debug("RTCDataChannelDelegate didReceiveMessageWith: \(buffer.description)")

        let buffer = DataBuffer(data: buffer.data, isBinry: buffer.isBinary)
        let message = DataMessage(channelId: dataChannel.channelId, source: .remote, buffer: buffer)

        continuation?.yield(message)
    }

    /** The data channel's `bufferedAmount` changed. */
    func dataChannel(_ dataChannel: RTCDataChannel, didChangeBufferedAmount amount: UInt64) {
        assert(channel.channel === dataChannel)
        logger?.debug("RTCDataChannelDelegate didChangeBufferedAmount: \(amount)")
    }

    private(set) lazy var messages: AsyncStream<DataMessage> = AsyncStream { (continuation: AsyncStream<DataMessage>.Continuation) in
        self.continuation = continuation
    }

    var continuation: AsyncStream<DataMessage>.Continuation?
}
