//
//  Created by Kurlovich Vitali on 6/1/26.
//

import Logging
import OSLog

struct OSLogHandler: @preconcurrency LogHandler {
    let subsystem: String

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

    @MainActor func log(event: LogEvent) {
        let category = "category"
        let logger = Logger(subsystem: subsystem, category: category)

        logger.log(level: .init(event.level), "\(event.message.description)")
    }
}

extension OSLogType {
    init(_ type: Logging.Logger.Level) {
        switch type {
        case .trace:
            self = .debug
        case .debug:
            self = .debug
        case .info:
            self = .info
        case .notice:
            self = .info
        case .warning:
            self = .error
        case .error:
            self = .error
        case .critical:
            self = .fault
        }
    }
}
