//
//  Created by Kurlovich Vitali on 5/28/26.
//

import Logging
import WebRTC

final class DataChannelDelegate: NSObject, RTCDataChannelDelegate, @unchecked Sendable {
    // unowned var channel: DataChannel!

    let messageUpdates: AsyncStream<DataMessage>
    let messageUpdatesContinuation: AsyncStream<DataMessage>.Continuation

    let stateUpdates: AsyncStream<DataChannelState>
    private let stateContinuation: AsyncStream<DataChannelState>.Continuation

    let events: AsyncStream<DataChannelEvent>
    let eventsContinuation: AsyncStream<DataChannelEvent>.Continuation

    deinit {
        messageUpdatesContinuation.finish()
        stateContinuation.finish()
        eventsContinuation.finish()
    }

    override init() {
        let (messageUpdates, messageUpdatesContinuation) = AsyncStream.makeStream(of: DataMessage.self)
        self.messageUpdates = messageUpdates
        self.messageUpdatesContinuation = messageUpdatesContinuation

        let (stateUpdates, stateContinuation) = AsyncStream.makeStream(of: DataChannelState.self)
        self.stateUpdates = stateUpdates
        self.stateContinuation = stateContinuation

        let (events, eventsContinuation) = AsyncStream.makeStream(of: DataChannelEvent.self)
        self.events = events
        self.eventsContinuation = eventsContinuation

        super.init()
    }

    var logger: Logger?

    /** The data channel state changed. */
    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        let state = DataChannelState(dataChannel.readyState)

        logger?.debug("RTCDataChannelDelegate dataChannelDidChangeState: \(state)")

        stateContinuation.yield(state)
        eventsContinuation.yield(.statusChange)
    }

    /** The data channel successfully received a data buffer. */
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        logger?.debug("RTCDataChannelDelegate didReceiveMessageWith: \(buffer.description)")

        let buffer = DataBuffer(data: buffer.data, isBinry: buffer.isBinary)
        let message = DataMessage(channelId: dataChannel.channelId, type: .incoming, buffer: buffer)

        messageUpdatesContinuation.yield(message)
        eventsContinuation.yield(.receiveMessage)
    }

    /** The data channel's `bufferedAmount` changed. */
    func dataChannel(_: RTCDataChannel, didChangeBufferedAmount amount: UInt64) {
        logger?.debug("RTCDataChannelDelegate didChangeBufferedAmount: \(amount)")

        eventsContinuation.yield(.changeBufferedAmount)
    }
}
