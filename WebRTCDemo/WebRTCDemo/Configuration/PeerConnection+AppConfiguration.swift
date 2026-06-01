//
//  Created by Kurlovich Vitali on 6/1/26.
//

import SwiftWebRTC

extension PeerConnection {
    convenience init(_ configuration: AppConfiguration) throws {
        let iceServers = configuration.iceServers.map {
            IceServer(urlStrings: [$0])
        }

        try self.init(iceServers: iceServers)
    }
}
