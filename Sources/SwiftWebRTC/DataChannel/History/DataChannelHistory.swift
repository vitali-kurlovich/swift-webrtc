//
//  Created by Kurlovich Vitali on 6/3/26.
//

import Logging
import WebRTC

public final class DataChannelHistory: @unchecked Sendable {
    public var logger: Logger?

    public let channel: DataChannel
    public private(set) var history: [HistoryDataItem]

    private var messagesTask: Task<Void, Never>?

    public init(channel: DataChannel, logger: Logger? = nil) {
        self.logger = logger
        self.channel = channel
        history = []
    }

    private(set) lazy var stateUpdates: AsyncStream<HistoryDataItem> = AsyncStream { (continuation: AsyncStream<HistoryDataItem>.Continuation) in
        self.itemsContinuation = continuation
    }

    private var itemsContinuation: AsyncStream<HistoryDataItem>.Continuation?
}

private extension DataChannelHistory {
    func append(_ message: DataMessage) {
        let id = history.count
        let date = Date.now

        let item = HistoryDataItem(id: id, date: date, message: message)

        logger?.info("\(String(describing: Self.self)) recieve new item")
        logger?.debug("\(item)")

        history.append(item)

        itemsContinuation?.yield(item)
    }
}

private extension DataChannelHistory {
    func subscribeUpdates() {
        messagesTask = Task { [channel, weak self] in
            for await message in channel.messageUpdates {
                self?.append(message)
            }
        }
    }
}
