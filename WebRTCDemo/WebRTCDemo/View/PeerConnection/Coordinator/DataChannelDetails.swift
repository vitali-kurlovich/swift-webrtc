//
//  Created by Kurlovich Vitali on 6/3/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

struct DataChannelDetails: View {
    @ObservedObject
    var channel: DataChannel

    @State
    private var inputText: String = ""

    @State
    private var isExpanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            LabeledContent("Channel Id", value: channel.channelId, format: .number)

            LabeledContent("Is Ordered") {
                Image(systemName: channel.isOrdered ? "checkmark" : "xmark")
            }

            LabeledContent("Is Negotiated") {
                Image(systemName: channel.isNegotiated ? "checkmark" : "xmark")
            }

            LabeledContent("Max Packet Life Time", value: channel.maxPacketLifeTime.formatted())

            LabeledContent("Max Retransmits", value: channel.maxRetransmits, format: .number)

            LabeledContent("Buffered Amount", value: Int(channel.bufferedAmount), format: .number)
        } label: {
            Label("Details", systemImage: "info.circle")
        }

        TextField("Message", text: $inputText, axis: .vertical)
            .lineLimit(3 ... 6)

        HStack {
            Spacer()

            Button("Send Message", role: .confirm) {
                let data = Data(inputText.utf8)
                let buffer = DataBuffer(data: data, isBinry: false)

                if channel.send(buffer) {
                    debugPrint("Sending data")
                    inputText = ""
                } else {
                    debugPrint("Data do not sending")
                }

            }.disabled(inputText.isEmpty || channel.readyState == .closed)
        }

        Button("Close Channel", role: .destructive) {
            channel.close()
        }.disabled(channel.readyState == .closed)
    }
}
