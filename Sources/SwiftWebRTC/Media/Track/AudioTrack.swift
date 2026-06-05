//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public final class AudioTrack: MediaStreamTrack {
    override init(_ track: RTCMediaStreamTrack) {
        assert(track is RTCAudioTrack)
        super.init(track)
    }
}

public extension AudioTrack {
    /** The audio source for this audio track. */
    var source: AudioSource {
        AudioSource(audioTrack.source)
    }
}

extension AudioTrack {
    var audioTrack: RTCAudioTrack {
        track as! RTCAudioTrack
    }
}
