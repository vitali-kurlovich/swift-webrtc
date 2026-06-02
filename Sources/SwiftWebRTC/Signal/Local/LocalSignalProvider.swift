//
//  Created by Kurlovich Vitali on 6/3/26.
//

public final class LocalSignalProvider: SignalProvider, @unchecked Sendable {
    let context: LocalSignalServerContext

    init(context: LocalSignalServerContext) {
        self.context = context
    }

    public func send(session: SessionDescription) async throws {
        try await context.send(session: session)
    }

    public func send(candidate: IceCandidate) async throws {
        try await context.send(candidate: candidate)
    }

    public func sessions() -> AsyncStream<SessionDescription> {
        sessionsStream
    }

    public func candidates() -> AsyncStream<IceCandidate> {
        candidatesStream
    }

    private lazy var sessionsStream: AsyncStream<SessionDescription> = AsyncStream { (continuation: AsyncStream<SessionDescription>.Continuation) in
        self.sessionsContinuation = continuation
    }

    private lazy var candidatesStream: AsyncStream<IceCandidate> = AsyncStream { (continuation: AsyncStream<IceCandidate>.Continuation) in
        self.candidatesContinuation = continuation
    }

    var sessionsContinuation: AsyncStream<SessionDescription>.Continuation?
    var candidatesContinuation: AsyncStream<IceCandidate>.Continuation?
}
