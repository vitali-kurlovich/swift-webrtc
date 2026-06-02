//
//  Created by Kurlovich Vitali on 5/27/26.
//

import Logging
import Observation
import WebRTC

@Observable
public final class DataChannel: @unchecked Sendable {
    /** The state of the data channel. */
    public internal(set) var readyState: DataChannelState

    let channel: RTCDataChannel
    private let channelDelegate: DataChannelDelegate

    init(_ channel: RTCDataChannel) {
        self.channel = channel
        readyState = DataChannelState(channel.readyState)
        channelDelegate = DataChannelDelegate()
        channelDelegate.channel = self

        channel.delegate = channelDelegate
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

public extension DataChannel {
    /** Attempt to send `buffer` on this data channel's underlying data transport. */
    func send(_ buffer: DataBuffer) -> Bool {
        logger?.info("\(String(describing: Self.self)) send")
        logger?.debug("buffer \(buffer)")

        let buffer = RTCDataBuffer(data: buffer.data, isBinary: buffer.isBinry)

        return channel.sendData(buffer)
    }

    /** Closes the data channel. */
    func close() {
        logger?.info("\(String(describing: Self.self)) close")
        channel.close()
    }

    func messages() -> AsyncStream<DataBuffer> {
        channelDelegate.messages()
    }
}

public extension DataChannel {
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
    var maxPacketLifeTime: UInt16 {
        channel.maxPacketLifeTime
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
