//
//  Created by Kurlovich Vitali on 5/31/26.
//

import SwiftUI
import SwiftUIComponents
import WebRTC

struct RTCMediaStreamTrackInfo: View {
    let track: RTCMediaStreamTrack

    var body: some View {
        TwoColumn {
            TwoColumnRow {
                Text("King")
            } second: {
                Text(track.kind)
            }

            TwoColumnRow {
                Text("TrackId")
            } second: {
                Text(track.trackId)
            }

            TwoColumnRow {
                Text("readyState")
            } second: {
                Status(state: track.readyState)
            }
        }
    }
}

extension RTCMediaStreamTrackState: @retroactive CaseIterable {
    public static var allCases: [Self] {
        [
            .live,
            .ended,
        ]
    }
}

extension RTCMediaStreamTrackState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .live:
            return "Live"
        case .ended:
            return "Ended"
        @unknown default:
            return "Uncknown"
        }
    }
}

/*

 /*
  * Represents the state of the track. This exposes the same states in C++.
  */
 public enum RTCMediaStreamTrackState : Int, @unchecked Sendable {

     case live = 0

     case ended = 1
 }

 public let kRTCMediaStreamTrackKindAudio: String

 public let kRTCMediaStreamTrackKindVideo: String

 open class RTCMediaStreamTrack : NSObject {

     /*
      * The kind of track. For example, "audio" if this track represents an audio
      * track and "video" if this track represents a video track.
      */
     open var kind: String { get }

     /*  An identifier string. */
     open var trackId: String { get }

     /*  The enabled state of the track. */
     open var isEnabled: Bool

     /*  The state of the track. */
     open var readyState: RTCMediaStreamTrackState { get }
 }

 */
