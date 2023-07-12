// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScrapWKWebView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ScrapWKWebView",
            targets: ["ScrapWKWebView"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ScrapWKWebView",
            dependencies: []),
        .testTarget(
            name: "ScrapWKWebViewTests",
            dependencies: ["ScrapWKWebView"]),
    ]
)
