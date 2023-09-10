import Files
import Foundation
import Publish
import ShellOut

extension PublishingStep {
    public static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css"
    ) -> PublishingStep {
        return .step(named: "Generate Tailwind CSS", body: { context in
            let packageRoot: Folder
            do {
                packageRoot = try context.file(at: "tailwind.config.js").parent!
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
                arguments: ["tailwindcss", "-i", inputFile.path, "-o", outputFile.path, "--minify"],
                at: packageRoot.path
            )
        })
    }
}

private enum TailwindCSSError: LocalizedError {
    case noConfigFile
    case noStyles
}
