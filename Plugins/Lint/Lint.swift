import Foundation
import PackagePlugin

@main
struct Lint {
  let toolName = "swift-format"
}

extension Lint: CommandPlugin {
  func performCommand(context: PackagePlugin.PluginContext, arguments: [String])
    async throws
  {

    let swiftFormat = try context.tool(named: "swift-format")

    let sourcesDir = context.package.directoryURL

    let outputPipe = Pipe()

    let process = Process()
    process.executableURL = swiftFormat.url
    process.arguments = [
      "lint",
      "--strict",
      "--parallel",
      "--recursive",
      sourcesDir.path(),
    ]

    process.standardOutput = outputPipe
    process.standardError = outputPipe

    do {
      try process.run()

      let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
      process.waitUntilExit()

      if process.terminationStatus != 0 {
        displayDiagnostics(for: outputData, in: context)
      } else {
        print("Linting completed successfully")
      }
    } catch {
      Diagnostics
        .error("Error running swift-format: \(error)")
    }
  }
}

extension Lint {
  func displayDiagnostics(for data: Data, in context: PluginContext) {
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
      let lineNum = String(components[1])
      let columnNum = String(components[2])

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

      let description =
        "\(filePath):\(lineNum):\(columnNum): \(severityType): \(message)\n"

      Diagnostics
        .emit(
          severity,
          description,
          file: filePath,
          line: Int(lineNum)
        )
    }
  }
}
