import Foundation
import PackagePlugin

@main
struct LintTarget {
  func lint(tool: PluginContext.Tool, targetDirectories: [String], configurationFilePath: String?) throws {
    let swiftFormatExec = tool.url

    var arguments: [String] = ["lint"]

    arguments.append(contentsOf: targetDirectories)
    arguments.append(contentsOf: ["--recursive", "--parallel", "--strict"])
    
    if let configurationFilePath = configurationFilePath {
      arguments.append(contentsOf: ["--configuration", configurationFilePath])
    }

    let process = try Process.run(swiftFormatExec, arguments: arguments)
    process.waitUntilExit()

    if process.terminationReason == .exit && process.terminationStatus == 0 {
      print("Linted the source code.")
    } else {
      let problem = "\(process.terminationReason):\(process.terminationStatus)"
      Diagnostics.error("swift-format invocation failed: \(problem)")
    }
  }
}

extension LintTarget: CommandPlugin {
  func performCommand(
    context: PluginContext,
    arguments: [String]
  ) async throws {
    let swiftFormatTool = try context.tool(named: "swift-format")

    var argExtractor = ArgumentExtractor(arguments)
    let targetNames = argExtractor.extractOption(named: "target")

    let targetsToFormat =
      targetNames.isEmpty ? context.package.targets : try context.package.targets(named: targetNames)
    let configurationFilePath = argExtractor.extractOption(named: "swift-format-configuration").first

    let sourceCodeTargets = targetsToFormat.compactMap { $0 as? SourceModuleTarget }

    try lint(
      tool: swiftFormatTool,
      targetDirectories: sourceCodeTargets.map(\.directoryURL.path),
      configurationFilePath: configurationFilePath
    )
  }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension LintTarget: XcodeCommandPlugin {
  func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {
    let swiftFormatTool = try context.tool(named: "swift-format")
    var argExtractor = ArgumentExtractor(arguments)
    let configurationFilePath = argExtractor.extractOption(named: "swift-format-configuration").first

    try lint(
      tool: swiftFormatTool,
      targetDirectories: [context.xcodeProject.directoryURL.path],
      configurationFilePath: configurationFilePath
    )
  }
}
#endif
