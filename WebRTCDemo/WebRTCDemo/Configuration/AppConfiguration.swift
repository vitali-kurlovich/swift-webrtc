//
//  Created by Kurlovich Vitali on 5/28/26.
//

import Configuration

final class AppConfiguration {
    let reader: ConfigReader

    init(reader: ConfigReader) {
        self.reader = reader
    }
}

extension AppConfiguration {
    convenience init() {
        let provider = InMemoryProvider(
            name: "default-config",
            values: [:],
        )

        let reader = ConfigReader(provider: provider)

        self.init(reader: reader)
    }
}

extension AppConfiguration {
    var signalingServer: String {
        reader.string(forKey: "signalingServer", default: "")
    }

    var iceServers: [String] {
        reader.stringArray(forKey: "iceServers", default: [])
    }
}
