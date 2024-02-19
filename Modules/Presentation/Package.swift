// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
    ],
    dependencies: [
        .package(name: "Commons", path: "../Commons"),
        .package(name: "AppCore", path: "../AppCore"),
        .package(
          url: "https://github.com/apple/swift-collections.git",
          exact: "1.1.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Presentation",
            dependencies: [
                .product(name: "Commons", package: "Commons"),
                .product(name: "AppCore", package: "AppCore"),
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]),
    ]
)
