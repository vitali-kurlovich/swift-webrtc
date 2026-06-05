//
//  Created by Kurlovich Vitali on 6/3/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

struct NewChannelAlert: View {
    @Binding
    var label: String

    let action: @MainActor () -> Void

    var body: some View {
        // Place your TextField inside the actions closure
        TextField("Channel label", text: $label)

        Button("Create", role: .confirm, action: action)
            .disabled(label.isEmpty)

        Button("Cancel", role: .cancel) { label = "" }
    }
}

struct PeerCoordinatorView: View {
    let title: String

    @ObservedObject
    var coordinator: PeerConnectionCoordinator

    @State
    private var isCreateChannelAlertPresented = false

    @State
    private var isChannelsExpanded = true

    @State
    private var newChannelName: String = "New Channel"

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
            Section("Channels") {
                ForEach(coordinator.channels) { channel in
                    Text("\(channel.readyState)")

//                    DataChannelGroup(channel: channel) { channel in
//                        DataChannelDetails(channel: channel)
//                    }
                }

                Button("New Channel") {
                    isCreateChannelAlertPresented.toggle()
                }
            }

        }.alert("New Channel", isPresented: $isCreateChannelAlertPresented) {
            NewChannelAlert(label: $newChannelName) {
                do {
                    _ = try coordinator.newChannel(label: newChannelName)
                } catch {}
            }
        } message: {
            Text("Input label for new channel.")
        }
    }
}
