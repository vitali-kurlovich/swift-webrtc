//
//  Created by Kurlovich Vitali on 6/2/26.
//

import SwiftUI
import SwiftUIComponents
import SwiftWebRTC

struct SessionDescriptionInfo: View {
    let session: SessionDescription

    var body: some View {
        TwoColumn {
            TwoColumnRow {
                Text("Type").font(.headline)
            } second: {
                Status(state: session.type)
            }

            TwoColumnRow {
                Text("SDP").font(.headline)
            } second: {
                // ScrollView {
                Text(session.sdp)
                    .textSelection(.enabled)
                    .lineLimit(5)
                    .multilineTextAlignment(strategy: .default)

                // .copyable([session.sdp])
                // }
            }
        }
    }
}
