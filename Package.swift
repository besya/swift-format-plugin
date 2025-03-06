// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-format-plugin",
  products: [
    .plugin(name: "LintOnBuild", targets: ["Lint On Build"]),
    .plugin(name: "LintProject", targets: ["Lint Project"]),
    .plugin(name: "LintTarget", targets: ["Lint Targets Source Code"]),
    .plugin(name: "FormatProject", targets: ["Format Project"]),
    .plugin(name: "FormatTarget", targets: ["Format Targets Source Code"]),
  ],
  targets: [
    .plugin(
      name: "Lint On Build",
      capability: .buildTool(),
      path: "Plugins/LintOnBuild"
    ),
    .plugin(
      name: "Lint Project",
      capability: .command(
        intent: .custom(verb: "lint", description: "Lint source code"),
      ),
      path: "Plugins/LintProject"
    ),
    .plugin(
      name: "Lint Targets Source Code",
      capability: .command(
        intent: .custom(
          verb: "lint-target",
          description: "Lint source code for a specified target."
        )
      ),
      path: "Plugins/LintTarget"
    ),
    .plugin(
      name: "Format Project",
      capability: .command(
        intent: .custom(verb: "format", description: "Format source code"),
        permissions: [
          .writeToPackageDirectory(
            reason: "Needs to overwrite source files with formatted versions"
          )
        ]
      ),
      path: "Plugins/FormatProject"
    ),
    .plugin(
      name: "Format Targets Source Code",
      capability: .command(
        intent: .custom(
          verb: "format-target",
          description: "Format source code for a specified target."
        ),
        permissions: [
          .writeToPackageDirectory(
            reason: "This command formats the Swift source files"
          )
        ]
      ),
      path: "Plugins/FormatTarget"
    ),
  ]
)
