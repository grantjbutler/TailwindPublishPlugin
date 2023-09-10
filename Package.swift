// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "TailwindPublishPlugin",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "TailwindPublishPlugin",
            targets: ["TailwindPublishPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/Publish.git", from: "0.1.0"),
        .package(url: "https://github.com/johnsundell/Files.git", from: "4.0.0"),
        .package(url: "https://github.com/johnsundell/ShellOut.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "TailwindPublishPlugin",
            dependencies: [
                .product(name: "Publish", package: "Publish"),
                .product(name: "Files", package: "Files"),
                .product(name: "ShellOut", package: "ShellOut"),
            ]
        ),
        .testTarget(
            name: "TailwindPublishPluginTests",
            dependencies: ["TailwindPublishPlugin"]
        ),
    ]
)
