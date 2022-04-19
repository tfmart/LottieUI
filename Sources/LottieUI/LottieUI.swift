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
public struct Lottie: UIViewRepresentable {
    public typealias UIViewType = WrappedAnimationView
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
    
    /// Creates a view that displays a Lottie animation
    /// - Parameters:
    ///   - name: The name of the asset to be displayed by the `Lottie` view
    ///   - bundle: The bundle in which the asset is located
    ///   - imageProvider: Instance of `AnimationImageProvider`, which providers images to the animation view
    ///   - animationCache: Cache to improve performance when playing recurrent animations
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

    public func makeUIView(context: Context) -> WrappedAnimationView {
        let animation = Animation.named(name, bundle: bundle, subdirectory: nil, animationCache: animationCache)
        let provider = imageProvider ?? BundleImageProvider(bundle: bundle, searchPath: nil)
        let animationView = WrappedAnimationView(animation: animation, provider: provider)
        return animationView
    }

    public func updateUIView(_ uiView: WrappedAnimationView, context: Context) {
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

public extension Lottie {
    /// Sets the loop mode when the Lottie animation is beign played
    /// - Parameter mode: A `LottieLoopMode` configuration to setup the loop mode of the animation
    /// - Returns: A Lottie view with the loop mode supplied
    func loopMode(_ mode: LottieLoopMode) -> some View {
        self.loopMode = mode
        return self
    }
    
    /// Control whether the view will be playing the animation or not
    /// - Parameter isPlaying: A Boolean value indicating whether the animation is being played
    /// - Returns: A Lottie view that can control whether the view is being played or not
    func play(_ isPlaying: Bool) -> some View {
        self.isPlaying = isPlaying
        return self
    }
    
    /// Adds an action to be performed when every time the frame of an animation is changed
    /// - Parameter completion: The action to perform
    /// - Returns: A view that triggers `completion` when the frame changes
    func onFrame(_ completion: (AnimationFrameTime) -> Void) -> some View {
        completion(self.frame)
        return self
    }
    
    /// Control which frames from the animation framerate will be displayed by the animation. If either `initialFrame` or `finalFrame` parameters are `nil`, the view will animate the entire framerate
    /// - Parameters:
    ///   - initialFrame: The start frame of the animation. If the paramter is `nil`, the view will animate the entire framerate
    ///   - finalFrame: The end frame of the animation. If the paramter is `nil`, the view will animate the entire framerate
    /// - Returns: A view that displays a specific range of an animation's framerate
    func play(fromFrame initialFrame: AnimationFrameTime?, to finalFrame: AnimationFrameTime?) -> some View {
        self.initialFrame = initialFrame
        self.finalFrame = finalFrame
        return self
    }
}

