//
//  Created by Kurlovich Vitali on 6/1/26.
//

import Logging
import Observation

@Observable
final class InMemoryLogEventsStorage {
    @MainActor
    private(set) var events: [LogEvent] = []

    @MainActor func append(event: LogEvent) {
        events.append(event)
    }
}
