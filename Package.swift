// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Caf",
  products: [
    .library(
      name: "Caf",
      targets: ["Caf"]),
  ],
  dependencies: [
    .package(url: "https://github.com/kojirou1994/Kwift.git", from: "0.8.0"),
  ],
  targets: [
    .target(
      name: "Caf",
      dependencies: [
        .product(name: "KwiftUtility", package: "Kwift")
      ]),
    .testTarget(
      name: "CafTests",
      dependencies: ["Caf"]),
  ]
)
