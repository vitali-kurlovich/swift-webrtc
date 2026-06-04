//
//  Created by Kurlovich Vitali on 6/4/26.
//

import Logging
import WebRTC

public enum BidirectionalDataMessage: Hashable, Sendable {
    case send(DataMessage)
    case failureSend(DataMessage)
    case receive(DataMessage)
}

public final class BidirectionalDataChannel: ObservableObject, @unchecked Sendable {
    public let incoming: LocalDataChannel
    public let outcoming: RemoteDataChannel

    public let messages: AsyncStream<BidirectionalDataMessage>
    private let messagesContinuation: AsyncStream<BidirectionalDataMessage>.Continuation

    public let statusUpdate: AsyncStream<DataChannelState>
    private let statusUpdateContinuation: AsyncStream<DataChannelState>.Continuation
    // DataChannelState

    private var statusIncomingTask: Task<Void, Never>?
    private var statusOutcomingTask: Task<Void, Never>?

    deinit {
        messagesContinuation.finish()
        statusUpdateContinuation.finish()
    }

    public init(incoming: LocalDataChannel, outcoming: RemoteDataChannel) {
        assert(incoming.type == .local)
        assert(outcoming.type == .remote)

        self.incoming = incoming
        self.outcoming = outcoming

        let (messages, continuation) = AsyncStream.makeStream(of: BidirectionalDataMessage.self)
        self.messages = messages
        messagesContinuation = continuation

        let (statusUpdate, statusUpdateContinuation) = AsyncStream.makeStream(of: DataChannelState.self)
        self.statusUpdate = statusUpdate
        self.statusUpdateContinuation = statusUpdateContinuation
    }
}

extension BidirectionalDataChannel {
    func subscribeStatusUpdate() {
        let incomingStateUpdates = incoming.stateUpdates
        let outcomingStateUpdates = outcoming.stateUpdates

        statusIncomingTask = Task { [weak self] in
            for await _ in incomingStateUpdates {
                if let self {
                    statusUpdateContinuation.yield(readyState)
                    await invalidate()
                }
            }
        }

        statusOutcomingTask = Task { [weak self] in
            for await _ in outcomingStateUpdates {
                if let self {
                    statusUpdateContinuation.yield(readyState)
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

/*

 private extension PeerConnection {
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

 */

public extension BidirectionalDataChannel {
    var isReady: Bool {
        incoming.readyState == .open && outcoming.readyState == .open
    }

    var readyState: DataChannelState {
        incoming.readyState.merge(outcoming.readyState)
    }
}

public extension BidirectionalDataChannel {
    /** Attempt to send `buffer` on this data channel's underlying data transport. */
    func send(_ buffer: DataBuffer) -> Bool {
        let message = DataMessage(channelId: outcoming.channelId, type: .outcoming, buffer: buffer)

        if outcoming.send(buffer) {
            messagesContinuation.yield(.send(message))
            return true
        } else {
            messagesContinuation.yield(.failureSend(message))
            return false
        }
    }
}

extension DataChannelState {
    func merge(_ other: DataChannelState) -> DataChannelState {
        if other == self {
            return self
        }

        if self == .closed || other == .closed {
            return .closed
        }

        if self == .closing || other == .closing {
            return .closing
        }

        if self == .open {
            return other
        }

        if other == .open {
            return self
        }

        return .connecting
    }
}
