[![Status](https://img.shields.io/badge/status-WIP-red)](https://github.com/besya/ansi)

# SwiftFormatPlugin
**NOTICE: This library is under active development and is not ready for use in production or any other environment. Use at your own risk.**

Current version: 0.0.4 (unstable, experimental)

This package uses Xcode's built-in `swift-format` tool for lint or format code.

## Features
- ✨ Format and Lint commands
- 🚀 Lint diagnostics on build

## Usage

### As Commands Plugin

```swift
let package = Package(
  // name, platforms, products, etc.
  dependencies: [
    // other dependencies
    .package(url: "https://github.com/besya/swift-format-plugin.git", from: "0.0.4"),
  ],
)
```

#### In terminal
```
> swift package plugin lint-source-code
> swift package plugin format-source-code
```

#### In Xcode
Right-click on package and select Format or Lint

### Lint on Build Tool

```swift
let package = Package(
  // name, platforms, products, etc.
  dependencies: [
    // other dependencies
    .package(url: "https://github.com/besya/swift-format-plugin.git", from: "0.0.4"),
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
