//
//  Created by Kurlovich Vitali on 6/3/26.
//

import Logging
import WebRTC

public actor DataChannelHistory {
    public var logger: Logger?

    public let channel: DataChannel
    public private(set) var history: [HistoryDataItem]

    public let itemsUpdate: AsyncStream<HistoryDataItem>

    private var messagesTask: Task<Void, Never>?

    public init(channel: DataChannel, logger: Logger? = nil) {
        self.logger = logger
        self.channel = channel
        history = []

        let (stream, continuation) = AsyncStream<HistoryDataItem>.makeStream(of: HistoryDataItem.self)
        itemsUpdate = stream
        itemsContinuation = continuation
    }

    private let itemsContinuation: AsyncStream<HistoryDataItem>.Continuation
}

public extension DataChannelHistory {
    func clear() {
        history.removeAll()
    }
}

private extension DataChannelHistory {
    func append(_ message: DataMessage) {
        let id = history.count
        let date = Date.now

        let item = HistoryDataItem(id: id, date: date, message: message)

        logger?.info("\(String(describing: Self.self)) recieve new item")
        logger?.debug("\(item)")

        history.append(item)

        itemsContinuation.yield(item)
    }
}

private extension DataChannelHistory {
    func subscribeUpdates() {
        messagesTask = Task { [channel, weak self] in
            for await message in channel.messageUpdates {
                if let self {
                    await append(message)
                }
            }
        }
    }
}
