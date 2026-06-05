//
//  Created by Kurlovich Vitali on 6/1/26.
//

import Logging
import Observation
import SwiftUI
import SwiftWebRTC

extension EnvironmentValues {
    @Entry var connectionCoordinator: ConnectionCoordinator = .init()
}

@Observable
final class ConnectionCoordinator {
    enum Status {
        case uninitialized
        case ready(PeerConnection)
        case faild(any Error)
    }

    private var iceServers: [String] = []

    let factory = PeerConnectionFactory(logger: LoggingEvents.default.webrct)

    var status: Status = .uninitialized

    func update(with configuration: AppConfiguration) {
        guard Set(configuration.iceServers) != Set(iceServers) else {
            return
        }

        iceServers = configuration.iceServers

        guard !iceServers.isEmpty else {
            return
        }

        do {
            let servers = iceServers.map { IceServer(urlStrings: [$0]) }

            let connection = try factory.peerConnection(iceServers: servers)

            status = .ready(connection)

        } catch {
            status = .faild(error)
        }
    }
}
