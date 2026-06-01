//
//  Created by Kurlovich Vitali on 6/1/26.
//

import Logging
import SwiftUI

struct LogMessage: Identifiable {
    let id: Int
    let logEvent: LogEvent
}

struct LogsView: View {
    @State
    private var scrollPosition: ScrollPosition = .init()

    let loggingStorage: InMemoryLogEventsStorage = LoggingBootstrap.default.inMemoryStorage

    var messages: [LogMessage] {
        loggingStorage.events.enumerated().reversed().map { el in
            let event = el.element
            let offset = el.offset

            return .init(id: offset, logEvent: event)
        }
    }

    var body: some View {
        Table(messages) {
            TableColumn("ID") { message in
                Text(message.id, format: .number)
            }
            .width(min: 44, max: 66)
            TableColumn("Message", value: \.logEvent.message.description)
        }
    }
}
