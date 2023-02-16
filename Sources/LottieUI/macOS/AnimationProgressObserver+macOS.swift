//
//  AnimationProgressObserver+macOS.swift
//  
//
//  Created by Tomas Martins on 24/01/23.
//

import Lottie
import CoreVideo

#if !canImport(UIKit) && os(macOS)
class AnimationProgressObserver {
    private weak var animationView: LottieAnimationView?
    internal var onFrameChange: ((CGFloat) -> Void)?
    internal var onProgressChange: ((CGFloat) -> Void)?
    private var lastAnimationProgress: CGFloat = -1
    private var lastAnimationFrame: CGFloat = -1
    private var displayLink: CVDisplayLink?
    
    init(animationView: LottieAnimationView?,
         onFrameChange: ((CGFloat) -> Void)?,
         onProgressChange: ((CGFloat) -> Void)?) {
        self.animationView = animationView
        self.onFrameChange = onFrameChange
        self.onProgressChange = onProgressChange
        
        guard displayLink == nil else { return }
        
        var displayLink: CVDisplayLink?
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard let displayLink = displayLink else { return }
        
        self.displayLink = displayLink
        CVDisplayLinkSetOutputCallback(displayLink, { _, _, _, _, _, userData in
            let observer = Unmanaged<AnimationProgressObserver>.fromOpaque(userData!).takeUnretainedValue()
            observer.tick()
            return kCVReturnSuccess
        }, Unmanaged.passUnretained(self).toOpaque())
        
        CVDisplayLinkStart(displayLink)
    }
    
    deinit {
        stop()
    }
    
    func stop() {
        guard let displayLink = displayLink else { return }
        CVDisplayLinkStop(displayLink)
        self.displayLink = nil
    }
    
    private func tick() {
        DispatchQueue.main.async {
            guard let animationView = self.animationView else { return }
            let progress = animationView.realtimeAnimationProgress
            let frame = animationView.realtimeAnimationFrame
            self.onProgressChange?(progress)
            self.onFrameChange?(frame)
        }
        
    }
}
#endif
