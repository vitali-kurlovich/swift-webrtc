//
//  Created by Kurlovich Vitali on 5/28/26.
//

import SwiftUI

struct ChannelMessage: Identifiable {
    let id: Int
    let text: String
}

struct ChannelMessages: View {
    @Binding
    var messages: [ChannelMessage]

    @Binding
    var scrollPosition: ScrollPosition

    @State private var selection: ChannelMessage.ID?

    var body: some View {
        Table(messages) {
            TableColumn("ID") { message in
                Text(message.id, format: .number)
            }
            .width(min: 44, max: 66)
            TableColumn("Message", value: \.text)
        }
    }
}

#Preview {
    @Previewable
    @State
    var messages: [ChannelMessage] = (1 ..< 100).map {
        ChannelMessage(id: $0, text: "Message (\($0))")
    }

    @Previewable
    @State var scrollPosition: ScrollPosition = .init(idType: ChannelMessage.ID.self)

    ChannelMessages(messages: $messages, scrollPosition: $scrollPosition)
}
