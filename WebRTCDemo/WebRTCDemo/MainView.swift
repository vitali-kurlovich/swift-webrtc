//
//  Created by Kurlovich Vitali on 5/23/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

struct MainView: View {
    var body: some View {
        // IceServersListView()

        TabView {
            Tab("Coonection", systemImage: "tray.and.arrow.down.fill") {
                Coonection()
            }

            Tab("Sent", systemImage: "tray.and.arrow.up.fill") {
                // SentView()
            }

            Tab("Account", systemImage: "person.crop.circle.fill") {
                // AccountView()
            }
        }
    }
}

struct Coonection: View {
    @Environment(\.connectionCoordinator)
    var connectionCoordinator

    var body: some View {
        switch connectionCoordinator.status {
        case .uninitialized:
            ContentUnavailableView("Uninitialized", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))

        case let .ready(connection):
            PeerConnectionMessages(connection: connection)

        case let .faild(error):
            ContentUnavailableView("Faild", systemImage: "exclamationmark.circle.fill", description: Text(error.localizedDescription))
                .symbolEffect(.bounce)
        }
    }
}

struct PeerConnectionMessages: View {
    /// @State
    private let connection: PeerConnection

    @State
    private var offerSessionDescription: SessionDescription?

    init(connection: PeerConnection, offerSessionDescription: SessionDescription? = nil) {
        self.connection = connection
        self.offerSessionDescription = offerSessionDescription
    }

    var body: some View {
        ScrollView {
            PeerConnectionStatusInfo(connection: connection)

            if let offerSessionDescription {
                SessionDescriptionInfo(session: offerSessionDescription)
            }

            Button("offer") {
                Task {
                    let dsc = try await connection.offer()
                    offerSessionDescription = dsc
                }
            }
        }.safeAreaPadding()
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
