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

        let state = DataChannelState(dataChannel.readyState)

        logger?.debug("RTCDataChannelDelegate dataChannelDidChangeState: \(state)")

        stateContinuation?.yield(state)
        eventsContinuation?.yield(.statusChange)
    }

    /** The data channel successfully received a data buffer. */
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        assert(channel.channel === dataChannel)
        logger?.debug("RTCDataChannelDelegate didReceiveMessageWith: \(buffer.description)")

        let buffer = DataBuffer(data: buffer.data, isBinry: buffer.isBinary)
        let message = DataMessage(channelId: dataChannel.channelId, type: .incoming, buffer: buffer)

        messageUpdatesContinuation?.yield(message)
        eventsContinuation?.yield(.receiveMessage)
    }

    /** The data channel's `bufferedAmount` changed. */
    func dataChannel(_ dataChannel: RTCDataChannel, didChangeBufferedAmount amount: UInt64) {
        assert(channel.channel === dataChannel)
        logger?.debug("RTCDataChannelDelegate didChangeBufferedAmount: \(amount)")

        eventsContinuation?.yield(.changeBufferedAmount)
    }

    private(set) lazy var messageUpdates: AsyncStream<DataMessage> = AsyncStream { (continuation: AsyncStream<DataMessage>.Continuation) in
        self.messageUpdatesContinuation = continuation
    }

    private(set) var messageUpdatesContinuation: AsyncStream<DataMessage>.Continuation?

    private(set) lazy var stateUpdates: AsyncStream<DataChannelState> = AsyncStream { (continuation: AsyncStream<DataChannelState>.Continuation) in
        self.stateContinuation = continuation
    }

    private var stateContinuation: AsyncStream<DataChannelState>.Continuation?

    private(set) lazy var events: AsyncStream<DataChannelEvent> = AsyncStream { (continuation: AsyncStream<DataChannelEvent>.Continuation) in
        self.eventsContinuation = continuation
    }

    private(set) var eventsContinuation: AsyncStream<DataChannelEvent>.Continuation?
}
