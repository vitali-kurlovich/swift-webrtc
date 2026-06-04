//
//  Created by Kurlovich Vitali on 5/27/26.
//

import Logging
import WebRTC

public enum DataChannelType: Hashable, Sendable {
    case local
    case remote
}

public class DataChannel: ObservableObject, @unchecked Sendable {
    let channel: RTCDataChannel
    public let type: DataChannelType

    private let channelDelegate: DataChannelDelegate

    private var eventsTask: Task<Void, Never>?

    init(_ channel: RTCDataChannel, type: DataChannelType, logger: Logger? = nil) {
        self.type = type
        self.channel = channel

        channelDelegate = DataChannelDelegate()

        channel.delegate = channelDelegate

        self.logger = logger

        subscribeForEvents()
    }
}

public extension DataChannel {
    var logger: Logger? {
        get {
            channelDelegate.logger
        }
        set {
            channelDelegate.logger = newValue
        }
    }
}

extension DataChannel {
    var _messageUpdates: AsyncStream<DataMessage> {
        channelDelegate.messageUpdates
    }
}

public extension DataChannel {
    var stateUpdates: AsyncStream<DataChannelState> {
        channelDelegate.stateUpdates
    }

    var events: AsyncStream<DataChannelEvent> {
        channelDelegate.events
    }
}

public extension DataChannel {
    /** The state of the data channel. */
    var readyState: DataChannelState {
        DataChannelState(channel.readyState)
    }

    /**
     * A label that can be used to distinguish this data channel from other data
     * channel objects.
     */
    var label: String {
        channel.label
    }

    /** Returns whether this data channel is ordered or not. */
    var isOrdered: Bool {
        channel.isOrdered
    }

    /**
     * The length of the time window (in milliseconds) during which transmissions
     * and retransmissions may occur in unreliable mode.
     */
    var maxPacketLifeTime: Duration {
        .milliseconds(channel.maxPacketLifeTime)
    }

    /**
     * The maximum number of retransmissions that are attempted in unreliable mode.
     */
    var maxRetransmits: UInt16 {
        channel.maxRetransmits
    }

    /**
     * Returns whether this data channel was negotiated by the application or not.
     */
    var isNegotiated: Bool {
        channel.isNegotiated
    }

    /** The identifier for this data channel. */
    var channelId: Int32 {
        channel.channelId
    }

    /**
     * The number of bytes of application data that have been queued using
     * `sendData:` but that have not yet been transmitted to the network.
     */
    var bufferedAmount: UInt64 {
        channel.bufferedAmount
    }
}

extension DataChannel {
    /** Attempt to send `buffer` on this data channel's underlying data transport. */
    func _send(_ buffer: DataBuffer) -> Bool {
        logger?.info("\(String(describing: Self.self)) send")
        logger?.debug("buffer \(buffer)")

        let buffer = RTCDataBuffer(data: buffer.data, isBinary: buffer.isBinry)

        if channel.sendData(buffer) {
            let dataBuffer = DataBuffer(buffer)
            let message = DataMessage(channelId: channelId, type: .outcoming, buffer: dataBuffer)

            messageUpdatesContinuation.yield(message)
            eventsContinuation.yield(.sendMessage)

            return true
        }
        return false
    }
}

public extension DataChannel {
    /** Closes the data channel. */
    func close() {
        logger?.info("\(String(describing: Self.self)) close")
        channel.close()
        eventsContinuation.yield(.close)
    }
}

private extension DataChannel {
    var messageUpdatesContinuation: AsyncStream<DataMessage>.Continuation {
        channelDelegate.messageUpdatesContinuation
    }

    var eventsContinuation: AsyncStream<DataChannelEvent>.Continuation {
        channelDelegate.eventsContinuation
    }
}

private extension DataChannel {
    func subscribeForEvents() {
        eventsTask = Task { [weak self, events] in
            for await _ in events {
                if let self {
                    await invalidate()
                }
            }
        }
    }

    func invalidate() async {
        await MainActor.run {
            objectWillChange.send()
        }
    }
}
