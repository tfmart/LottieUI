//
//  LottieView.swift
//  GuruDesignSystem
//
//  Created by Tomas Martins on 18/04/22.
//  Copyright © 2022 Tomas Martins. All rights reserved.
//

import Lottie
import SwiftUI
import Combine

#if os(macOS)
public typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
public typealias ViewRepresentable = UIViewRepresentable
#endif

/// A SwiftUI view that presents a Lottie animation that is stored locally. To present animation from a remote URL, use ``AsyncLottieView`` instead.
public struct LottieView: ViewRepresentable {
    #if os(macOS)
    public typealias UIViewType = WrappedAnimationNSView
    #elseif os(iOS)
    public typealias UIViewType = WrappedAnimationView
    #endif
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
        animationCache: AnimationCacheProvider? = DefaultAnimationCache.sharedCache
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
        animationCache: AnimationCacheProvider? = DefaultAnimationCache.sharedCache
    ) {
        self.contentSource = .filepath(path: path,
                                       imageProvider: imageProvider,
                                       animationCache: animationCache)
        self.configuration = .init()
    }
    
    internal init(animation: Lottie.LottieAnimation) {
        self.contentSource = .animation(animation)
        self.configuration = .init()
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
    /// - Warning: Progress observer only works when using the mainThread rendering engine. You can set it by using the `renderingEngine` modifier and setting to `.mainThread`
    func onFrame(_ completion: @escaping (AnimationFrameTime) -> Void) -> LottieView {
        self.configuration.currentFrame = completion
        return self
    }
    
    /// Adds an action to be performed each time the animation progress is changed
    /// - Parameter completion: The action to perform
    /// - Returns: A view that triggers `completion` when the progress changes
    /// - Warning: Progress observer only works when using the mainThread rendering engine. You can set it by using the `renderingEngine` modifier and setting to `.mainThread`
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
    
    /// Sets the rendering engine to be used by the animation. Default value is `.automatic`, which uses the `.coreAnimation` for supported animations or fall backs to `.mainThread` if the animation is not compatible
    /// - Parameter renderingEngine: The rendering engine implementation to use when displaying an animation
    /// - Returns: A view with a Lottie animation that uses the provided rendering engine
    func renderingEngine(_ renderingEngine: RenderingEngineOption) -> LottieView {
        self.configuration.renderingEngine = renderingEngine
        return self
    }
}

