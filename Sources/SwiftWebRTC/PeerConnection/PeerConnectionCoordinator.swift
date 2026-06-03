//
//  Created by Kurlovich Vitali on 6/3/26.
//

import Logging
import Observation

@Observable
public final class PeerConnectionCoordinator<Provider: SignalProvider>: @unchecked Sendable {
    public var logger: Logger?

    public let connection: PeerConnection
    public let signalProvider: Provider

    private var eventsTask: Task<Void, Never>?
    private var sessionsTask: Task<Void, Never>?
    private var candidatesTask: Task<Void, Never>?

    public private(set) var channels: [DataChannel] = []

    public init(connection: PeerConnection, signalProvider: Provider, logger: Logger? = nil) {
        self.connection = connection
        self.signalProvider = signalProvider
        self.logger = logger

        subscribeEvents()
        subscribeSessions()
        subscribeCandidates()
    }
}

public extension PeerConnectionCoordinator {
    func offer() async throws {
        do {
            logger?.info("\(String(describing: Self.self)) offer")
            let session = try await connection.offer()
            logger?.debug("\(String(describing: Self.self))  \(session)")

            logger?.info("\(String(describing: Self.self)) signalProvider.send session")
            try await signalProvider.send(session: session)
        } catch {
            logger?.error("\(String(describing: Self.self)) \(error)", error: error)
            throw error
        }
    }

    func answer() async throws {
        do {
            logger?.info("\(String(describing: Self.self)) answer")
            let session = try await connection.answer()
            logger?.debug("\(String(describing: Self.self))  \(session)")

            logger?.info("\(String(describing: Self.self)) signalProvider.send session")
            try await signalProvider.send(session: session)
        } catch {
            logger?.error("\(String(describing: Self.self)) \(error)", error: error)
            throw error
        }
    }

    func newChannel(label: String) throws -> DataChannel {
        do {
            logger?.info("\(String(describing: Self.self)) channel label:\(label)")
            let channel = try connection.channel(label: label)
            channels.append(channel)
            return channel

        } catch {
            logger?.error("\(String(describing: Self.self)) \(error)", error: error)
            throw error
        }
    }
}

private extension PeerConnectionCoordinator {
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

    func subscribeSessions() {
        logger?.info("\(String(describing: Self.self)) subscribeCandidates")

        sessionsTask = Task { [weak self] in
            guard let signalProvider = self?.signalProvider else {
                return
            }

            for await session in signalProvider.sessions() {
                guard let self else { return }
                Task {
                    try await self.recieve(session: session)
                }
            }
        }
    }

    func subscribeCandidates() {
        logger?.info("\(String(describing: Self.self)) subscribeCandidates")

        candidatesTask = Task { [weak self] in
            guard let signalProvider = self?.signalProvider else {
                return
            }

            for await candidate in signalProvider.candidates() {
                guard let self else { return }
                Task {
                    try await self.recieve(candidate: candidate)
                }
            }
        }
    }
}

private extension PeerConnectionCoordinator {
    func update(event: PeerConnectionEvent) {
        switch event {
        case .addMediaStream:
            logger?.debug("\(String(describing: Self.self)) addMediaStream")
        case .removeMediaStream:
            logger?.debug("\(String(describing: Self.self)) removeMediaStream")
        case .shouldNegotiate:
            logger?.debug("\(String(describing: Self.self)) shouldNegotiate")
        case let .generateCandidate(candidate):
            logger?.debug("\(String(describing: Self.self)) generateCandidate \(candidate)")
            Task {
                try await send(candidate: candidate)
            }
        case .removeCandidateas:
            logger?.debug("\(String(describing: Self.self)) removeCandidateas")
        case let .openChannel(channel):
            logger?.debug("\(String(describing: Self.self)) openChannel \(channel)")
            channels.append(channel)
        }
    }
}

private extension PeerConnectionCoordinator {
    func send(candidate: IceCandidate) async throws {
        logger?.info("\(String(describing: Self.self)) send candidate \(candidate)")
        logger?.debug("\(candidate)")

        try await signalProvider.send(candidate: candidate)
    }

    func send(session: SessionDescription) async throws {
        logger?.info("\(String(describing: Self.self)) send session")
        logger?.debug("\(session)")
        try await signalProvider.send(session: session)
    }
}

private extension PeerConnectionCoordinator {
    func recieve(candidate: IceCandidate) async throws {
        logger?.info("\(String(describing: Self.self)) recieve candidate")
        logger?.debug("\(candidate)")
        try await connection.add(candidate)
    }

    func recieve(session: SessionDescription) async throws {
        logger?.info("\(String(describing: Self.self)) recieve session")
        logger?.debug("\(session)")

        try await connection.setRemote(session)
    }
}
