//
//  Created by Kurlovich Vitali on 6/5/26.
//

import Logging

public protocol BidirectionalDataChannelMatching {
    func canBeMergedIntoBidirectionalChannel(local: LocalDataChannel, remote: RemoteDataChannel) -> Bool
}

final class ChannelResolver: @unchecked Sendable {
    let localChannel: LocalDataChannel
    let connection: PeerConnection
    let logger: Logger?

    private var eventsTask: Task<Void, Never>?

    init(connection: PeerConnection, local: LocalDataChannel, logger: Logger?) {
        self.connection = connection
        localChannel = local
        self.logger = logger
    }

    func subscribeEvents() {
        logger?.info("\(String(describing: Self.self)) subscribeEvents")

        eventsTask = Task { [weak self] in
            guard let connection = self?.connection else {
                return
            }

            for await event in connection.events {
                guard let self else { return }

                update(event: event)
            }
        }
    }

    func update(event: PeerConnectionEvent) {
        switch event {
        // -------- Channel --------
        case let .openChannel(channel):
            logger?.debug("\(String(describing: Self.self)) openChannel \(channel)")

        // -------- Close --------
        case .close:
            logger?.debug("\(String(describing: Self.self)) close")

        default:
            return
        }
    }
}
