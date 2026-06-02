//
//  Created by Kurlovich Vitali on 6/3/26.
//

import Logging

public final class LocalServerConnection: @unchecked Sendable {
    let server = LocalSignalServer()

    let masterConnection: PeerConnection
    let secondaryConnection: PeerConnection

    public private(set) lazy var masterCoordinator = PeerConnectionCoordinator(connection: masterConnection,
                                                                               signalProvider: server.primaryProvider,
                                                                               logger: Logger(label: "MasterLocol"))

    public private(set) lazy var secondaryCoordinator = PeerConnectionCoordinator(connection: secondaryConnection,
                                                                                  signalProvider: server.secondaryProvider,
                                                                                  logger: Logger(label: "SecondaryLocol"))

    public init(master: PeerConnection, secondary: PeerConnection) {
        masterConnection = master
        secondaryConnection = secondary
    }
}
