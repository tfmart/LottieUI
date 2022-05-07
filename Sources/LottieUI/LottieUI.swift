//
//  Lottie.swift
//  GuruDesignSystem
//
//  Created by Tomas Martins on 18/04/22.
//  Copyright © 2022 Tomas Martins. All rights reserved.
//

import Lottie
import SwiftUI
import Combine

@available(iOS 13.0, *)
/// A SwiftUI view that presents a Lottie animation that is stored locally. To present animation from a remote URL, use `AsyncLottieView` instead.
public struct LottieView: UIViewRepresentable {
    public typealias UIViewType = WrappedAnimationView
    // Initializer properties
    internal var contentSource: LottieContentSource
    
    // Modifier properties
    @ObservedObject internal var configuration: LottieConfiguration
    
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
        self.contentSource = .bundle(name: name,
                                     bundle: bundle,
                                     imageProvider: imageProvider,
                                     animationCache: animationCache)
        self.configuration = .init()
    }
    
    /// Creates a view that displays a Lottie animation from a local file located at the provided path
    /// - Parameters:
    ///   - path: The path to the Lottie animation file
    ///   - imageProvider: Instance of `AnimationImageProvider`, which providers images to the animation view
    ///   - animationCache: Cache to improve performance when playing recurrent animations
    public init(
        path: String,
        imageProvider: AnimationImageProvider? = nil,
        animationCache: AnimationCacheProvider? = LRUAnimationCache.sharedCache
    ) {
        self.contentSource = .filepath(path: path,
                                       imageProvider: imageProvider,
                                       animationCache: animationCache)
        self.configuration = .init()
    }
    
    internal init(animation: Lottie.Animation) {
        self.contentSource = .animation(animation)
        self.configuration = .init()
    }

    public func makeUIView(context: Context) -> WrappedAnimationView {
        switch contentSource {
        case .bundle(let name,
                     let bundle,
                     let imageProvider,
                     let animationCache):
            let animation = Animation.named(name,
                                            bundle: bundle,
                                            subdirectory: nil,
                                            animationCache: animationCache)
            let provider = imageProvider ?? BundleImageProvider(bundle: bundle, searchPath: nil)
            let animationView = WrappedAnimationView(animation: animation, provider: provider,
                                                     configuration: configuration)
            return animationView
            
        case .filepath(let path,
                       let imageProvider,
                       let animationCache):
            let animation = Animation.filepath(path,
                                               animationCache: animationCache)
            let provider = imageProvider ??
              FilepathImageProvider(filepath: URL(fileURLWithPath: path).deletingLastPathComponent().path)
            let animationView = WrappedAnimationView(animation: animation, provider: provider, configuration: configuration)
            return animationView
            
        case .animation(let animation):
            return .init(animation: animation,
                         provider: nil,
                         configuration: configuration)
        }
    }

    public func updateUIView(_ uiView: WrappedAnimationView, context: Context) {
        DispatchQueue.main.async {
            uiView.loopMode = self.configuration.loopMode
            uiView.speed = self.configuration.speed
            uiView.backgroundBehavior = self.configuration.backgroundBehavior
            uiView.observer = .init(animationView: uiView.animationView,
                                    onFrameChange: self.configuration.currentFrame,
                                    onProgressChange: self.configuration.currentProgress)
            uiView.setValueProvider(configuration.valueProvider,
                                    keypath: configuration.keypath)
            if configuration.isPlaying {
                if let initialFrame = configuration.initialFrame,
                   let finalFrame = configuration.finalFrame {
                    uiView.play(
                        fromFrame: initialFrame,
                        toFrame:finalFrame,
                        loopMode: configuration.loopMode,
                        nil
                    )
                } else {
                    uiView.play(completion: nil)
                }
            } else {
                uiView.stop()
            }
        }
    }
}

public extension LottieView {
    /// Sets the loop mode when the Lottie animation is beign played
    /// - Parameter mode: A `LottieLoopMode` configuration to setup the loop mode of the animation
    /// - Returns: A Lottie view with the loop mode supplied
    func loopMode(_ mode: LottieLoopMode) -> LottieView {
        self.configuration.loopMode = mode
        return self
    }
    
    /// Control whether the view will be playing the animation or not
    /// - Parameter isPlaying: A Boolean value indicating whether the animation is being played
    /// - Returns: A Lottie view that can control whether the view is being played or not
    func play(_ isPlaying: Bool) -> LottieView {
        self.configuration.isPlaying = isPlaying
        return self
    }
    
    /// Adds an action to be performed when every time the frame of an animation is changed
    /// - Parameter completion: The action to perform
    /// - Returns: A view that triggers `completion` when the frame changes
    func onFrame(_ completion: @escaping (AnimationFrameTime) -> Void) -> LottieView {
        self.configuration.currentFrame = completion
        return self
    }
    
    /// Adds an action to be performed each time the animation progress is changed
    /// - Parameter completion: The action to perform
    /// - Returns: A view that triggers `completion` when the progress changes
    func onProgress(_ completion: @escaping (AnimationProgressTime) -> Void) -> LottieView {
        self.configuration.currentProgress = completion
        return self
    }
    
    /// Control which frames from the animation framerate will be displayed by the animation. If either `initialFrame` or `finalFrame` parameters are `nil`, the view will animate the entire framerate
    /// - Parameters:
    ///   - initialFrame: The start frame of the animation. If the paramter is `nil`, the view will animate the entire framerate
    ///   - finalFrame: The end frame of the animation. If the paramter is `nil`, the view will animate the entire framerate
    /// - Returns: A view that displays a specific range of an animation's framerate
    func play(fromFrame initialFrame: AnimationFrameTime?, to finalFrame: AnimationFrameTime?) -> LottieView {
        self.configuration.initialFrame = initialFrame
        self.configuration.finalFrame = finalFrame
        return self
    }
    
    /// Sets the playback speed of the animation
    /// - Parameter speed: A `CGFloat` value that indicates the speed of the animation playback. Default value is 1. A lower value indicates a slower speed and a higher one indicates a faster playback speed
    /// - Returns: A view that plays the animation at the provided speed
    func speed(_ speed: CGFloat) -> LottieView {
        self.configuration.speed = speed
        return self
    }
    
    /// Sets a value provider for a specific keypath, allowing to change an Lottie animation properties in real time
    /// - Parameters:
    ///   - valueProvider: The new value provider for the properties
    ///   - keypath: The kyepath used to search for properties
    /// - Returns: A view with an animation with the altered properties, if the keypath is valid
    func valueProvider(_ valueProvider: AnyValueProvider?, keypath: AnimationKeypath?) -> LottieView {
        self.configuration.valueProvider = valueProvider
        self.configuration.keypath = keypath
        return self
    }
    
    /// Sets the behavior of the animation when the view is moved to the background
    /// - Parameter backgroundBehavior: The expected behavior for when the view is moved to the background
    /// - Returns: A view with a Lottie animation with the supplied behavior setting
    func backgroundBehavior(_ backgroundBehavior: LottieBackgroundBehavior) -> LottieView {
        self.configuration.backgroundBehavior = backgroundBehavior
        return self
    }
}

