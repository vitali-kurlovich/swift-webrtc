//
//  Created by Kurlovich Vitali on 6/5/26.
//

import WebRTC

public class MediaSource: @unchecked Sendable {
    let mediaSource: RTCMediaSource

    init(_ mediaSource: RTCMediaSource) {
        self.mediaSource = mediaSource
    }
}

public extension MediaSource {
    var state: SourceState {
        SourceState(mediaSource.state)
    }
}
