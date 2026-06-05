//
//  Created by Kurlovich Vitali on 5/29/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

extension IceConnectionState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .new:
            "New"
        case .checking:
            "Checking"
        case .connected:
            "Connected"
        case .completed:
            "Completed"
        case .failed:
            "Failed"
        case .disconnected:
            "Disconnected"
        case .closed:
            "Closed"
        case .count:
            "Count"
        }
    }
}

struct IceConnectionStateColorResolver: StatusIndicatorColorResolver {
    func resolveColor(for state: IceConnectionState) -> Color {
        switch state {
        case .new:
            Color.orange
        case .checking:
            Color.yellow
        case .connected:
            Color.green
        case .completed:
            Color.green
        case .failed:
            Color.red
        case .disconnected:
            Color.secondary
        case .closed:
            Color.secondary
        case .count:
            Color.secondary
        }
    }
}

#Preview {
    let resolver = IceConnectionStateColorResolver()
    PreviewStatusCollection(resolver: resolver)
}
