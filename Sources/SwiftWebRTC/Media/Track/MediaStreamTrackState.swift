//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

/**
 * Represents the state of the track. This exposes the same states in C++.
 */
public enum MediaStreamTrackState: Int8, Hashable, CaseIterable, Codable, Sendable {
    case live = 0

    case ended = 1
}

extension MediaStreamTrackState {
    init(_ state: RTCMediaStreamTrackState) {
        if state == .live {
            self = .live
        } else {
            self = .ended
        }
    }
}
