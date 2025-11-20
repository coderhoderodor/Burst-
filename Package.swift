// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BalloonShooter",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BalloonShooter",
            targets: ["BalloonShooter"]),
    ],
    targets: [
        .target(
            name: "BalloonShooter",
            dependencies: [],
            path: "BalloonShooter",
            exclude: [
                "Info.plist" // Info.plist is usually handled by the project generator or app target settings, but we exclude it from sources to avoid confusion if it's not a resource.
            ],
            resources: [
                .process("Assets.xcassets"),
                .process("Base.lproj")
            ]
        )
    ]
)
