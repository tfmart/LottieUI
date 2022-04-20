//
//  WrappedAnimationView.swift
//  
//
//  Created by Tomas Martins on 18/04/22.
//

import Lottie
import SwiftUI

public final class WrappedAnimationView: UIView {
    var animationView: AnimationView!
    var configuration: LottieConfiguration
    var displayLink: CADisplayLink?
    
    init(animation: Lottie.Animation?, provider: AnimationImageProvider?, configuration: LottieConfiguration) {
        let animationView = AnimationView(animation: animation, imageProvider: provider)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.animationView = animationView
        self.configuration = configuration
        
        super.init(frame: .zero)
        
        displayLink = CADisplayLink(target: self, selector: #selector(animationCallback))
        displayLink?.add(to: .current, forMode: RunLoop.Mode.default)
        
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            animationView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            animationView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            animationView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func animationCallback() {
        if animationView.isAnimationPlaying {
            configuration.frame = animationView.realtimeAnimationFrame
            configuration.progress = animationView.realtimeAnimationProgress
        }
    }
}


extension WrappedAnimationView {
    var loopMode: LottieLoopMode {
        get { animationView.loopMode }
        set { animationView.loopMode = newValue }
    }
    
    var speed: CGFloat {
        get { animationView.animationSpeed }
        set { animationView.animationSpeed = newValue }
    }
    
    var backgroundBehavior: LottieBackgroundBehavior {
        get { animationView.backgroundBehavior }
        set { animationView.backgroundBehavior = newValue }
    }
    
    func setValueProvider( _ valueProvider: AnyValueProvider?, keypath: AnimationKeypath?) {
        guard let valueProvider = valueProvider,
        let keypath = keypath else {
            return
        }
        animationView.setValueProvider(valueProvider, keypath: keypath)

    }

    func play(completion: LottieCompletionBlock?) {
        animationView.play(completion: completion)
    }
    
    func play(fromFrame: AnimationFrameTime,
              toFrame: AnimationFrameTime,
              loopMode: LottieLoopMode,
              _ completion: LottieCompletionBlock?) {
        animationView.play(fromFrame: fromFrame, toFrame: toFrame,
                           loopMode: loopMode, completion: completion)
    }

    func stop() {
        animationView.stop()
    }
}
