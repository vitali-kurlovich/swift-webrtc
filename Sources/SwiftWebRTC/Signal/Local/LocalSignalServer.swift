//
//  Created by Kurlovich Vitali on 6/3/26.
//

import Foundation

public extension LocalSignalServer {
    struct Configuraton: Sendable {
        public var responseDelay: TimeInterval

        public init(responseDelay: TimeInterval = 0.5) {
            self.responseDelay = responseDelay
        }
    }
}

public final class LocalSignalServer: @unchecked Sendable {
    let configuration: Configuraton

    public init(configuration: Configuraton = .init()) {
        self.configuration = configuration
    }

    public private(set) lazy var primaryProvider: LocalSignalProvider = provider(with: .secondary)
    public private(set) lazy var secondaryProvider: LocalSignalProvider = provider(with: .primary)

    func send(session: SessionDescription, context: LocalSignalServerContext) async throws {
        await Task.sleep(seconds: configuration.responseDelay)

        switch context.destination {
        case .primary:
            primaryProvider.sessionsContinuation?.yield(session)
        case .secondary:
            secondaryProvider.sessionsContinuation?.yield(session)
        }
    }

    func send(candidate: IceCandidate, context: LocalSignalServerContext) async throws {
        await Task.sleep(seconds: configuration.responseDelay)

        switch context.destination {
        case .primary:
            primaryProvider.candidatesContinuation?.yield(candidate)
        case .secondary:
            secondaryProvider.candidatesContinuation?.yield(candidate)
        }
    }

    typealias Destination = LocalSignalServerContext.Destination

    private func provider(with destination: Destination) -> LocalSignalProvider {
        let context = LocalSignalServerContext(destination: destination, server: self)
        return LocalSignalProvider(context: context)
    }
}
