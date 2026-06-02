//
//  Created by Kurlovich Vitali on 6/2/26.
//

import Logging
import SwiftUI
import SwiftWebRTC

struct PeerConnectionView: View {
    let connection: PeerConnection

    var body: some View {
        Button("Send Offer") {
            Task {
                try await connection.offer()
            }
        }

        Button("Send Ansver") {
            Task {
                try await connection.answer()
            }
        }
    }
}
