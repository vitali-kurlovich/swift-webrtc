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

public enum MediaStreamTrackKind: Int8, Hashable, CaseIterable, Codable, Sendable {
    case audio = 0
    case video = 1
    case other = -1
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

public class MediaStreamTrack: @unchecked Sendable {
    let track: RTCMediaStreamTrack

    init(_ track: RTCMediaStreamTrack) {
        self.track = track
    }
}

public extension MediaStreamTrack {
    /** The state of the track. */
    var readyState: MediaStreamTrackState {
        MediaStreamTrackState(track.readyState)
    }

    /**
     * The kind of track. For example, audio if this track represents an audio
     * track and video if this track represents a video track.
     */
    var kind: MediaStreamTrackKind {
        if track.kind == kRTCMediaStreamTrackKindAudio {
            return .audio
        }

        if track.kind == kRTCMediaStreamTrackKindVideo {
            return .video
        }

        return .other
    }

    /** An identifier string. */
    var trackId: String {
        track.trackId
    }

    /** The enabled state of the track. */
    var isEnabled: Bool {
        get {
            track.isEnabled
        }
        set {
            track.isEnabled = newValue
        }
    }
}
