//
//  Created by Kurlovich Vitali on 6/3/26.
//

public enum DataSource: Hashable, Sendable {
    case local
    case remote
}

public struct DataMessage: Hashable, Sendable {
    public let channelId: Int32
    public let source: DataSource
    public let buffer: DataBuffer
}
