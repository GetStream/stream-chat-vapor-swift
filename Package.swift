// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "StreamChatVapor",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .library(name: "StreamSDKVapor", targets: ["StreamSDKVapor"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor-community/Imperial.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "ExampleApp",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt"),
                "StreamSDKVapor",
                .product(name: "ImperialGoogle", package: "Imperial"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .testTarget(name: "ExampleAppTests", dependencies: [
            .target(name: "ExampleApp"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
        .target(
            name: "StreamSDKVapor",
            dependencies: [
                .product(name: "JWT", package: "jwt"),
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
    ]
)
