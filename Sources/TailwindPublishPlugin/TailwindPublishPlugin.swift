import Files
import Foundation
import Publish
import ShellOut

extension PublishingStep {
    public static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css",
        configPath: Path = "tailwind.config.js"
    ) -> PublishingStep {
        return .step(named: "Generate Tailwind CSS", body: { context in
            let packageRoot: Folder
            do {
                packageRoot = try context.folder(at: "/")
            } catch {
                throw TailwindCSSError.couldNotDetermineProjectRoot
            }
            
            let configFile: File
            do {
                configFile = try context.file(at: configPath)
            } catch {
                throw TailwindCSSError.noConfigFile
            }
            
            let inputFile: File
            do {
                inputFile = try context.file(at: inputPath)
            } catch {
                throw TailwindCSSError.noStyles
            }
            
            let outputFile = try context.createOutputFile(at: outputPath)
            
            try shellOut(
                to: ProcessInfo.processInfo.environment["NPX_BINARY", default: "npx"],
                arguments: ["tailwindcss", "-c", configFile.path, "-i", inputFile.path, "-o", outputFile.path, "--minify"],
                at: packageRoot.path
            )
        })
    }
}

private enum TailwindCSSError: Error {
    case couldNotDetermineProjectRoot
    case noConfigFile
    case noStyles
}
