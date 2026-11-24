// swift-tools-version: 6.0
//
//  Package.swift
//  MoviesM
//
//  Created by Muhammad Fahmi on 24/11/26.
//

import PackageDescription

let package = Package(
    name: "TMDBClient",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [.library(name: "TMDBClient", targets: ["TMDBClient"])],
    targets: [
        .target(name: "TMDBClient"),
        .testTarget(name: "TMDBClientTests", dependencies: ["TMDBClient"])
    ]
)
