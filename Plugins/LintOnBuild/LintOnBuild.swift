import Foundation
import PackagePlugin

@main
struct LintOnBuild {
  let toolName = "swift-format"
}

extension LintOnBuild: BuildToolPlugin {
  func createBuildCommands(context: PluginContext, target: Target) async throws
    -> [Command]
  {
    let tool = try context.tool(named: toolName)
    let packagePath = context.package.directoryURL.path

    return [
      createCommand(in: packagePath, using: tool)
    ]
  }
}

#if canImport(XcodeProjectPlugin)
  import XcodeProjectPlugin

  extension LintOnBuild: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget)
      throws -> [Command]
    {
      let tool = try context.tool(named: toolName)
      let packagePath = context.xcodeProject.directoryURL.path()

      return [
        createCommand(in: packagePath, using: tool)
      ]
    }
  }
#endif

extension LintOnBuild {
  func createCommand(
    in directoryPath: String,
    using tool: PluginContext.Tool
  ) -> Command {
    .buildCommand(
      displayName: "Swift Format Lint",
      executable: tool.url,
      arguments: ["lint", "--parallel", "--recursive", directoryPath],
      inputFiles: [],
      outputFiles: []
    )
  }
}
