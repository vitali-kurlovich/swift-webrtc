//
//  Created by Kurlovich Vitali on 6/3/26.
//

import Foundation

public struct HistoryDataItem: Hashable, Identifiable, Sendable {
    public let id: Int
    public let date: Date
    public let message: DataMessage
}
