//
//  Created by Kurlovich Vitali on 6/3/26.
//

import SwiftUI
import SwiftWebRTC

struct LocalServerTab: View {
    @Environment(\.connectionCoordinator)
    var connectionCoordinator

    var body: some View {
        NavigationStack {
            switch connectionCoordinator.status {
            case .uninitialized:
                ContentUnavailableView("Uninitialized", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                    .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))

            case let .ready(connection):
                LocalPeerConnectionLoader(connection: connection)

            case let .faild(error):
                ContentUnavailableView("Faild", systemImage: "exclamationmark.circle.fill", description: Text(error.localizedDescription))
                    .symbolEffect(.bounce)
            }
        }
    }
}
