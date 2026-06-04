//
//  Created by Kurlovich Vitali on 6/3/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

struct DataChannelDetails: View {
    @ObservedObject
    var channel: DataChannel

    var body: some View {
        LabeledContent("Channel Id", value: channel.channelId, format: .number)

        LabeledContent("Is Ordered") {
            Image(systemName: channel.isOrdered ? "checkmark" : "xmark")
        }

        LabeledContent("Is Negotiated") {
            Image(systemName: channel.isNegotiated ? "checkmark" : "xmark")
        }

        LabeledContent("Max Packet Life Time", value: channel.maxPacketLifeTime.formatted())

        LabeledContent("Max Retransmits", value: channel.maxRetransmits, format: .number)

        LabeledContent("Buffered Amount", value: Int(channel.bufferedAmount).formatted(.byteCount(style: .memory)))
    }
}
