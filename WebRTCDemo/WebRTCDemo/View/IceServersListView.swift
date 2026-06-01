//
//  Created by Kurlovich Vitali on 5/28/26.
//

import SwiftUI

struct IceServersListView: View {
    @Environment(\.appConfiguration)
    var appConfiguration

    var body: some View {
        ForEach(appConfiguration.iceServers, id: \.self) { item in
            Text(item)
        }
    }
}

#Preview {
    AppConfigurationLoader {
        IceServersListView()
    }
}
