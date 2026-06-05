//
//  Created by Kurlovich Vitali on 6/4/26.
//

import Foundation
import WebRTC

public struct Statistics: Hashable, Sendable {
    /// The id of this subreport, e.g. "RTCMediaStreamTrack_receiver_2".
    public let id: String

    /// The timestamp of the subreport in microseconds since 1970-01-01T00:00:00Z.
    public let timestamp: Date

    /// The type of the subreport, e.g. "track", "codec".
    public let type: String

    /**  The keys and values of the subreport, e.g. "totalFramesDuration = 5.551".
     The values are  StatisticsValue
     */
    public let values: [String: StatisticsValue]
}

public enum StatisticsValue: Hashable, Sendable {
    case string(String)
    case number(NSNumber)

    case stringArray([String])
    case numberArray([NSNumber])

    case dictionary([String: NSNumber])
}

extension Statistics {
    init(_ statistics: RTCStatistics) {
        self.init(id: statistics.id,
                  timestamp: Date(timeIntervalSince1970: statistics.timestamp_us),
                  type: statistics.type,
                  values: StatisticsValue.values(statistics.values))
    }
}

private extension StatisticsValue {
    static func values(_ values: [String: NSObject]) -> [String: Self] {
        var result: [String: Self] = [:]

        for (key, value) in values {
            if let value = Self.value(from: value) {
                result[key] = value
            }
        }

        return result
    }

    static func value(from obj: NSObject) -> StatisticsValue? {
        if let string = obj as? String {
            return .string(string)
        }

        if let number = obj as? NSNumber {
            return .number(number)
        }

        if let strings = obj as? [String] {
            return .stringArray(strings)
        }

        if let numbers = obj as? [NSNumber] {
            return .numberArray(numbers)
        }

        if let dict = obj as? [String: NSNumber] {
            return .dictionary(dict)
        }

        return nil
    }
}
