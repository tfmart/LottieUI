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
    @Published internal var frame: AnimationFrameTime = 0
    @Published internal var initialFrame: AnimationFrameTime?
    @Published internal var finalFrame: AnimationFrameTime?
    @Published internal var speed: CGFloat = 1.0
}
