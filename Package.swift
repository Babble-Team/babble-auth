// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuthSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AuthSDK",
            targets: ["AuthSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.10.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "6.0.2")
    ],
    targets: [
        .target(
            name: "AuthSDK",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "AuthSDKTests",
            dependencies: ["AuthSDK"],
            path: "Tests"
        ),
    ]
)
