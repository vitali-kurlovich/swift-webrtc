//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

public enum TlsCertPolicy: Int8, Hashable, CaseIterable, Codable, Sendable {
    case secure = 0

    case insecureNoCheck = 1
}

extension TlsCertPolicy {
    init(_ policy: RTCTlsCertPolicy) {
        if policy == .secure {
            self = .secure
        } else {
            self = .insecureNoCheck
        }
    }
}

extension RTCTlsCertPolicy {
    init(_ policy: TlsCertPolicy) {
        switch policy {
        case .secure:
            self = .secure
        case .insecureNoCheck:
            self = .insecureNoCheck
        }
    }
}
