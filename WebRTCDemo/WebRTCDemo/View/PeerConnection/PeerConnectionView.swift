//
//  Created by Kurlovich Vitali on 6/2/26.
//

import SwiftUI
import SwiftWebRTC

struct PeerConnectionView: View {
    let connection: PeerConnection

    var body: some View {
        Button("Send Offer") {
            Task { [connection] in
                try await connection.offer()
            }
        }

        Button("Send Ansver") {
            Task {
                _ = try await connection.answer()
            }
        }
    }
}
