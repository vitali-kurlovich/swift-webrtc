//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public final class AudioSource: MediaSource {
    override init(_ mediaSource: RTCMediaSource) {
        assert(mediaSource is RTCAudioSource)

        super.init(mediaSource)
    }
}

public extension AudioSource {
    var volume: Double {
        get {
            audioSource.volume
        }
        set {
            audioSource.volume = newValue
        }
    }
}

private extension AudioSource {
    var audioSource: RTCAudioSource {
        mediaSource as! RTCAudioSource
    }
}
