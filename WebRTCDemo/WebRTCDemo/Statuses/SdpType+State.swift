//
//  Created by Kurlovich Vitali on 6/1/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

extension SdpType: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .offer:
            "Offer"
        case .prAnswer:
            "PrAnswer"
        case .answer:
            "Answer"
        case .rollback:
            "Rollback"
        }
    }
}

struct SdpTypeStateColorResolver: StatusIndicatorColorResolver {
    func resolveColor(for state: SdpType) -> Color {
        switch state {
        case .offer:
            .indigo
        case .prAnswer:
            .blue
        case .answer:
            .green
        case .rollback:
            .orange
        }
    }
}

#Preview {
    let resolver = SdpTypeStateColorResolver()
    ScrollView(.horizontal) {
        PreviewStatusCollection(resolver: resolver)
    }
}
