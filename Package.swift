// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cross-platform-swift",
    platforms: [
        .iOS(.v17),
        .macOS(.v13),
        .tvOS(.v17),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "cross-platform-swift",
            targets: [
                "CInterop",
                "SimpleABI",
                "SubjectStreams"
            ]
        )
    ],
    targets: [
        .target(
            name: "SimpleABI"
        ),
        .executableTarget(
            name: "SimpleABIConsumer_C",
            dependencies: ["SimpleABI"]
        ),
        .target(
            name: "CInterop"
        ),
        .target(
            name: "SubjectStreams"
        ),
        .testTarget(
            name: "CInteropTests",
            dependencies: ["CInterop"]
        ),
        .testTarget(
            name: "SubjectStreamsTests",
            dependencies: ["SubjectStreams"]
        )
    ]
)
