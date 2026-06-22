// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "simple-apple-app",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(path: "../simple-library")
    ],
    targets: [
        .executableTarget(
            name: "SimpleApp",
            dependencies: [
                .product(name: "SimpleLibrary", package: "simple-library")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
