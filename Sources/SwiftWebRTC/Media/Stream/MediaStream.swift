//
//  Created by Kurlovich Vitali on 6/5/26.
//

import Logging
import WebRTC

public final class MediaStream: @unchecked Sendable {
    public var logger: Logger?

    let mediaStream: RTCMediaStream

    init(mediaStream: RTCMediaStream, logger: Logger? = nil) {
        self.mediaStream = mediaStream
        self.logger = logger
    }
}

public extension MediaStream {
    /** An identifier for this media stream. */
    var streamId: String {
        mediaStream.streamId
    }
}

public extension MediaStream {
    /**  The audio tracks in this stream. */
    var audioTracks: [AudioTrack] {
        mediaStream.audioTracks.map { AudioTrack($0) }
    }

    /**  Adds the given audio track to this media stream. */
    func addAudioTrack(_ track: AudioTrack) {
        logger?.info("\(String(describing: Self.self)) addAudioTrack trackId: \(track.trackId)")
        mediaStream.addAudioTrack(track.audioTrack)
    }

    /**  Removes the given audio track to this media stream. */
    func removeAudioTrack(_ track: AudioTrack) {
        logger?.info("\(String(describing: Self.self)) removeAudioTrack trackId: \(track.trackId)")
        mediaStream.removeAudioTrack(track.audioTrack)
    }
}

public extension MediaStream {
    /**  The video tracks in this stream. */
    var videoTracks: [VideoTrack] {
        mediaStream.videoTracks.map { VideoTrack($0) }
    }

    /**  Adds the given video track to this media stream. */
    func addVideoTrack(_ track: VideoTrack) {
        logger?.info("\(String(describing: Self.self)) addVideoTrack trackId: \(track.trackId)")
        mediaStream.addVideoTrack(track.videoTrack)
    }

    /**  Removes the given video track to this media stream. */
    func removeVideoTrack(_ track: VideoTrack) {
        logger?.info("\(String(describing: Self.self)) removeVideoTrack trackId: \(track.trackId)")
        mediaStream.removeVideoTrack(track.videoTrack)
    }
}
