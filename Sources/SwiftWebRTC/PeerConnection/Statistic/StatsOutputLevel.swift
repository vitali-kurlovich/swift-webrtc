//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

/** Represents the stats output level. */
public enum StatsOutputLevel: Int8, Hashable, CaseIterable, Codable, Sendable {
    case standard = 0

    case debug = 1
}

extension StatsOutputLevel {
    init(_ level: RTCStatsOutputLevel) {
        if level == .standard {
            self = .standard
        } else {
            self = .debug
        }
    }
}

extension RTCStatsOutputLevel {
    init(_ level: StatsOutputLevel) {
        if level == .standard {
            self = .standard
        } else {
            self = .debug
        }
    }
}
