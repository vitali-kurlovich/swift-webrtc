//
//  Created by Kurlovich Vitali on 5/29/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

extension PeerConnectionState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .new:
            "New"
        case .connecting:
            "Connecting"
        case .connected:
            "Connected"
        case .disconnected:
            "Disconnected"
        case .failed:
            "Failed"
        case .closed:
            "Closed"
        case .unknown:
            "Uncknown"
        }
    }
}

struct PeerConnectionStatusColorResolver: StatusIndicatorColorResolver {
    func resolveColor(for state: PeerConnectionState) -> Color {
        switch state {
        case .new:
            Color.accentColor
        case .connecting:
            Color.orange
        case .connected:
            Color.green
        case .disconnected:
            Color.secondary
        case .failed:
            Color.red
        case .closed:
            Color.secondary
        case .unknown:
            Color.secondary
        }
    }
}

#Preview {
    let resolver = PeerConnectionStatusColorResolver()
    PreviewStatusCollection(resolver: resolver)
}
