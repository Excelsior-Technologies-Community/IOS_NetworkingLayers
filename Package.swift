// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NetworkingLayer",
    platforms: [
        .iOS(.v14),        // you may adjust minimum iOS version
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "NetworkingLayer",
            targets: ["NetworkingLayer"]
        )
    ],
    targets: [
        .target(
            name: "NetworkingLayer",
            path: "Sources/NetworkingLayer"
        )
    ]
)
