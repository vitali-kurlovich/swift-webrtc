//
//  Created by Kurlovich Vitali on 5/29/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

struct PeerConnectionStatusInfo: View {
    let connection: PeerConnection

    var body: some View {
        TwoColumn {
            TwoColumnRow {
                Text("Connection").lineLimit(1)
            } second: {
                Status(state: connection.connectionState)
            }

            TwoColumnRow {
                Text("Signaling").lineLimit(1)
            } second: {
                Status(state: connection.signalingState)
            }

            TwoColumnRow {
                Text("Ice Connection").lineLimit(1)
            } second: {
                Status(state: connection.iceConnectionState)
            }

            TwoColumnRow {
                Text("Ice Gathering").lineLimit(1)
            } second: {
                Status(state: connection.iceGatheringState)
            }

        }.padding()
    }
}

#Preview {
    PeerConnectionStatusInfo(connection: try! PeerConnection(iceServers: []))
        .useDefaultStatusStyle()
}
