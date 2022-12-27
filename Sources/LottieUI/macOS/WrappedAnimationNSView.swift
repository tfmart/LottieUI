//
//  WrappedAnimationNSView.swift
//  
//
//  Created by Tomas Martins on 26/07/22.
//

#if os(macOS)
import AppKit
import Lottie

public class WrappedAnimationNSView: NSView, WrappedAnimationProtocol {
    var animationView: LottieAnimationView!
    
    public init(animation: Lottie.Animation?, provider: AnimationImageProvider?) {
        let animationView = LottieAnimationView(animation: animation, imageProvider: provider)
        animationView.contentMode = .scaleAspectFit
        
        self.animationView = animationView
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
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
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func update(withEngine renderingEngine: RenderingEngineOption) {
        let animation = animationView.animation
        let imageProvider = animationView.imageProvider
        animationView.removeFromSuperview()
        self.animationView = LottieAnimationView(animation: animation,
                                             imageProvider: imageProvider,
                                             configuration: .init(renderingEngine: renderingEngine))
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            animationView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            animationView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            animationView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

extension WrappedAnimationNSView {
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
}
#endif
