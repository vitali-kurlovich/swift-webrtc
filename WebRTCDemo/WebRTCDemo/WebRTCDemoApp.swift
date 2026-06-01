//
//  Created by Kurlovich Vitali on 5/23/26.
//

import SwiftUI

@main
struct WebRTCDemoApp: App {
    @State
    private var connectionCoordinator = ConnectionCoordinator()

    var body: some Scene {
        WindowGroup {
            AppConfigurationLoader {
                MainView()
                    .environment(\.connectionCoordinator, connectionCoordinator)
            }.onReady { configuration in
                connectionCoordinator.update(with: configuration)
            }
            .useDefaultStatusGlassStyle()
        }
    }
}
