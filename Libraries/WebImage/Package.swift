// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebImage",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WebImage",
            targets: ["WebImage"]),
    ],
    dependencies: [
        .package(path: "../Network"),
        .package(path: "../Storage")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WebImage",
            dependencies: ["Network",
                           "Storage"
                          ]),
        .testTarget(
            name: "WebImageTests",
            dependencies: ["WebImage"],
            resources: [.copy("Resources/testImage.png")]
        ),
    ]
)
