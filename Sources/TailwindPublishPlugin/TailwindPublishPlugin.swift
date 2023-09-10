import Files
import Foundation
import Publish
import ShellOut

extension PublishingStep {
    public static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css",
        configPath: Path = "tailwind.config.js",
        packagePath: Path = "package.json"
    ) -> PublishingStep {
        return .step(named: "Generate Tailwind CSS", body: { context in
            let npmPackageRootPath = try verifyNPMPackage(at: packagePath, context: context)
        
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
                at: npmPackageRootPath
            )
        })
    }
}

private func verifyNPMPackage<Site>(at packagePath: Path, context: PublishingContext<Site>) throws -> String where Site: Website {
    let packageFile: File
    let package: NPMPackage
    do {
        packageFile = try context.file(at: packagePath)
        let packageJSONData = try packageFile.read()
        
        // If we can't parse the package.json, don't let that block trying to build. We can try executing the tailwind
        // CLI tool and if that fails, then that should fail the whole build.
        guard let decodedPackage = try? JSONDecoder().decode(NPMPackage.self, from: packageJSONData) else {
            return packageFile.parent!.path
        }
        
        package = decodedPackage
    } catch {
        throw TailwindCSSError.noNPMPackage
    }
    
    guard package.isDependencyInstalled("tailwindcss") else {
        throw TailwindCSSError.tailwindNotInstalled
    }
    
    return packageFile.parent!.path
}

private struct NPMPackage: Decodable {
    let dependencies: [String: String]
    let devDependencies: [String: String]
    
    func isDependencyInstalled(_ dependency: String) -> Bool {
        return dependencies.keys.contains(dependency)
            || devDependencies.keys.contains(dependency)
    }
}

private enum TailwindCSSError: Error {
    case noNPMPackage
    case tailwindNotInstalled
    case noConfigFile
    case noStyles
    
    var localizedDescription: String {
        switch self {
        case .noNPMPackage:
            return "Could not find your package.json file."
        case .tailwindNotInstalled:
            return "Tailwind is not installed in your NPM package."
        case .noConfigFile:
            return "Could not find your Tailwind config file."
        case .noStyles:
            return "Could not find your base styles."
        }
    }
}
