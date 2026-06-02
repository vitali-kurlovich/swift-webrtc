//
//  Created by Kurlovich Vitali on 6/2/26.
//

import OSLog

struct OSLoggingSystem {
    let subsystem: String

    nonisolated init(subsystem: String = Bundle.main.bundleIdentifier ?? "") {
        self.subsystem = subsystem
    }
}

extension OSLoggingSystem {
    nonisolated static let `default` = OSLoggingSystem()

    @inlinable
    var network: Logger {
        Logger(subsystem: subsystem, category: "network")
    }

    @inlinable
    var system: Logger {
        Logger(subsystem: subsystem, category: "system")
    }
}
