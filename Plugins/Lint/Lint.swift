import Foundation
import PackagePlugin

@main
struct Lint {
  let toolName = "swift-format"

  func lint(for directoryURL: URL, using tool: PluginContext.Tool) throws {
    let swiftFormatURL = tool.url

    let arguments = [
      "lint", "--recursive", "--parallel", "--strict", directoryURL.path(),
    ]

    let outputPipe = Pipe()

    let process = Process()
    process.executableURL = swiftFormatURL
    process.arguments = arguments
    process.standardOutput = outputPipe
    process.standardError = outputPipe

    do {
      try process.run()

      let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
      process.waitUntilExit()

      if process.terminationStatus != 0 {
        showDiagnostics(for: outputData, in: directoryURL)
      } else {
        print("Linting completed successfully.")
      }
    } catch {
      Diagnostics
        .error("Error running swift-format: \(error)")
    }
  }

  func showDiagnostics(for data: Data, in directoryURL: URL) {
    guard let output = String(data: data, encoding: .utf8) else {
      Diagnostics.error("Failed to decode swift-format output")
      return
    }

    let lines = output.components(separatedBy: .newlines)

    for line in lines {
      guard !line.trimmingCharacters(in: .whitespaces).isEmpty else { continue }
      let components = line.split(separator: ":")
      guard components.count >= 4 else {
        Diagnostics.error(line)
        continue
      }

      let filePath = String(components[0])
      let relativePath = filePath.replacingOccurrences(
        of: directoryURL.path(),
        with: ""
      )

      let line = Int(String(components[1]))
      // let columnNum = Int(String(components[2]))
      // let file = directoryURL.appending(path: relativePath).path()

      let severityType = String(components[3]).trimmingCharacters(
        in: .whitespaces
      )

      let message = String(
        (components[4...]).map {
          $0.trimmingCharacters(in: .whitespaces)
        }.joined(separator: ":")
      )

      guard let severity: Diagnostics.Severity = .init(rawValue: severityType)
      else {
        continue
      }

      let description = "\(message) in \(relativePath)\n"

      Diagnostics
        .emit(
          severity,
          description,
          file: relativePath,
          line: line
        )
    }
  }
}

extension Lint: CommandPlugin {
  func performCommand(
    context: PluginContext,
    arguments: [String]
  ) async throws {
    let swiftFormatTool = try context.tool(named: toolName)
    let sourcesDirectoryURL = context.package.directoryURL
    try lint(for: sourcesDirectoryURL, using: swiftFormatTool)
  }
}
