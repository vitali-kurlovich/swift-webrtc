//
//  Created by Kurlovich Vitali on 6/2/26.
//

import Logging
import OSLog
import SwiftUI
import SwiftWebRTC

struct PeerConnectionView: View {
    let connection: PeerConnection

    @Environment(\.loggingEvents)
    var loggingEvents

    @Environment(\.loggingSystem)
    var loggingSystem

    var body: some View {
        Button("Send Offer") {
            Task { [connection] in
                do {
                    loggingEvents.system.info("Send Offer")
                    _ = try await connection.offer()
                } catch {
                    loggingEvents.system.error("\(error.localizedDescription)", error: error)
                }
            }
        }

        Button("Send Ansver") {
            Task {
                do {
                    loggingEvents.system.info("Send Ansver")
                    _ = try await connection.answer()

                } catch {
                    loggingEvents.system.error("\(error.localizedDescription)", error: error)

                    loggingSystem.system.error("\(error.localizedDescription)")
                }
            }
        }
    }
}
