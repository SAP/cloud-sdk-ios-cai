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
            targets: ["SAPCAI-withBinaryDependencies"]
        ),
        .library(
            name: "SAPCAI-requiresToEmbedXCFrameworks",
            targets: ["SAPCAI-withoutBinaryDependencies"]
        )
    ],
    dependencies: [
        .package(name: "SDWebImage", url: "https://github.com/SDWebImage/SDWebImage", .upToNextMinor(from: "5.11.0")),
        .package(name: "Down", url: "https://github.com/johnxnguyen/Down", .upToNextMinor(from: "0.11.0")),
        .package(name: "cloud-sdk-ios", url: "https://github.com/SAP/cloud-sdk-ios", .exact("5.1.3-xcfrwk"))
    ],
    targets: [
        // TODO: split Networking vs. UI
        .target(
            name: "SAPCAI-withBinaryDependencies",
            dependencies: [
                "SAPCAI",
                .product(name: "SAPFoundation", package: "cloud-sdk-ios"),
                .product(name: "SAPCommon", package: "cloud-sdk-ios")
            ]
        ),
        .target(
            name: "SAPCAI",
            dependencies: [
                "SDWebImage",
                "Down"
            ],
            resources: [
                .process("Foundation/Utility/Font/SAP-icons.ttf"),
                .process("UI/Common/VideoPlayer/YTPlayer.html")
            ]
        ),
        .target(
            name: "SAPCAI-withoutBinaryDependencies",
            dependencies: [
                "SAPCAI"
            ],
            linkerSettings: [
                .linkedFramework("SAPCommon"),
                .linkedFramework("SAPFoundation")
            ]
        ),
        .testTarget(
            name: "SAPCAITests",
            dependencies: ["SAPCAI"],
            resources: [.copy("TestData")]
        )
    ]
)
