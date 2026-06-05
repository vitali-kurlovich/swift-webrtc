//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public enum SourceState: Int8, Hashable, CaseIterable, Codable, Sendable {
    case initializing = 0

    case live = 1

    case ended = 2

    case muted = 3
}

extension SourceState {
    init(_ state: RTCSourceState) {
        switch state {
        case .initializing:
            self = .initializing
        case .live:
            self = .live
        case .ended:
            self = .ended
        case .muted:
            self = .muted
        @unknown default:
            assertionFailure("Unsuported state \(state)")
            self = .ended
        }
    }
}
