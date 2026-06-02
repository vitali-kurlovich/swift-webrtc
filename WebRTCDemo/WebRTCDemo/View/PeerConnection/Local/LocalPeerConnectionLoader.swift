//
//  Created by Kurlovich Vitali on 6/3/26.
//

import Logging
import SwiftUI
import SwiftWebRTC

struct LocalPeerConnectionLoader: View {
    let connection: PeerConnection

    @Environment(\.appConfiguration)
    private var appConfiguration

    @State
    private var local: LocalServerConnection?

    var body: some View {
        if let local {
            LocalConnectionView(local: local)
        } else {
            ProgressView("Initialize local server...")
                .task {
                    do {
                        let iceServerURLs = appConfiguration.iceServers
                        let servers = iceServerURLs.map { IceServer(urlStrings: [$0]) }
                        let secondary = try PeerConnection(iceServers: servers)

                        secondary.logger = Logger(label: "SecondaryLocalConnection")

                        local = LocalServerConnection(master: connection, secondary: secondary)
                    } catch {}
                }
        }
    }
}
