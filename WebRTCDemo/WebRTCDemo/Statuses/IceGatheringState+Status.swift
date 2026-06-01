//
//  Created by Kurlovich Vitali on 5/29/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

extension IceGatheringState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .new:
            "New"
        case .gathering:
            "Gathering"
        case .complete:
            "Complete"
        case .unknown:
            "Uncknown"
        }
    }
}

struct IceGatheringStateColorResolver: StatusIndicatorColorResolver {
    func resolveColor(for state: IceGatheringState) -> Color {
        switch state {
        case .new:
            Color.secondary
        case .gathering:
            Color.orange
        case .complete:
            Color.accentColor
        case .unknown:
            Color.secondary
        }
    }
}

#Preview {
    let resolver = IceGatheringStateColorResolver()
    PreviewStatusCollection(resolver: resolver)
}
