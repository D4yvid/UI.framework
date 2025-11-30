// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreUI",

    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]
        )
    ],

    dependencies: [
        .package(
            url: "https://github.com/apple/swift-atomics.git",
            .upToNextMajor(from: "1.2.0")  // or `.upToNextMinor
        )
    ],

    targets: [
        .executableTarget(
            name: "SampleTUI",

            dependencies: [
                .byName(name: "TerminalUI"),
                .product(name: "Atomics", package: "swift-atomics"),
            ]
        ),

        // A terminal renderer and widgets for CoreUI. Used as a reference implementation for other renderers
        .target(
            name: "TerminalUI",

            dependencies: [
                .byName(name: "CoreUI")
            ]
        ),

        .testTarget(name: "TerminalUITests", dependencies: [.byName(name: "TerminalUI")]),

        // The Core UI library defines what's the basic building blocks for all other implementations
        .target(name: "CoreUI"),

        .testTarget(name: "CoreUITests", dependencies: [.byName(name: "CoreUI")]),
    ]
)
