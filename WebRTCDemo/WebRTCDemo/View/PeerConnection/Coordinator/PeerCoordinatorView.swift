//
//  Created by Kurlovich Vitali on 6/3/26.
//

import SwiftUI
import SwiftWebRTC

struct PeerCoordinatorView<Provider: SignalProvider>: View {
    let title: String
    let coordinator: PeerConnectionCoordinator<Provider>

    var body: some View {
        Form {
            Section(title) {
                PeerConnectionStatusInfo(connection: coordinator.connection)
            }

            Section {
                Button("Offer") {
                    Task {
                        try await coordinator.offer()
                    }
                }

                Button("Answer") {
                    Task {
                        try await coordinator.answer()
                    }
                }
            }
        }
    }
}
