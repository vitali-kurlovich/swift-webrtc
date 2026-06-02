//
//  Created by Kurlovich Vitali on 6/2/26.
//

import Logging

struct LoggingEvents {}

extension LoggingEvents {
    @inlinable
    static var `default`: LoggingEvents {
        LoggingEvents()
    }
}

extension LoggingEvents {
    @inlinable
    var network: Logger {
        Logger(label: "network")
    }

    @inlinable
    var system: Logger {
        Logger(label: "system")
    }
}
