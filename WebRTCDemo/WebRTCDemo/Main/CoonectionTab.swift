//
//  Created by Kurlovich Vitali on 6/2/26.
//

import SwiftUI
import SwiftWebRTC

struct CoonectionTab: View {
    @Environment(\.connectionCoordinator)
    var connectionCoordinator

    @State
    private var showInspector: Bool = false

    var body: some View {
        NavigationStack {
            switch connectionCoordinator.status {
            case .uninitialized:
                ContentUnavailableView("Uninitialized", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                    .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))

            case let .ready(connection):
                PeerConnectionView(connection: connection)
                    .inspector(isPresented: $showInspector) {
                        PeerConnectionInfo(connection: connection)
                    }.toolbar {
                        Button("", systemImage: "info.circle") {
                            withAnimation {
                                showInspector.toggle()
                            }
                        }
                    }

            case let .faild(error):
                ContentUnavailableView("Faild", systemImage: "exclamationmark.circle.fill", description: Text(error.localizedDescription))
                    .symbolEffect(.bounce)
            }
        }
    }
}
