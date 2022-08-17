//
//  LottieView+iOS.swift
//  
//
//  Created by Tomas Martins on 26/07/22.
//

import Lottie
import SwiftUI

#if os(iOS)
public extension LottieView {
    func makeUIView(context: Context) -> WrappedAnimationView {
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
            let animationView = WrappedAnimationView(animation: animation, provider: provider)
            return animationView
            
        case .filepath(let path,
                       let imageProvider,
                       let animationCache):
            let animation = Animation.filepath(path,
                                               animationCache: animationCache)
            let provider = imageProvider ??
              FilepathImageProvider(filepath: URL(fileURLWithPath: path).deletingLastPathComponent().path)
            let animationView = WrappedAnimationView(animation: animation, provider: provider)
            return animationView
            
        case .animation(let animation):
            return .init(animation: animation,
                         provider: nil)
        }
    }

    func updateUIView(_ uiView: WrappedAnimationView, context: Context) {
        DispatchQueue.main.async {
            uiView.renderingEngine = self.configuration.renderingEngine
            uiView.loopMode = self.configuration.loopMode
            uiView.speed = self.configuration.speed
            uiView.backgroundBehavior = self.configuration.backgroundBehavior
            uiView.onFrame = self.configuration.currentFrame
            uiView.onProgress = self.configuration.currentProgress
            uiView.setValueProvider(configuration.valueProvider,
                                    keypath: configuration.keypath)
            if configuration.isPlaying {
                if let initialFrame = configuration.initialFrame,
                   let finalFrame = configuration.finalFrame {
                    uiView.play(
                        fromFrame: initialFrame,
                        toFrame:finalFrame,
                        loopMode: configuration.loopMode,
                        nil
                    )
                } else {
                    uiView.play(completion: nil)
                }
            } else {
                uiView.stop()
            }
        }
    }
}
#endif
