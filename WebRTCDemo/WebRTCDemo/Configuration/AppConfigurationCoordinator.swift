//
//  AppConfigurationCoordinator.swift
//  WebRTCDemo
//
//  Created by Kurlovich Vitali on 5/28/26.
//

internal import SystemPackage
import Configuration
import Foundation
import Logging

enum AppConfigurationError: Swift.Error {
    case fileDoNotExists
    case fileProviderFaild
}

private let logger: Logger = .init(label: "AppConfiguration")

final class AppConfigurationCoordinator {
    let settingsName: String

    init(_ settingsName: String = "settings.json") {
        self.settingsName = settingsName
    }

    private lazy var readerTask: Task<ConfigReader, any Error> = Task {
        try await configReader()
    }

    var reader: ConfigReader {
        get async throws {
            // Awaiting a task multiple times returns the same cached result
            try await readerTask.value
        }
    }
}

private extension AppConfigurationCoordinator {
    func configReader() async throws(Error) -> ConfigReader {
        let url = Bundle.main.url(forResource: settingsName, withExtension: nil)

        guard let filePath = url?.relativePath else {
            throw AppConfigurationError.fileDoNotExists
        }

        do {
            let path = FilePath(filePath)
            return try await ConfigReader(
                provider: FileProvider<JSONSnapshot>(filePath: path),
                accessReporter: AccessLogger(logger: logger),
            )
        } catch {
            throw AppConfigurationError.fileProviderFaild
        }
    }
}
