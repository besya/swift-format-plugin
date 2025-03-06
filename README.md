[![Status](https://img.shields.io/badge/status-WIP-red)](https://github.com/besya/ansi)

# SwiftFormatPlugin
**NOTICE: This library is under active development and is not ready for use in production or any other environment. Use at your own risk.**

Current version: 0.0.5 (unstable, experimental)

This package uses Xcode's built-in `swift-format` tool for lint or format code.

## Features
- ✨ Commands
  - Format Project
  - Format Target
  - Lint Project
  - Lint Target
- 🚀 Lint On Build: Diagnostics on build

## Usage


### As Commands Plugin

**Known issues** 
 - Command from context menu in Xcode does not diagnostics in the Issue navigator. Solution: Check the Report navigator
 - Diagnostics in Xcode's "Report navigator -> Plug-in" are not clickable

```swift
let package = Package(
  // name, platforms, products, etc.
  dependencies: [
    // other dependencies
    .package(url: "https://github.com/besya/swift-format-plugin.git", from: "0.0.5"),
  ],
)
```

#### In terminal
```
> swift package plugin --list
‘format’ (plugin ‘Format Project’ in package ‘swift-format-plugin’)
‘format-target’ (plugin ‘Format Targets Source Code’ in package ‘swift-format-plugin’)
‘lint’ (plugin ‘Lint Project’ in package ‘swift-format-plugin’)
‘lint-target’ (plugin ‘Lint Targets Source Code’ in package ‘swift-format-plugin’)

> swift package plugin lint
> swift package plugin format
```

#### In Xcode
Right-click on package:
 - Format Project
 - Format Target
 - Lint Project
 - Lint Target

### Lint on Build Tool

Show diagnistics warning when building project
This feature works using `swift build` or Xcode

**Known issues** 
 - Diagnostics won't update on second build. Solution: "Product -> Clean Build Folder..." in Xcode or `swift package clean` in terminal

```swift
let package = Package(
  // name, platforms, products, etc.
  dependencies: [
    // other dependencies
    .package(url: "https://github.com/besya/swift-format-plugin.git", from: "0.0.5"),
  ],
  targets: [
    .target(
      name: "<library>",
      plugins: [
        .plugin(name: "LintOnBuild", package: "swift-format-plugin")
      ]      
    ),
    // other targets
  ]
)
```

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Contributing
This project is still in early development. Contributions or suggestions are welcome, but please do not use this library in any projects yet.
