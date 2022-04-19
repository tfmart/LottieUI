//
//  WrappedAnimationView.swift
//  
//
//  Created by Tomas Martins on 18/04/22.
//

import UIKit
import Lottie

public final class WrappedAnimationView: UIView {
    var animationView: AnimationView!
    
    init(animation: Animation?, provider: AnimationImageProvider?) {
        let animationView = AnimationView(animation: animation, imageProvider: provider)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.animationView = animationView
        
        super.init(frame: .zero)
        
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
}


extension WrappedAnimationView {
    var loopMode: LottieLoopMode {
        get { animationView.loopMode }
        set { animationView.loopMode = newValue }
    }
    
    var currentFrame: AnimationFrameTime {
        get { animationView.currentFrame }
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
