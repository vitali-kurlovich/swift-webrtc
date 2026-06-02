//
//  Created by Kurlovich Vitali on 6/2/26.
//

import Foundation
import Logging

public final class LogEventsReporterHandler: LogHandler, @unchecked Sendable {
    public var metadata: Logger.Metadata = [:]
    public var metadataProvider: Logger.MetadataProvider?
    public var logLevel: Logger.Level = .info

    public init(
        metadata: Logger.Metadata = [:],
        metadataProvider: Logger.MetadataProvider? = nil,
        logLevel: Logger.Level = .info,
    ) {
        self.metadata = metadata
        self.metadataProvider = metadataProvider
        self.logLevel = logLevel
    }

    public func log(event: LogEvent) {
        continuation?.yield(event)
    }

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get {
            metadata[key]
        }
        set {
            metadata[key] = newValue
        }
    }

    public private(set) lazy var events: AsyncStream<LogEvent> = AsyncStream { (continuation: AsyncStream<LogEvent>.Continuation) in
        self.continuation = continuation
    }

    private var continuation: AsyncStream<LogEvent>.Continuation?
}
