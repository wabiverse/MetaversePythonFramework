// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "MetaversePythonFramework",
  products: [
    .library(
      name: "Python",
      targets: ["PyBundle", "Python"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pvieito/PythonKit.git", from: "0.4.1"),
  ],
  targets: [
    .target(
      name: "PyBundle",
      dependencies: [
        "PythonKit",
        .target(name: "Python")
      ],
      resources: [
        .copy("Resources"),
      ],
      swiftSettings: [
        .interoperabilityMode(.C)
      ]
    ),
    .binaryTarget(
      name: "Python",
      path: "Frameworks/3.11/Python.xcframework"
    ),
    .testTarget(
      name: "PyBundleTests",
      dependencies: ["PyBundle"]
    ),
  ]
)
