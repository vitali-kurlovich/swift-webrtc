//
//  Created by Kurlovich Vitali on 6/2/26.
//

public protocol SignalProvider: Sendable {
    func send(session: SessionDescription) async throws
    func send(candidate: IceCandidate) async throws

    func sessions() -> AsyncStream<SessionDescription>
    func candidates() -> AsyncStream<IceCandidate>
}
