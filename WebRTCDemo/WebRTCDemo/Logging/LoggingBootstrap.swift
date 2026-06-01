//
//  Created by Kurlovich Vitali on 6/1/26.
//

import Logging
import Observation

final class LoggingBootstrap {
    private var isBootstrapped: Bool

    let inMemoryStorage = InMemoryLogEventsStorage()

    private init() {
        isBootstrapped = false
    }
}

extension LoggingBootstrap {
    static let `default` = LoggingBootstrap()
}

extension LoggingBootstrap {
    func bootstrap() {
        guard isBootstrapped == false else {
            return
        }

        LoggingSystem.bootstrap { [inMemoryStorage] label in
            var consoleHandler = StreamLogHandler.standardOutput(label: label)
            consoleHandler.logLevel = .debug

            let inMemory = InMemoryLogging(storage: inMemoryStorage, metadata: .init(), logLevel: .info)

            return MultiplexLogHandler([
                consoleHandler,
                inMemory,
            ])
        }

        isBootstrapped = true
    }
}
