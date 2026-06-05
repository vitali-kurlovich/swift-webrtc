//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

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
