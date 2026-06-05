//
//  Created by Kurlovich Vitali on 6/4/26.
//

extension DataChannelState {
    func merge(_ other: DataChannelState) -> DataChannelState {
        if other == self {
            return self
        }

        if self == .closed || other == .closed {
            return .closed
        }

        if self == .closing || other == .closing {
            return .closing
        }

        if self == .open {
            return other
        }

        if other == .open {
            return self
        }

        return .connecting
    }
}
