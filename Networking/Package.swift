// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Networking",
    products: [
        .library(
            name: "Networking",
            targets: [
                "Networking"
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Networking",
            dependencies: []
        )
    ]
)
