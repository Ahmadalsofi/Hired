// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "Hired",
  platforms: [.iOS(.v13), .macOS(.v10_14)],
  products: [
    .library(name: "Hired", targets: ["Hired"])
  ],
  dependencies: [],
  targets: [
    .target(name: "Hired",
            resources: [
                .process("Resources/Content.json")
            ]),
    .testTarget(
      name: "HiredTests", 
      dependencies: ["Hired"]
    )
  ]
)

