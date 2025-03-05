// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftFormatPlugin",
  products: [
    .plugin(name: "LintOnBuild", targets: ["LintOnBuild"]),
    .plugin(name: "Lint", targets: ["Lint"]),
    .plugin(name: "Format", targets: ["Format"]),
  ],
  targets: [
    .plugin(name: "LintOnBuild", capability: .buildTool()),
    .plugin(
      name: "Format",
      capability: .command(
        intent: .sourceCodeFormatting(),
        permissions: [
          .writeToPackageDirectory(
            reason: "Needs to overwrite source files with formatted versions"
          )
        ]
      )
    ),
    .plugin(
      name: "Lint",
      capability: .command(
        intent: .custom(verb: "lint-source-code", description: "Lint source code"),
      )
    ),
  ]
)
