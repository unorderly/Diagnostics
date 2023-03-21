// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Diagnostics",
                      platforms: [
                        .macOS(.v12),
                        .iOS(.v13),
                        .tvOS(.v13),
                        .watchOS(.v8)],
                      products: [
                        .library(name: "Diagnostics", targets: ["Diagnostics"])
                        ],
                      dependencies: [
                        .package(url: "https://github.com/sindresorhus/ExceptionCatcher", from: "2.0.0")
                      ],
                      targets: [
                        .target(
                            name: "Diagnostics",
                            dependencies: ["ExceptionCatcher"],
                            path: "Sources",
                            resources: [
                                .process("style.css"),
                                .process("functions.js")
                            ]),
                        .testTarget(name: "DiagnosticsTests", dependencies: ["Diagnostics"], path: "DiagnosticsTests")
                        ],
                      swiftLanguageVersions: [.v5])
