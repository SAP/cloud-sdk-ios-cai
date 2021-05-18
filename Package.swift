// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SAPCAI",
    defaultLocalization: "en",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(
            name: "SAPCAI",
            type: .static,
            targets: ["SAPCAI"]
        ),
        .library(
            name: "SAPCAI-Dynamic",
            type: .dynamic,
            targets: ["SAPCAI"]
        )
    ],
    dependencies: [
        .package(name: "URLImage", url: "https://github.com/dmytro-anokhin/url-image", .upToNextMajor(from: "3.0.0")),
        .package(name: "Down", url: "https://github.com/johnxnguyen/Down", .upToNextMinor(from: "0.11.0")),
        .package(name: "cloud-sdk-ios", url: "https://github.com/SAP/cloud-sdk-ios", .exact("5.1.3-xcfrwk")),
    ],
    targets: [
        // TODO: split Networking vs. UI
        .target(
            name: "SAPCAI",
            dependencies: [
                "URLImage",
                "Down",
                .product(name: "SAPFoundation", package: "cloud-sdk-ios"),
                .product(name: "SAPCommon", package: "cloud-sdk-ios")
            ],
            resources: [
                .process("Foundation/Utility/Font/SAP-icons.ttf"),
                .process("UI/Common/VideoPlayer/YTPlayer.html")
            ]
        ),
        .testTarget(
            name: "SAPCAITests",
            dependencies: ["SAPCAI"],
            resources: [.copy("TestData")]
        )
    ]
)
