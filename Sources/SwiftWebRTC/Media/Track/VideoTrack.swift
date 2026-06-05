//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public final class VideoTrack: MediaStreamTrack {
    override init(_ track: RTCMediaStreamTrack) {
        assert(track is RTCVideoTrack)
        super.init(track)
    }
}

public extension VideoTrack {
    /** The video source for this video track. */
    var source: VideoSource {
        VideoSource(videoTrack.source)
    }

    /** Register a renderer that will render all frames received on this track. */
    func add(_ renderer: any RTCVideoRenderer) {
        videoTrack.add(renderer)
    }

    /** Deregister a renderer. */
    func remove(_ renderer: any RTCVideoRenderer) {
        videoTrack.remove(renderer)
    }
}

extension VideoTrack {
    var videoTrack: RTCVideoTrack {
        track as! RTCVideoTrack
    }
}
