//
//  Created by Kurlovich Vitali on 6/1/26.
//

import InMemoryLogging
import Logging
import SwiftUI

struct LogsView: View {
    @StateObject
    var logs = LogsObserver()

    var body: some View {
        Table(messages) {
            TableColumn("ID") { message in
                Text(message.id, format: .number)
            }
            .width(min: 44, max: 66)
            TableColumn("Message", value: \.entry.message.description)
        }
    }
}

private extension LogsView {
    struct Message: Identifiable {
        let id: Int
        let entry: LogsObserver.Entry
    }

    var messages: some RandomAccessCollection<Message> {
        logs.entries.lazy.enumerated().reversed().map {
            Message(id: $0.offset, entry: $0.element)
        }
    }
}
