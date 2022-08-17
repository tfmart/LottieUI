//
//  AnimationProgressObserver.swift
//  
//
//  Created by Tomas Martins on 07/05/22.
//

import Lottie
import QuartzCore
import CoreGraphics

#if canImport(UIKit)
internal class AnimationProgressObserver {
    private var animationView: AnimationView
    internal var onFrameChange: ((CGFloat) -> Void)?
    internal var onProgressChange: ((CGFloat) -> Void)?
    private var lastAnimationProgress: CGFloat = -1
    private var lastAnimationFrame: CGFloat = -1
    
    internal init(animationView: AnimationView, onFrameChange: ((CGFloat) -> Void)? = nil, onProgressChange: ((CGFloat) -> Void)? = nil) {
        self.animationView = animationView
        self.onFrameChange = onFrameChange
        self.onProgressChange = onProgressChange
        let displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        displayLink.add(to: RunLoop.current, forMode: .default)
    }
    
    @objc private func displayLinkTick() {
        if let onFrameChange = onFrameChange,
           lastAnimationFrame != animationView.realtimeAnimationFrame {
            lastAnimationFrame = animationView.realtimeAnimationFrame
            onFrameChange(animationView.realtimeAnimationFrame)
        }
        
        if let onProgressChange = onProgressChange,
           lastAnimationProgress != animationView.realtimeAnimationProgress {
            lastAnimationProgress = animationView.realtimeAnimationProgress
            onProgressChange(animationView.realtimeAnimationProgress)
        }
    }
}
#endif
