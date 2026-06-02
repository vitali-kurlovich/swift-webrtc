//
//  Created by Kurlovich Vitali on 6/2/26.
//

import SwiftUI
import SwiftWebRTC

struct PeerConnectionInfo: View {
    let connection: PeerConnection

    var body: some View {
        Form {
            Section("Status") {
                PeerConnectionStatusInfo(connection: connection)
            }

            Section {
                if let session = connection.localDescription {
                    SessionDescriptionInfo(session: session)
                }
            }
        }
    }
}
