//
//  Created by Kurlovich Vitali on 6/4/26.
//

import Foundation
import WebRTC

public struct StatisticsReport: Hashable, Sendable {
    public let timestamp: Date

    /** Statistics objects by id. */
    public let statistics: [String: Statistics]
}

extension StatisticsReport {
    init(_ statistics: RTCStatisticsReport) {
        self.init(timestamp: Date(timeIntervalSince1970: statistics.timestamp_us),
                  statistics: StatisticsReport.convert(from: statistics.statistics))
    }
}

private extension StatisticsReport {
    static func convert(from statistics: [String: RTCStatistics]) -> [String: Statistics] {
        var result: [String: Statistics] = [:]

        for (key, value) in statistics {
            result[key] = Statistics(value)
        }

        return result
    }
}
