import Foundation
import PackagePlugin

@main
struct Format: CommandPlugin {
  func performCommand(context: PluginContext, arguments: [String]) async throws
  {
    let swiftFormat = try context.tool(named: "swift-format")

    let sourcesDir = context.package.directoryURL

    print("Formatting \(sourcesDir.path())...")
    let process = Process()
    process.executableURL = swiftFormat.url
    process.arguments = [
      "format",
      "--in-place",
      "--parallel",
      "--recursive",
      sourcesDir.path()
    ]

    do {
      try process.run()
      process.waitUntilExit()
      if process.terminationStatus != 0 {
        Diagnostics.error("Failed to format")
      }
    } catch {
      Diagnostics
        .error("Error running swift-format: \(error)")
    }

    print("Code formatting complete!")
  }
}
