//
//  Created by Kurlovich Vitali on 5/23/26.
//

import SwiftUI

@main
struct WebRTCDemoApp: App {
    @State
    private var connectionCoordinator = ConnectionCoordinator()
    private let loggingBootstrap: LoggingBootstrap = .default

    init() {
        prepareLogging()
    }

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

private extension WebRTCDemoApp {
    func prepareLogging() {
        loggingBootstrap.bootstrap()
    }
}
