//
//  Lottie.swift
//  GuruDesignSystem
//
//  Created by Tomas Martins on 18/04/22.
//  Copyright © 2022 Tomas Martins. All rights reserved.
//

import Lottie
import SwiftUI

@available(iOS 13.0, *)
private struct Lottie: UIViewRepresentable {
    public typealias UIViewType = AnimationView
    // Initializer properties
    internal var name: String
    internal var bundle: Bundle = .main
    internal var imageProvider: AnimationImageProvider?
    internal var animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache
    
    // Modifier properties
    @State internal var loopMode: LottieLoopMode = .playOnce
    @State internal var isPlaying: Bool = true
    @State internal var frame: AnimationFrameTime = 0
    @State internal var initialFrame: AnimationFrameTime?
    @State internal var finalFrame: AnimationFrameTime?

    public init(
        _ name: String,
        bundle: Bundle = .main,
        imageProvider: AnimationImageProvider? = nil,
        animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache
    ) {
        self.name = name
        self.bundle = bundle
        self.imageProvider = imageProvider
        self.animationCache = animationCache
    }

    func makeUIView(context: Context) -> AnimationView {
        let animation = Animation.named(name, bundle: bundle, subdirectory: nil, animationCache: animationCache)
        let provider = imageProvider ?? BundleImageProvider(bundle: bundle, searchPath: nil)
        let animationView = AnimationView(animation: animation, imageProvider: provider)
        animationView.loopMode = loopMode
        return animationView
    }

    func updateUIView(_ uiView: AnimationView, context: Context) {
        uiView.loopMode = self.loopMode
        self.frame = uiView.currentFrame
        if isPlaying {
            if let initialFrame = initialFrame,
               let finalFrame = finalFrame {
                uiView.play(fromFrame: initialFrame, toFrame: finalFrame, loopMode: loopMode) { completed in
                    isPlaying = !completed
                }
            } else {
                uiView.play { completed in
                    isPlaying = !completed
                }
            }
        } else {
            uiView.stop()
            isPlaying = false
        }
    }
}

extension View where Self == Lottie {
    func loopMode(_ mode: LottieLoopMode) -> some View {
        self.loopMode = mode
        return self
    }

    func play(_ isPlaying: Bool) -> some View {
        self.isPlaying = isPlaying
        return self
    }

    func onFrame(_ completion: (AnimationFrameTime) -> Void) -> some View {
        completion(self.frame)
        return self
    }

    func play(fromFrame initialFrame: AnimationFrameTime?, to finalFrame: AnimationFrameTime?) -> some View {
        self.initialFrame = initialFrame
        self.finalFrame = finalFrame
        return self
    }
}

