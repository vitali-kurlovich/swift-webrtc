//
//  Created by Kurlovich Vitali on 6/2/26.
//

import Combine
import InMemoryLogging

final class LogsObserver: ObservableObject {
    typealias Entry = InMemoryLogHandler.Entry

    let objectWillChange = ObservableObjectPublisher()

    let bootstrap: LoggingBootstrap

    var cancellable: Task<Void, Never>?

    init(bootstrap: LoggingBootstrap = .default) {
        self.bootstrap = bootstrap

        cancellable = Task { [weak self] in
            for await _ in bootstrap.events {
                self?.invalidate()
            }
        }
    }

    var entries: [Entry] {
        bootstrap.inMemoryHandler.entries
    }

    nonisolated func invalidate() {
        Task { @MainActor in
            objectWillChange.send()
        }
    }
}
