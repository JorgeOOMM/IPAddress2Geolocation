// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IPAddress2Geolocation",
    platforms: [.iOS(.v14), .macOS(.v13), .watchOS(.v5), .tvOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "IPAddress2Geolocation",
            targets: ["IPAddress2Geolocation"]),
        .executable(
            name: "Converter",
            targets: ["Converter"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.3.0")
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
                .upToNextMajor(from: "1.3.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "IPAddress2Geolocation",
            resources: [
                .copy("IPCOUNTRY.bin"),
                .copy("SUBDIVS.bin")
            ]
        ),
        .executableTarget(
            name: "Converter",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "IPAddress2Geolocation",
            ],
            exclude: ["IP-COUNTRY.7z"]
        ),
        .testTarget(
            name: "IPAddress2GeolocationTests",
            dependencies: [
                "IPAddress2Geolocation",
            ]
        ),
    ]
)
