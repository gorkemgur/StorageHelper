// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StorageHelper",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "StorageHelper",
            targets: ["StorageHelper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.33.0")
    ],
    targets: [
        .target(
            name: "StorageHelper",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift")
            ]),
        .testTarget(
            name: "StorageHelperTests",
            dependencies: ["StorageHelper"])
    ]
)
