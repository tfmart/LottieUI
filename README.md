# LottieUI

LottieUI allows you to use Lottie animations and all the advanced settings of Lottie's AnimationView, without having to give up on the declarative syntax of SwiftUI. Your Lottie animations will feel right at home alongside your SwiftUI views!

# Installation

// TO-DO

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
