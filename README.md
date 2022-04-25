# LottieUI

LottieUI allows you to use Lottie animations and all the advanced settings of Lottie's AnimationView, without having to give up on the declarative syntax of SwiftUI. Your Lottie animations will feel right at home alongside your SwiftUI views!

# Installation

## Swift Package Manager

In your project's `Package.swift` file, add `LottieUI` as a dependency:
```swift
dependencies: [
    .package(name: "LottieUI", url: "https://github.com/tfmart/LottieUI", from: "1.0.0"),
]
```

This package can be added to a project thorugh Swift Package Manager browser in Xcode. To do so, open Xcode and select `File -> Add Pacakges...` and type LottieUI or paste this repo's git URL in the search field in the top right of the screen.

# Usage

You can quickly present a local Lottie JSON file in your project with:

```swift
LottieView("MyAnimation")
```

## Play and Stop

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

## Loop Mode

To setup a Loop Mode for your animation, use `.loopMode(_ mode)`:

```swift
struct ContentView: View {
    var body: some View {
        LottieView("MyAnimation")
            .loopMode(.loop)
    }
}
```

## Current Frame and Progress

To observe the current frame beign displayed in the animation and perform an action based on it, use `.onFrame(_ completion:)`

```swift
struct ContentView: View {
    var body: some View {
        LottieView("MyAnimation")
            .onFrame { _ in
                // Perform action based on current frame
            }
    }
}
```

To observe the progress instead, use `.onProgress(_ completion:)`:

```swift
struct ContentView: View {
    var body: some View {
        LottieView("MyAnimation")
            .onProgress { _ in
                // Perform action based on current frame
            }
    }
}
```

## Speed

To set the speed of an animation, use `.speed(_ speed)`:

```swift
struct ContentView: View {
    var body: some View {
        LottieView("MyAnimation")
            .speed(2.0)
    }
}
```

There are many other options available such as:

- Limit the framerate of an animation with `.play(fromFrame: to:)`
- Define the background behavior of the animation with `.backgroundBehavior(_ backgroundBehavior)`
- Set the value provider for a specific keypath of the animation with `.valueProvider(_ valueProvider: keypath:)`

For more information check the included documentation in each public component and modifier
