// swift-tools-version:6.3

import PackageDescription

let package = Package(
    name: "swift-webrtc",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "SwiftWebRTC", targets: ["SwiftWebRTC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vitali-kurlovich/webrtc.git", from: "0.148.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.13.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftWebRTC",
            dependencies: [
                .product(name: "WebRTC", package: "webrtc"),
                .product(name: "Logging", package: "swift-log"),
            ],
        ),
    ],
)
