# LottieUI

LottieUI allows you to use [Lottie](https://airbnb.design/lottie/) animations and all the advanced settings of Lottie's AnimationView, without having to give up on the declarative syntax of SwiftUI. Your Lottie animations will feel right at home alongside your SwiftUI views!

### ✅ Requirements

Currently, LottieUI works only with iOS 13.0 or later.

# 🧑‍💻 Usage

You can quickly present a local Lottie JSON file in your project with:

```swift
LottieView("MyAnimation")
```

## 🛰 Remote animations

To load an animation from a URL, LottieUI provides `AsyncLottieView` that will display the animation from the provided url and a placeholder view while the animation is downloaded

```swift
let url = URL(string: "https://assets3.lottiefiles.com/packages/lf20_hbdelex6.json")!

AsyncLottieView(url: url) { lottieView in
    lottieView
} placeholder: {
    ProgressView()
}
```

## 🗂 Local files

It's also possible to load Lottie files from another Bundle or from a specific file path:

```swift
// Loads an animation from the provided bundle
LottieView("MyAnimation", bundle: DesignSystem.Bundle.main)
// Loads an animation file from the provided path
LottieView(path: "/path/to/animation.json")
```

# 🚀 Features

## ⏯ Play and Stop

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

## 🔁 Loop Mode

To setup a Loop Mode for your animation, use `.loopMode(_ mode)`:

```swift
struct ContentView: View {
    var body: some View {
        LottieView("MyAnimation")
            .loopMode(.loop)
    }
}
```

## 🖼 Current Frame and Progress

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
                // Perform action based on current progress
            }
    }
}
```

## 🏃 Speed

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

For more information check the included documentation in each public component and modifiers

# 🛠 Installation

## Swift Package Manager

In your project's `Package.swift` file, add `LottieUI` as a dependency:
```swift
.package(name: "LottieUI", url: "https://github.com/tfmart/LottieUI", from: "1.0.0")
```
