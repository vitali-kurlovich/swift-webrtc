//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

public struct DataChannelConfiguration: Hashable, Codable, Sendable {
    /** Set to true if ordered delivery is required. */
    public var isOrdered: Bool

    /** The max number of retransmissions. -1 if unset. */
    public var maxRetransmits: Int32

    /** Set to YES if the channel has been externally negotiated and we do not send
     * an in-band signalling in the form of an "open" message.
     */
    public var isNegotiated: Bool

    /** The id of the data channel. */
    public var channelId: Int32

    public init(isOrdered: Bool,
                maxRetransmits: Int32,
                isNegotiated: Bool,
                channelId: Int32)
    {
        self.isOrdered = isOrdered
        self.maxRetransmits = maxRetransmits
        self.isNegotiated = isNegotiated
        self.channelId = channelId
    }
}

extension DataChannelConfiguration {
    public init() {
        let config = RTCDataChannelConfiguration()
        self.init(config)
    }

    init(_ config: RTCDataChannelConfiguration) {
        self.init(isOrdered: config.isOrdered,
                  maxRetransmits: config.maxRetransmits,
                  isNegotiated: config.isNegotiated,
                  channelId: config.channelId)
    }
}

extension RTCDataChannelConfiguration {
    convenience init(_ config: DataChannelConfiguration) {
        self.init()
        isOrdered = config.isOrdered
        maxRetransmits = config.maxRetransmits
        isNegotiated = config.isNegotiated
        channelId = config.channelId
    }
}
