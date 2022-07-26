//
//  File.swift
//  
//
//  Created by Tomas Martins on 18/04/22.
//

import SwiftUI
import Lottie

public class LottieConfiguration: ObservableObject {
    @Published internal var loopMode: LottieLoopMode = .playOnce
    @Published internal var isPlaying: Bool = true
    @Published internal var initialFrame: AnimationFrameTime?
    @Published internal var finalFrame: AnimationFrameTime?
    @Published internal var speed: CGFloat = 1.0
    @Published internal var valueProvider: AnyValueProvider?
    @Published internal var keypath: AnimationKeypath?
    @Published internal var backgroundBehavior: LottieBackgroundBehavior = .pause
    @Published internal var currentProgress: ((AnimationProgressTime) -> Void)?
    @Published internal var currentFrame: ((AnimationFrameTime) -> Void)?
    @Published internal var renderingEngine: RenderingEngineOption = .automatic
}
