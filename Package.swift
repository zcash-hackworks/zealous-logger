// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "zealous-logger",
    platforms: [.macOS(.v10_12),
                .iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "zealous-logger",
            targets: ["zealous-logger"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "zealous-logger",
            dependencies: [.product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")]),
        .testTarget(
            name: "zealous-loggerTests",
            dependencies: ["zealous-logger",
                           .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")]),
    ]
)
