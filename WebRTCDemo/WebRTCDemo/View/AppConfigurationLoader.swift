//
//  Created by Kurlovich Vitali on 5/28/26.
//

import SwiftUI

enum AppLoaderState {
    case ready(AppConfiguration)
    case inProgress
    case error(any Error)
}

struct AppConfigurationLoader<Content: View>: View {
    @State
    private var state: AppLoaderState = .inProgress

    @ViewBuilder let content: () -> Content

    let onReady: (AppConfiguration) -> Void

    init(onReady: @escaping (AppConfiguration) -> Void = { _ in }, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.onReady = onReady
    }

    var body: some View {
        switch state {
        case let .ready(appConfiguration):
            content().environment(\.appConfiguration, appConfiguration)
        case .inProgress:
            ProgressView("Loading settings")
                .task {
                    Task {
                        do {
                            let coordinator = AppConfigurationCoordinator()
                            let reader = try await coordinator.reader
                            let configuration = AppConfiguration(reader: reader)

                            onReady(configuration)
                            state = .ready(configuration)

                        } catch {
                            state = .error(error)
                        }
                    }
                }
        case let .error(error):
            List {
                Text(error.localizedDescription)
            }
            .refreshable {
                state = .inProgress
            }
        }
    }
}

extension AppConfigurationLoader {
    func onReady(_ ready: @escaping (AppConfiguration) -> Void) -> Self {
        .init(onReady: ready, content: content)
    }
}

#Preview {
    AppConfigurationLoader {
        IceServersListView()
    }.onReady { config in
        print("Ready")
        print("signalingServer: \(config.signalingServer)")
        print("iceServers: \(config.iceServers)")
    }
}
