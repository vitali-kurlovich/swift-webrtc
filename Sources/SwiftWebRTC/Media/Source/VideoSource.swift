//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public final class VideoSource: MediaSource {
    override init(_ mediaSource: RTCMediaSource) {
        assert(mediaSource is RTCVideoSource)

        super.init(mediaSource)
    }
}

public extension VideoSource {
    /**
     * Calling this function will cause frames to be scaled down to the
     * requested resolution. Also, frames will be cropped to match the
     * requested aspect ratio, and frames will be dropped to match the
     * requested fps. The requested aspect ratio is orientation agnostic and
     * will be adjusted to maintain the input orientation, so it doesn't
     * matter if e.g. 1280x720 or 720x1280 is requested.
     */
    func adaptOutputFormat(toWidth width: Int32, height: Int32, fps: Int32) {
        videoSource.adaptOutputFormat(toWidth: width, height: height, fps: fps)
    }
}

private extension VideoSource {
    var videoSource: RTCVideoSource {
        mediaSource as! RTCVideoSource
    }
}
