//
//  Created by Kurlovich Vitali on 5/31/26.
//

import WebRTC

public struct DataBuffer: Hashable, Sendable {
    public let data: Data
    public let isBinry: Bool

    public init(data: Data, isBinry: Bool) {
        self.data = data
        self.isBinry = isBinry
    }
}
