//
//  Created by Kurlovich Vitali on 6/5/26.
//

public enum MediaStreamTrackKind: Int8, Hashable, CaseIterable, Codable, Sendable {
    case audio = 0
    case video = 1
    case other = -1
}
