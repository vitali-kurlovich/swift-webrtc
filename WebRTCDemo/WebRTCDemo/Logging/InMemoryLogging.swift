//
//  Created by Kurlovich Vitali on 6/1/26.
//

import Logging

struct InMemoryLogging: LogHandler {
    let storage: InMemoryLogEventsStorage

    var metadata: Logging.Logger.Metadata

    var logLevel: Logging.Logger.Level

    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            metadata[key]
        }
        set {
            metadata[key] = newValue
        }
    }

    func log(event: LogEvent) {
        Task {
            await storage.append(event: event)
        }
    }
}
