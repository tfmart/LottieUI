//
//  WrappedAnimationView.swift
//  
//
//  Created by Tomas Martins on 18/04/22.
//

import Lottie
import SwiftUI

protocol WrappedAnimationProtocol {
    var animationView: AnimationView! { get set }
    
    func update(withEngine renderingEngine: RenderingEngineOption)
}

#if os(iOS)
@available(iOS 13, *)
public final class WrappedAnimationView: UIView, WrappedAnimationProtocol {
    var animationView: AnimationView!
    var observer: AnimationProgressObserver
    
    init(animation: Lottie.Animation?, provider: AnimationImageProvider?) {
        let animationView = AnimationView(animation: animation, imageProvider: provider)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.animationView = animationView
        self.observer = .init(animationView: animationView,
                              onFrameChange: nil,
                              onProgressChange: nil)
        
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
    
    func update(withEngine renderingEngine: RenderingEngineOption) {
        let animation = animationView.animation
        let imageProvider = animationView.imageProvider
        animationView.removeFromSuperview()
        self.animationView = AnimationView(animation: animation,
                                             imageProvider: imageProvider,
                                             configuration: .init(renderingEngine: renderingEngine))
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.observer = .init(animationView: animationView,
                              onFrameChange: nil,
                              onProgressChange: nil)
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
    
    var renderingEngine: RenderingEngineOption {
        get { animationView.configuration.renderingEngine }
        set {
            guard newValue != animationView.configuration.renderingEngine else { return }
            update(withEngine: newValue)
        }
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
    
    var onFrame: ((CGFloat) -> Void)? {
        get { observer.onFrameChange }
        set { observer.onFrameChange = newValue }
    }
    
    var onProgress: ((CGFloat) -> Void)? {
        get { observer.onProgressChange }
        set { observer.onProgressChange = newValue }
    }
}
#endif
