//
//  Created by Kurlovich Vitali on 6/3/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

struct DataChannelGroup<Content: View>: View {
    @ObservedObject
    var channel: DataChannel

    let content: (DataChannel) -> Content

    @State
    private var isExpanded = false

    init(channel: DataChannel, @ViewBuilder content: @escaping (DataChannel) -> Content) {
        self.channel = channel
        self.content = content
        isExpanded = isExpanded
    }

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            content(channel)
        } label: {
            HStack {
                Status(state: channel.readyState)
                Spacer()
                Text(channel.label)
            }
        }.contextMenu {
            Button(role: .destructive) {
                channel.close()
            } label: {
                Label("Close Channel", systemImage: "trash")
            }
        }
    }
}
