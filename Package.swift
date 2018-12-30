// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftGoogleTranslate",
    products: [
        .library(
            name: "SwiftGoogleTranslate",
            targets: ["SwiftGoogleTranslate"]),
    ],
    targets: [
        .target(
            name: "SwiftGoogleTranslate",
            path: "SwiftGoogleTranslate/Sources"),
    ]
)
