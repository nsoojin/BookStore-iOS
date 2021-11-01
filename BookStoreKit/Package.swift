// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "BookStoreKit",
    products: [
        .library(
            name: "BookStoreKit",
            targets: [
                "BookStoreKit"
            ]
        ),
    ],
    dependencies: [
        .package(
            name: "Networking",
            path: "../Networking"
        )
    ],
    targets: [
        .target(
            name: "BookStoreKit",
            dependencies: [
                "Networking"
            ]
        ),
        .testTarget(
            name: "BookStoreKitTests",
            dependencies: [
                "BookStoreKit"
            ]
        ),
    ]
)
