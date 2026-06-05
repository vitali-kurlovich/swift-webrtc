//
//  Created by Kurlovich Vitali on 5/29/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

extension SignalingState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .stable:
            "Stable"
        case .haveLocalOffer:
            "Have Local Offer"
        case .haveLocalPrAnswer:
            "Have Local Pr Answer"
        case .haveRemoteOffer:
            "Have Remote Offer"
        case .haveRemotePrAnswer:
            "Have Remote Pr Answer"
        case .closed:
            "Closed"
        }
    }
}

struct SignalingStateColorResolver: StatusIndicatorColorResolver {
    func resolveColor(for state: SignalingState) -> Color {
        switch state {
        case .stable:
            Color.green
        case .haveLocalOffer:
            Color.yellow
        case .haveLocalPrAnswer:
            Color.yellow
        case .haveRemoteOffer:
            Color.orange
        case .haveRemotePrAnswer:
            Color.orange
        case .closed:
            Color.secondary
        }
    }
}

#Preview {
    let resolver = SignalingStateColorResolver()
    PreviewStatusCollection(resolver: resolver)
}
