//
//  File.swift
//  
//
//  Created by Tomas Martins on 18/04/22.
//

import SwiftUI
import Lottie

public class LottieConfiguration: ObservableObject {
    @Published internal var loopMode: LottieLoopMode = .playOnce {
        didSet {
            print("Set loopMode")
        }
    }
    @Published internal var isPlaying: Bool = true {
        didSet {
            print("Set isPlaying")
        }
    }
    @Published internal var initialFrame: AnimationFrameTime? {
        didSet {
            print("Set initialFrame")
        }
    }
    @Published internal var finalFrame: AnimationFrameTime? {
        didSet {
            print("Set finalFrame")
        }
    }
    @Published internal var speed: CGFloat = 1.0 {
        didSet {
            print("Set speed")
        }
    }
    @Published internal var valueProvider: AnyValueProvider? {
        didSet {
            print("Set valueProvider")
        }
    }
    @Published internal var keypath: AnimationKeypath? {
        didSet {
            print("Set keypath")
        }
    }
    @Published internal var backgroundBehavior: LottieBackgroundBehavior = .pause {
        didSet {
            print("Set backgroundBehavior")
        }
    }
    
    @Published internal var currentProgress: ((AnimationProgressTime) -> Void)? {
        didSet {
            print("Set currentProgress")
        }
    }
    @Published internal var currentFrame: ((AnimationFrameTime) -> Void)? {
        didSet {
            print("Set currentFrame")
        }
    }
}
