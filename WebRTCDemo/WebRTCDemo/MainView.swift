//
//  Created by Kurlovich Vitali on 5/23/26.
//

import Logging
import OSLog
import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

private let logging = Logger(label: "MainView")

struct MainView: View {
    var body: some View {
        // IceServersListView()

        TabView {
            Tab("Peer Coonection", systemImage: "network") {
                NavigationStack {
                    Coonection()
                }
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

struct Coonection: View {
    @Environment(\.connectionCoordinator)
    var connectionCoordinator

    @State
    private var showInspector: Bool = false

    var body: some View {
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

protocol SignalProvider {
    func sendOffer(_ session: SessionDescription) async throws

    func sendAnswer(_ session: SessionDescription) async throws
}

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

struct PeerConnectionInfo: View {
    let connection: PeerConnection

    @State
    private var offerSessionDescription: SessionDescription?

    var body: some View {
        Form {
            Section("Status") {
                PeerConnectionStatusInfo(connection: connection)
            }

            Section {
                if let session = connection.localDescription {
                    SessionDescriptionInfo(session: session)
                }
            }
        }
    }
}

struct SessionDescriptionInfo: View {
    let session: SessionDescription

    var body: some View {
        TwoColumn {
            TwoColumnRow {
                Text("Type").font(.headline)
            } second: {
                Status(state: session.type)
            }

            TwoColumnRow {
                Text("SDP").font(.headline)
            } second: {
                // ScrollView {
                Text(session.sdp)
                    .textSelection(.enabled)
                    .lineLimit(5)
                    .multilineTextAlignment(strategy: .default)

                // .copyable([session.sdp])
                // }
            }
        }
    }
}

struct ChannelsView: View {
    @State
    private var inputText: String = ""

    var body: some View {
        VStack {
            TextEditor(text: $inputText)
                .border(Color.secondary)

            HStack {
                Spacer()
                Button("Send") {}
            }
        }.padding()
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
