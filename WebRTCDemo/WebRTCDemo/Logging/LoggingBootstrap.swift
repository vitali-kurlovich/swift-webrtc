//
//  Created by Kurlovich Vitali on 6/1/26.
//

import Foundation
import InMemoryLogging
import Logging

final class LoggingBootstrap: @unchecked Sendable {
    private var isBootstrapped: Bool

    let inMemoryHandler = InMemoryLogHandler()
    private let eventsReporterHandler = LogEventsReporterHandler()

    private init() {
        isBootstrapped = false
    }
}

extension LoggingBootstrap {
    static let `default` = LoggingBootstrap()
}

extension LoggingBootstrap {
    var events: AsyncStream<LogEvent> {
        eventsReporterHandler.events
    }
}

extension LoggingBootstrap {
    func bootstrap() {
        guard isBootstrapped == false else {
            return
        }

        LoggingSystem.bootstrap { [inMemoryHandler, eventsReporterHandler] label in
            var consoleHandler = StreamLogHandler.standardOutput(label: label)
            consoleHandler.logLevel = .debug

            let osLogHandler = OSLogHandler(label: label, subsystem: "Events", metadata: .init(), logLevel: .debug)

            return MultiplexLogHandler([
                osLogHandler,
                inMemoryHandler,
                eventsReporterHandler,
            ])
        }

        isBootstrapped = true
    }
}
