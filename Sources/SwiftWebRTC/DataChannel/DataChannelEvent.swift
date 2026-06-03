//
//  Created by Kurlovich Vitali on 6/3/26.
//

public enum DataChannelEvent: Hashable, Sendable {
    case statusChange
    case receiveMessage
    case sendMessage
    case changeBufferedAmount
    case close
}
