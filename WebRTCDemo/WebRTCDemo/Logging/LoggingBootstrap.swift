//
//  Created by Kurlovich Vitali on 6/1/26.
//

import Foundation
import InMemoryLogging
import Logging

final class LoggingBootstrap {
    private var isBootstrapped: Bool

    let inMemoryHandler = InMemoryLogHandler()
    private let observationLogHandler = ObservationLogHandler()

    private init() {
        isBootstrapped = false
    }
}

extension LoggingBootstrap {
    static let `default` = LoggingBootstrap()
}

extension LoggingBootstrap {
    func events() -> some AsyncSequence<LogEvent, Never> {
        observationLogHandler.events()
    }
}

extension LoggingBootstrap {
    func bootstrap() {
        guard isBootstrapped == false else {
            return
        }

        LoggingSystem.bootstrap { [inMemoryHandler, observationLogHandler] label in
            var consoleHandler = StreamLogHandler.standardOutput(label: label)
            consoleHandler.logLevel = .debug

            let subsystem = Bundle.main.bundleIdentifier ?? ""

            let osLogHandler = OSLogHandler(subsystem: subsystem, metadata: .init(), logLevel: .debug)

            return MultiplexLogHandler([
                osLogHandler,
                inMemoryHandler,
                observationLogHandler,
            ])
        }

        isBootstrapped = true
    }
}
