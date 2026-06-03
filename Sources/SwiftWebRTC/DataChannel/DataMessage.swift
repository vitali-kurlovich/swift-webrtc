//
//  Created by Kurlovich Vitali on 6/3/26.
//

public enum DataMessageType: Hashable, Sendable {
    case incoming
    case outcoming
}

public struct DataMessage: Hashable, Sendable {
    public let channelId: Int32
    public let type: DataMessageType
    public let buffer: DataBuffer
}
