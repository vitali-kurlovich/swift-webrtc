//
//  Created by Kurlovich Vitali on 5/28/26.
//

import Logging
import WebRTC

final class DataChannelDelegate: NSObject, RTCDataChannelDelegate, @unchecked Sendable {
    weak var channel: DataChannel?

    var logger: Logger?

    private let handlersStorage = DataChannelHandlersStorage()

    /** The data channel state changed. */
    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        assert(channel?.channel === dataChannel)

        let readyState = dataChannel.readyState
        logger?.debug("RTCDataChannelDelegate dataChannelDidChangeState: \(readyState)")

        channel?.readyState = DataChannelState(readyState)
    }

    /** The data channel successfully received a data buffer. */
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        assert(channel?.channel === dataChannel)
        logger?.debug("RTCDataChannelDelegate didReceiveMessageWith: \(buffer.description)")

        let buffer = DataBuffer(data: buffer.data, isBinry: buffer.isBinary)

        // TODO: use NotificationCenter for `messages`
    }

    /** The data channel's `bufferedAmount` changed. */
    func dataChannel(_ dataChannel: RTCDataChannel, didChangeBufferedAmount amount: UInt64) {
        assert(channel?.channel === dataChannel)
        logger?.debug("RTCDataChannelDelegate didChangeBufferedAmount: \(amount)")
    }
}

extension DataChannelDelegate {
    func messages() -> AsyncStream<DataBuffer> {
        let uuid = UUID()

        let storage = handlersStorage

        return AsyncStream { continuation in
            continuation.onTermination = { @Sendable _ in
                Task {
                    await storage.remove(with: uuid)
                }
            }

            let handler = DataChannelHandler { buffer in
                continuation.yield(buffer)
            }

            Task {
                await storage.add(handler, with: uuid)
            }
        }
    }
}

/*

 /*  The data channel state changed. */
 func dataChannelDidChangeState(_ dataChannel: RTCDataChannel)

 /*  The data channel successfully received a data buffer. */
 func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer)

 /*  The data channel's `bufferedAmount` changed. */
 optional func dataChannel(_ dataChannel: RTCDataChannel, didChangeBufferedAmount amount: UInt64)

 */

private struct DataChannelHandler {
    let handler: @Sendable (DataBuffer) -> Void

    func receive(_ buffer: DataBuffer) {
        handler(buffer)
    }
}

private actor DataChannelHandlersStorage {
    private var handlers: [UUID: DataChannelHandler] = [:]

    func add(_ handler: DataChannelHandler, with uuid: UUID) {
        handlers[uuid] = handler
    }

    func remove(with uuid: UUID) {
        handlers[uuid] = nil
    }

    func didReceive(_ buffer: DataBuffer) {
        Task {
            for (_, handler) in handlers {
                handler.receive(buffer)
            }
        }
    }
}
