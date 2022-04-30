//
//  AsyncLottieView.swift
//
//
//  Created by Tomas Martins on 20/04/22.
//

import Lottie
import SwiftUI

/// A SwiftUI view to present a Lottie animation from a remote URL. To present an animation from a local file, use `LottieView` instead.
public struct AsyncLottieView<Content: View, Placeholder: View>: View {
    let lottieView: (LottieView) -> Content
    let placeholder: () -> Placeholder
    let url: URL
    let cacheProvider: AnimationCacheProvider?

    @State private var animation: Lottie.Animation?
    
    /// Creates a view that presents an animation from a remote URL
    /// - Parameters:
    ///   - url: The URL of the Lottie animation to be displayed
    ///   - animationCache: Cache to improve performance when playing recurrent animations.
    ///   - animation: A closure that takes a `LottieView` as an input and returns a view with the animation to be displayed. You can modify the animation view as needed before running it.
    ///   - placeholder: A closure that returns the view to be displayed until the Lottie is successfully downloaded.
    public init(
        url: URL,
        animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache,
        @ViewBuilder animation: @escaping (LottieView) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.cacheProvider = animationCache
        self.lottieView = animation
        self.placeholder = placeholder
    }

    public var body: some View {
        VStack {
            if let animation = animation {
                lottieView(LottieView(animation: animation))
            } else {
                placeholder()
            }
        }.onAppear {
            Animation.loadedFrom(url: url, closure: { animation in
              if let animation = animation {
                self.animation = animation
              }
            }, animationCache: cacheProvider)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLottieView(url: .init(string: "https://assets3.lottiefiles.com/packages/lf20_hbdelex6.json")!) { lottieView in
            lottieView
                .loopMode(.loop)
        } placeholder: {
            Text("Loading")
        }
    }
}
