//
//  Created by Kurlovich Vitali on 5/23/26.
//

import SwiftUI
import SwiftWebRTC

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Local Signal Server", systemImage: "personalhotspot") {
                LocalServerTab()
            }

            Tab("Peer Coonection", systemImage: "network") {
                CoonectionTab()
            }

            Tab("Video", systemImage: "video") {
                // SentView()
            }

            Tab("Messages", systemImage: "message") {
                // SentView()
            }

            Tab("Logs", systemImage: "list.dash") {
                LogsView()
            }
        }.tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    @Previewable @State
    var connectionCoordinator = ConnectionCoordinator()

    AppConfigurationLoader {
        MainView()
            .environment(\.connectionCoordinator, connectionCoordinator)
    }.onReady { configuration in
        connectionCoordinator.update(with: configuration)
    }
    .useDefaultStatusStyle()
}
