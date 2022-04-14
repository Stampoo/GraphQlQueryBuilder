// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

import PackageDescription

let package = Package(
    name: "GraphQlQueryBuilder",
    products: [
        .library(name: "GraphQlQueryBuilder", targets: ["GraphQlQueryBuilder"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "GraphQlQueryBuilder", dependencies: []),
        .testTarget(name: "GraphQlQueryBuilderTests", dependencies: ["GraphQlQueryBuilder"]),
    ]
)

