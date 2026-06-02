//
//  Created by Kurlovich Vitali on 6/3/26.
//

final class LocalSignalServerContext: @unchecked Sendable {
    enum Destination {
        case primary
        case secondary
    }

    let destination: Destination
    weak var server: LocalSignalServer?

    init(destination: Destination, server: LocalSignalServer? = nil) {
        self.destination = destination
        self.server = server
    }

    func send(session: SessionDescription) async throws {
        try await server?.send(session: session, context: self)
    }

    func send(candidate: IceCandidate) async throws {
        try await server?.send(candidate: candidate, context: self)
    }
}
