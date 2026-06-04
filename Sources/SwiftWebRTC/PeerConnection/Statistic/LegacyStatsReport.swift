//
//  Created by Kurlovich Vitali on 6/4/26.
//

import Foundation
import WebRTC

public struct LegacyStatsReport {
    public let timestamp: Date

    /** The type of stats held by this object. */
    public let type: String

    /** The identifier for this object. */
    public let reportId: String

    /** A dictionary holding the actual stats. */
    public let values: [String: String]
}

extension LegacyStatsReport {
    init(_ report: RTCLegacyStatsReport) {
        self.init(timestamp: Date(timeIntervalSince1970: report.timestamp),
                  type: report.type,
                  reportId: report.reportId,
                  values: report.values)
    }
}
