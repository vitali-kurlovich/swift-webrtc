//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

public enum DataChannelState: Int8, Hashable, CaseIterable, Sendable {
    case connecting = 0
    case open = 1
    case closing = 2
    case closed = 3
}

extension DataChannelState {
    init(_ state: RTCDataChannelState) {
        switch state {
        case .connecting:
            self = .connecting
        case .open:
            self = .open
        case .closing:
            self = .closing
        case .closed:
            self = .closed
        @unknown default:
            self = .connecting
        }
    }
}
