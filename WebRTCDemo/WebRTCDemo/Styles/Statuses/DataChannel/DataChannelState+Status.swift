//
//  Created by Kurlovich Vitali on 5/30/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

extension DataChannelState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .connecting:
            "Connecting"
        case .open:
            "Open"
        case .closing:
            "Closing"
        case .closed:
            "Closed"
        case .unknown:
            "Uncknown"
        }
    }
}

struct DataChannelStateColorResolver: StatusIndicatorColorResolver {
    func resolveColor(for state: DataChannelState) -> Color {
        switch state {
        case .connecting:
            Color.orange
        case .open:
            Color.green
        case .closing:
            Color.red
        case .closed:
            Color.secondary
        case .unknown:
            Color.secondary
        }
    }
}

#Preview {
    let resolver = DataChannelStateColorResolver()
    PreviewStatusCollection(resolver: resolver)
}
