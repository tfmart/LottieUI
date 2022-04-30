//
//  AsyncLottieView.swift
//
//
//  Created by Tomas Martins on 20/04/22.
//

import Lottie
import SwiftUI

public struct AsyncLottieView<Content: View>: View {
    let lottieView: (LottieView) -> LottieView
    let placeholder: () -> Content
    let url: URL
    let cacheProvider: AnimationCacheProvider?

    @State private var animation: Lottie.Animation?

    public init(
        url: URL,
        animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache,
        @ViewBuilder animation: @escaping (LottieView) -> LottieView,
        @ViewBuilder placeholder: @escaping () -> Content
    ) {
        self.url = url
        self.cacheProvider = animationCache
        self.lottieView = animation
        self.placeholder = placeholder
    }

    public var body: some View {
        VStack {
            if animation != nil {
                lottieView(lottie)
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

    var lottie: LottieView {
        LottieView.init(animation: self.animation!)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLottieView(url: .init(string: "https://assets3.lottiefiles.com/packages/lf20_hbdelex6.json")!) { lottieView in
            lottieView
        } placeholder: {
            Text("Loading")
        }
    }
}
