# LottieUI

LottieUI allows you to use Lottie animations and all the advanced settings of Lottie's AnimationView, without having to give up on the declarative syntax of SwiftUI. Your Lottie animations will feel right at home alongside your SwiftUI views!

# Installation

## Swift Package Manager

In your project's `Package.swift` file, add `LottieUI` as a dependency:
```swift
import PackageDescription

let package = Package(
  name: "YourTestProject",
  platforms: [
       .iOS(.v13),
  ],
  dependencies: [
    .package(name: "LottieUI", url: "https://github.com/tfmart/LottieUI", from: "1.0.0")
  ],
  targets: [
    .target(name: "YourTestProject", dependencies: ["LottieUI"])
  ]
)
```

This package can be added to a project thorugh Swift Package Manager browser in Xcode. To do so, open Xcode and select `File -> Add Pacakges...` and type LottieUI or paste this repo's git URL in the search field in the top right of the screen.

# Usage

You can quickly present a local Lottie JSON file in your project with:

```swift
LottieView("MyAnimation")
```

By default, your animation will start playing automatically. To control whether the animation should be playing, simply use the `.play(_ isPlaying)` modifier:

```swift
struct ContentView: View {
    @State var isPlaying: Bool = true
    
    var body: some View {
        LottieView("MyAnimation")
            .play(isPlaying)
    }
}
```

To setup a Loop Mode for your animation, use `.loopMode(_ mode)`:

```swift
struct ContentView: View {
    var body: some View {
        LottieView("MyAnimation")
            .loopMode(.loop)
    }
}
```

It's also possible to configure playback speed, limit the range of frames to be displayed and observe the animation current frame in real time! To see all the available modifiers for `LottieView`, refer to the included documentation
