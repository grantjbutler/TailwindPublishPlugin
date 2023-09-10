# TailwindPublishPlugin

A [Publish](https://github.com/johnsundell/publish) that integrates [Tailwind](https://tailwindcss.com) into the website generation pipeline.

## Installation

To install the plugin, add it as a dependency in your package manifest:

```swift
let package = Package(
    // ...
    dependencies: [
        // ...
        .package(url: "https://github.com/grantjbutler/TailwindPublishPlugin.git", from: "0.1.0")
    ],
    targets: [
        .target(
            // ...
            dependencies: [
                // ...
                "TailwindPublishPlugin"
            ]
        )
    ]
    // ...
)
```

Then import the package where it should be used:

```swift
import TailwindPublishPlugin
```

## Usage

First, follow Tailwind's [installation guide](https://tailwindcss.com/docs/installation) for the CLI approach. When it comes time to specify the content paths, include any paths that may contain CSS classes that Tailwind should check for, such as theme files or site content:

```js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./Sources/**/*.swift",
    "./Content/**/*.{md,html,js}"
  ],
  // ...
}
```

To use the plugin, add it as part of your site's publishing steps:

```swift
try mysite().publish(using: [
    .installPlugin(.tailwind()),
    // ...
])
```

By default, the plugin assumes the source CSS file with the Tailwind directives lives at `Resources/style.css`, and will output the generated styles at `styles.css` in the `Output` folder. If the source styles live in a different location, or if the generated styles need to live in a different location within the `Output` folder, the defaults can be overridden:

```swift
try mysite().publish(using: [
    .installPlugin(.tailwind(
        inputPath: "Resources/my-theme/style.css",
        outputPath: "css/styles.css"
    )),
    // ...
])
```

Additionally, the plugin assumes Tailwind's config file lives at `tailwind.config.js`. If the config file lives in a different location, this defualt can also be overridden:

```swift
try mysite().publish(using: [
    .installPlugin(.tailwind(
        configPath: "npm/tailwind.config.js"
    )),
    // ...
])
```

To run Tailwind, the plugin uses `npx`, which relies on running in the directory where the NPM package lives, as determined by the folder which contains a `package.json`. By default, the plugin assumes the NPM package lives in the site's root directory. If the NPM package lives in a different location, the default can be overridden:

```swift
try mysite().publish(using: [
    .installPlugin(.tailwind(
        packagePath: "npm/package.json"
    )),
    // ...
])
```

Additionally, if `npx` cannot be found in the `$PATH`, its location can be specified with the `NPX_BINARY` environment variable. This can be helpful when generating a site from within Xcode, if modifications to the `PATH` environment variable that would help locate `npx` aren't inherited by Xcode.

<img width="982" alt="environment-variables" src="https://github.com/grantjbutler/TailwindPublishPlugin/assets/526054/e35aa4a2-641e-4ce3-bb0a-6efeebfbe29c" alt="Xcode's Scheme Editor, highlighting the 'Arguments' tab where environment variables can be specified to be used when running a CLI tool.">
