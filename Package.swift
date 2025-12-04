// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IOSNetworkingLayers",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // This is the library other projects will import.
        .library(
            name: "IOSNetworkingLayers",
            targets: ["IOSNetworkingLayers"]
        )
    ],
    targets: [
        // Target that contains your reusable networking layer code.
        .target(
            name: "IOSNetworkingLayers",
            // Your Swift files live under the "Networking Layer" folder.
            path: "Networking Layer",
            // Only include the core networking files in the package target.
            sources: [
                "APIService.swift .swift",
                "Interceptors.swift",
                "DummyResponse.swift"
            ],
            resources: [
                // No resources for now.
            ]
        )
    ]
)


