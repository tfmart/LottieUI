//
//  LottieView+macOS.swift
//  
//
//  Created by Tomas Martins on 26/07/22.
//

import Lottie
import SwiftUI

#if os(macOS)
extension LottieView {
    public func makeNSView(context: Context) -> WrappedAnimationNSView {
        switch contentSource {
        case .bundle(let name,
                     let bundle,
                     let imageProvider,
                     let animationCache):
            let animation = Animation.named(name,
                                            bundle: bundle,
                                            subdirectory: nil,
                                            animationCache: animationCache)
            let provider = imageProvider ?? BundleImageProvider(bundle: bundle, searchPath: nil)
            let animationView = WrappedAnimationNSView(animation: animation, provider: provider)
            return animationView
            
        case .filepath(let path,
                       let imageProvider,
                       let animationCache):
            let animation = Animation.filepath(path,
                                               animationCache: animationCache)
            let provider = imageProvider ??
              FilepathImageProvider(filepath: URL(fileURLWithPath: path).deletingLastPathComponent().path)
            let animationView = WrappedAnimationNSView(animation: animation, provider: provider)
            return animationView
            
        case .animation(let animation):
            return .init(animation: animation,
                         provider: nil)
        }
    }
    
    public func updateNSView(_ nsView: WrappedAnimationNSView, context: Context) {
        DispatchQueue.main.async {
            nsView.renderingEngine = self.configuration.renderingEngine
            nsView.loopMode = self.configuration.loopMode
            nsView.speed = self.configuration.speed
            nsView.backgroundBehavior = self.configuration.backgroundBehavior
            nsView.speed = self.configuration.speed
            nsView.setValueProvider(configuration.valueProvider,
                                    keypath: configuration.keypath)
            if configuration.isPlaying {
                if let initialFrame = configuration.initialFrame,
                   let finalFrame = configuration.finalFrame {
                    nsView.play(
                        fromFrame: initialFrame,
                        toFrame:finalFrame,
                        loopMode: configuration.loopMode,
                        nil
                    )
                } else {
                    nsView.play(completion: nil)
                }
            } else {
                nsView.stop()
            }
        }
    }
}
#endif
