//
//  Created by Kurlovich Vitali on 6/2/26.
//

import Foundation
import Logging

public struct ObservationLogHandler: LogHandler {
    private let notificationCenter: NotificationCenter

    public var metadata: Logger.Metadata = [:]
    public var metadataProvider: Logger.MetadataProvider?
    public var logLevel: Logger.Level = .info

    public init(
        metadata: Logger.Metadata = [:],
        metadataProvider: Logger.MetadataProvider? = nil,
        logLevel: Logger.Level = .info,
    ) {
        notificationCenter = NotificationCenter()
        self.metadata = metadata
        self.metadataProvider = metadataProvider
        self.logLevel = logLevel
    }

    public func log(event: LogEvent) {
        let notification = Notification(name: .reciveLogEvent, object: self, userInfo: [Self.eventKey: event])
        notificationCenter.post(notification)
    }

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get {
            metadata[key]
        }
        set {
            metadata[key] = newValue
        }
    }
}

public extension ObservationLogHandler {
    func events() -> some AsyncSequence<LogEvent, Never> {
        notificationCenter.notifications(named: .reciveLogEvent).compactMap { notification in
            if let event = notification.userInfo?[Self.eventKey] as? LogEvent {
                return event
            }
            return nil
        }
    }
}

private extension Notification.Name {
    nonisolated static var reciveLogEvent: Self {
        Notification.Name("Logging.reciveLogEvent")
    }
}

private extension ObservationLogHandler {
    nonisolated static var eventKey: String {
        "event"
    }
}
